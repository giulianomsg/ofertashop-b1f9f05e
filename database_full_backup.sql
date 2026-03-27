--
-- PostgreSQL database cluster dump
--

-- Started on 2026-03-26 23:51:53

\restrict dNJTONN7dc3tDwwJcL54bMNLdRucXMmxbnNjWIni8AHdRk2dhQoilbWbf7cn79M

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






\unrestrict dNJTONN7dc3tDwwJcL54bMNLdRucXMmxbnNjWIni8AHdRk2dhQoilbWbf7cn79M

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

\restrict c2CliJBk6XloAF08uabTI6PrQuTHNYnn1fadBHrDd5cPfGzAGTVYU1xZ79JaYq9

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

-- Started on 2026-03-26 23:52:00

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

-- Completed on 2026-03-26 23:52:17

--
-- PostgreSQL database dump complete
--

\unrestrict c2CliJBk6XloAF08uabTI6PrQuTHNYnn1fadBHrDd5cPfGzAGTVYU1xZ79JaYq9

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict 5XcHDDeghSdv6ZISUNb1IcKrMwEWGoHApZVcIQoX1MhL34XMSQFMZCkJgbRzNmT

-- Dumped from database version 17.6
-- Dumped by pg_dump version 18.0

-- Started on 2026-03-26 23:52:17

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
-- TOC entry 4864 (class 0 OID 0)
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
-- TOC entry 4865 (class 0 OID 0)
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
-- TOC entry 4866 (class 0 OID 0)
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
-- TOC entry 4867 (class 0 OID 0)
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
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 3
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- TOC entry 1199 (class 1247 OID 16738)
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- TOC entry 1223 (class 1247 OID 16879)
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- TOC entry 1196 (class 1247 OID 16732)
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- TOC entry 1193 (class 1247 OID 16727)
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1241 (class 1247 OID 16982)
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
-- TOC entry 1253 (class 1247 OID 17055)
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1235 (class 1247 OID 16960)
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1244 (class 1247 OID 16992)
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- TOC entry 1229 (class 1247 OID 16921)
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
-- TOC entry 1313 (class 1247 OID 17497)
-- Name: app_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.app_role AS ENUM (
    'admin',
    'editor',
    'viewer'
);


ALTER TYPE public.app_role OWNER TO postgres;

--
-- TOC entry 1301 (class 1247 OID 17358)
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
-- TOC entry 1265 (class 1247 OID 17126)
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
-- TOC entry 1268 (class 1247 OID 17141)
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- TOC entry 1307 (class 1247 OID 17400)
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
-- TOC entry 1304 (class 1247 OID 17371)
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
-- TOC entry 1289 (class 1247 OID 17281)
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- TOC entry 467 (class 1255 OID 16540)
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
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 467
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- TOC entry 531 (class 1255 OID 16709)
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
-- TOC entry 436 (class 1255 OID 16539)
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
-- TOC entry 4872 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- TOC entry 448 (class 1255 OID 16538)
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
-- TOC entry 4874 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- TOC entry 463 (class 1255 OID 16547)
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
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 463
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- TOC entry 519 (class 1255 OID 16568)
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
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 519
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- TOC entry 426 (class 1255 OID 16549)
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
-- TOC entry 4894 (class 0 OID 0)
-- Dependencies: 426
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- TOC entry 541 (class 1255 OID 16559)
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
-- TOC entry 532 (class 1255 OID 16560)
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
-- TOC entry 514 (class 1255 OID 16570)
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
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- TOC entry 469 (class 1255 OID 16387)
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
-- TOC entry 530 (class 1255 OID 17596)
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
-- TOC entry 427 (class 1255 OID 17598)
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
-- TOC entry 429 (class 1255 OID 17597)
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
-- TOC entry 446 (class 1255 OID 22297)
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
-- TOC entry 534 (class 1255 OID 17594)
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
-- TOC entry 432 (class 1255 OID 17595)
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
-- TOC entry 537 (class 1255 OID 22501)
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
-- TOC entry 480 (class 1255 OID 22424)
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
-- TOC entry 475 (class 1255 OID 23730)
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
-- TOC entry 511 (class 1255 OID 17593)
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
-- TOC entry 526 (class 1255 OID 17393)
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
-- TOC entry 528 (class 1255 OID 17472)
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
-- TOC entry 464 (class 1255 OID 17405)
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
-- TOC entry 494 (class 1255 OID 17355)
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
-- TOC entry 453 (class 1255 OID 17158)
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
-- TOC entry 451 (class 1255 OID 17401)
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
-- TOC entry 479 (class 1255 OID 17412)
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
-- TOC entry 435 (class 1255 OID 17157)
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
-- TOC entry 495 (class 1255 OID 17471)
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
-- TOC entry 437 (class 1255 OID 17155)
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
-- TOC entry 452 (class 1255 OID 17382)
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- TOC entry 499 (class 1255 OID 17465)
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- TOC entry 508 (class 1255 OID 17222)
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
-- TOC entry 500 (class 1255 OID 17278)
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
-- TOC entry 535 (class 1255 OID 17197)
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
-- TOC entry 483 (class 1255 OID 17196)
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
-- TOC entry 491 (class 1255 OID 17195)
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
-- TOC entry 450 (class 1255 OID 17334)
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
-- TOC entry 484 (class 1255 OID 17209)
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
-- TOC entry 434 (class 1255 OID 17261)
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
-- TOC entry 443 (class 1255 OID 17335)
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
-- TOC entry 478 (class 1255 OID 17277)
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
-- TOC entry 481 (class 1255 OID 17341)
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
-- TOC entry 470 (class 1255 OID 17211)
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
-- TOC entry 540 (class 1255 OID 17339)
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
-- TOC entry 476 (class 1255 OID 17338)
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
-- TOC entry 497 (class 1255 OID 17212)
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
-- TOC entry 348 (class 1259 OID 16525)
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
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- TOC entry 368 (class 1259 OID 17078)
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
-- TOC entry 362 (class 1259 OID 16883)
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
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- TOC entry 353 (class 1259 OID 16681)
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
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 353
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- TOC entry 347 (class 1259 OID 16518)
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
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- TOC entry 357 (class 1259 OID 16770)
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
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- TOC entry 356 (class 1259 OID 16758)
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
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- TOC entry 355 (class 1259 OID 16745)
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
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 355
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- TOC entry 365 (class 1259 OID 16995)
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
-- TOC entry 367 (class 1259 OID 17068)
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
-- TOC entry 4981 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- TOC entry 364 (class 1259 OID 16965)
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
-- TOC entry 366 (class 1259 OID 17028)
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
-- TOC entry 363 (class 1259 OID 16933)
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
-- TOC entry 346 (class 1259 OID 16507)
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
-- TOC entry 4986 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- TOC entry 345 (class 1259 OID 16506)
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
-- TOC entry 4988 (class 0 OID 0)
-- Dependencies: 345
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- TOC entry 360 (class 1259 OID 16812)
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
-- TOC entry 4990 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- TOC entry 361 (class 1259 OID 16830)
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
-- TOC entry 4992 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- TOC entry 349 (class 1259 OID 16533)
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- TOC entry 4994 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- TOC entry 354 (class 1259 OID 16711)
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
-- TOC entry 4996 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- TOC entry 4997 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- TOC entry 4998 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- TOC entry 4999 (class 0 OID 0)
-- Dependencies: 354
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- TOC entry 359 (class 1259 OID 16797)
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
-- TOC entry 5001 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- TOC entry 358 (class 1259 OID 16788)
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
-- TOC entry 5003 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- TOC entry 5004 (class 0 OID 0)
-- Dependencies: 358
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- TOC entry 344 (class 1259 OID 16495)
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
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 344
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- TOC entry 411 (class 1259 OID 27144)
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
-- TOC entry 410 (class 1259 OID 27121)
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
-- TOC entry 416 (class 1259 OID 28470)
-- Name: admin_settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_settings (
    key text NOT NULL,
    value jsonb NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.admin_settings OWNER TO postgres;

--
-- TOC entry 384 (class 1259 OID 17503)
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
-- TOC entry 385 (class 1259 OID 17516)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role public.app_role DEFAULT 'viewer'::public.app_role NOT NULL
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- TOC entry 390 (class 1259 OID 17588)
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
-- TOC entry 422 (class 1259 OID 29710)
-- Name: amazon_product_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.amazon_product_mappings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid,
    amazon_item_id character varying(50) NOT NULL,
    amazon_current_price numeric(10,2),
    amazon_original_price numeric(10,2),
    amazon_status character varying(50),
    amazon_rating numeric(3,2),
    amazon_review_count integer,
    last_synced_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.amazon_product_mappings OWNER TO postgres;

--
-- TOC entry 387 (class 1259 OID 17545)
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
-- TOC entry 391 (class 1259 OID 22129)
-- Name: brands; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.brands OWNER TO postgres;

--
-- TOC entry 394 (class 1259 OID 22173)
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
-- TOC entry 407 (class 1259 OID 22458)
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
-- TOC entry 406 (class 1259 OID 22441)
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
-- TOC entry 405 (class 1259 OID 22426)
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
-- TOC entry 413 (class 1259 OID 27177)
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
-- TOC entry 414 (class 1259 OID 27200)
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
-- TOC entry 412 (class 1259 OID 27166)
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
-- TOC entry 392 (class 1259 OID 22142)
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
-- TOC entry 403 (class 1259 OID 22381)
-- Name: newsletter_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.newsletter_products (
    newsletter_id uuid NOT NULL,
    product_id uuid NOT NULL
);


ALTER TABLE public.newsletter_products OWNER TO postgres;

--
-- TOC entry 402 (class 1259 OID 22370)
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
-- TOC entry 393 (class 1259 OID 22160)
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
-- TOC entry 404 (class 1259 OID 22408)
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
-- TOC entry 400 (class 1259 OID 22328)
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
-- TOC entry 399 (class 1259 OID 22254)
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
-- TOC entry 401 (class 1259 OID 22349)
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
-- TOC entry 386 (class 1259 OID 17530)
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
    available_quantity integer,
    extra_metadata jsonb DEFAULT '{}'::jsonb
);

ALTER TABLE ONLY public.products REPLICA IDENTITY FULL;


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 386
-- Name: COLUMN products.external_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.products.external_id IS 'ID do produto na plataforma externa (ex.: Shopee) para sincronização';


--
-- TOC entry 389 (class 1259 OID 17573)
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
-- TOC entry 388 (class 1259 OID 17557)
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
-- TOC entry 415 (class 1259 OID 27214)
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
-- TOC entry 408 (class 1259 OID 25968)
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
    created_at timestamp with time zone DEFAULT now(),
    offer_valid_from timestamp with time zone,
    offer_valid_to timestamp with time zone,
    shopee_extra_data jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.shopee_product_mappings OWNER TO postgres;

--
-- TOC entry 409 (class 1259 OID 25986)
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
-- TOC entry 396 (class 1259 OID 22202)
-- Name: special_page_products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.special_page_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    special_page_id uuid NOT NULL,
    product_id uuid NOT NULL
);


ALTER TABLE public.special_page_products OWNER TO postgres;

--
-- TOC entry 395 (class 1259 OID 22188)
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
-- TOC entry 397 (class 1259 OID 22222)
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
-- TOC entry 398 (class 1259 OID 22234)
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
-- TOC entry 383 (class 1259 OID 17475)
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
-- TOC entry 417 (class 1259 OID 29617)
-- Name: messages_2026_03_23; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_23 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_23 OWNER TO supabase_admin;

--
-- TOC entry 418 (class 1259 OID 29629)
-- Name: messages_2026_03_24; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_24 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_24 OWNER TO supabase_admin;

--
-- TOC entry 419 (class 1259 OID 29641)
-- Name: messages_2026_03_25; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_25 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_25 OWNER TO supabase_admin;

--
-- TOC entry 420 (class 1259 OID 29653)
-- Name: messages_2026_03_26; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_26 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_26 OWNER TO supabase_admin;

--
-- TOC entry 421 (class 1259 OID 29665)
-- Name: messages_2026_03_27; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_27 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_27 OWNER TO supabase_admin;

--
-- TOC entry 423 (class 1259 OID 30848)
-- Name: messages_2026_03_28; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_28 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_28 OWNER TO supabase_admin;

--
-- TOC entry 424 (class 1259 OID 31994)
-- Name: messages_2026_03_29; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_29 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_29 OWNER TO supabase_admin;

--
-- TOC entry 425 (class 1259 OID 33147)
-- Name: messages_2026_03_30; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.messages_2026_03_30 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2026_03_30 OWNER TO supabase_admin;

--
-- TOC entry 369 (class 1259 OID 17120)
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- TOC entry 372 (class 1259 OID 17143)
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
-- TOC entry 371 (class 1259 OID 17142)
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
-- TOC entry 374 (class 1259 OID 17167)
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
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 374
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 378 (class 1259 OID 17286)
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
-- TOC entry 379 (class 1259 OID 17299)
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
-- TOC entry 373 (class 1259 OID 17159)
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
-- TOC entry 375 (class 1259 OID 17177)
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
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 375
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- TOC entry 376 (class 1259 OID 17226)
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
-- TOC entry 377 (class 1259 OID 17240)
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
-- TOC entry 380 (class 1259 OID 17309)
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
-- TOC entry 3835 (class 0 OID 0)
-- Name: messages_2026_03_23; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_23 FOR VALUES FROM ('2026-03-23 00:00:00') TO ('2026-03-24 00:00:00');


--
-- TOC entry 3836 (class 0 OID 0)
-- Name: messages_2026_03_24; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_24 FOR VALUES FROM ('2026-03-24 00:00:00') TO ('2026-03-25 00:00:00');


--
-- TOC entry 3837 (class 0 OID 0)
-- Name: messages_2026_03_25; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_25 FOR VALUES FROM ('2026-03-25 00:00:00') TO ('2026-03-26 00:00:00');


--
-- TOC entry 3838 (class 0 OID 0)
-- Name: messages_2026_03_26; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_26 FOR VALUES FROM ('2026-03-26 00:00:00') TO ('2026-03-27 00:00:00');


--
-- TOC entry 3839 (class 0 OID 0)
-- Name: messages_2026_03_27; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_27 FOR VALUES FROM ('2026-03-27 00:00:00') TO ('2026-03-28 00:00:00');


--
-- TOC entry 3840 (class 0 OID 0)
-- Name: messages_2026_03_28; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_28 FOR VALUES FROM ('2026-03-28 00:00:00') TO ('2026-03-29 00:00:00');


--
-- TOC entry 3841 (class 0 OID 0)
-- Name: messages_2026_03_29; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_29 FOR VALUES FROM ('2026-03-29 00:00:00') TO ('2026-03-30 00:00:00');


--
-- TOC entry 3842 (class 0 OID 0)
-- Name: messages_2026_03_30; Type: TABLE ATTACH; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2026_03_30 FOR VALUES FROM ('2026-03-30 00:00:00') TO ('2026-03-31 00:00:00');


--
-- TOC entry 3852 (class 2604 OID 16510)
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- TOC entry 4783 (class 0 OID 16525)
-- Dependencies: 348
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4800 (class 0 OID 17078)
-- Dependencies: 368
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4794 (class 0 OID 16883)
-- Dependencies: 362
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4785 (class 0 OID 16681)
-- Dependencies: 353
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.identities VALUES ('18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{"sub": "18826abb-41b4-49d6-a62d-1ec9b3a0ddb6", "email": "giulianomsg@gmail.com", "email_verified": false, "phone_verified": false}', 'email', '2026-03-11 03:11:05.1897+00', '2026-03-11 03:11:05.189767+00', '2026-03-11 03:11:05.189767+00', DEFAULT, 'faa3c8bc-d72c-4e3c-bf4e-504363dd9cf4');
INSERT INTO auth.identities VALUES ('2374d4c0-d9a8-455f-925d-f42f42f3522d', '2374d4c0-d9a8-455f-925d-f42f42f3522d', '{"sub": "2374d4c0-d9a8-455f-925d-f42f42f3522d", "email": "gmgarcia@educacao.riopreto.sp.gov.br", "full_name": "Giuliano Moretti", "email_verified": true, "phone_verified": false}', 'email', '2026-03-15 18:38:52.015842+00', '2026-03-15 18:38:52.015891+00', '2026-03-15 18:38:52.015891+00', DEFAULT, 'ea4846c0-1e3f-48b6-8777-9c992f28f8ae');
INSERT INTO auth.identities VALUES ('ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{"sub": "ae8dfd8c-5182-41d7-9a4a-c02ebba36890", "email": "amandacsagres@gmail.com", "full_name": "Amanda Cristine Sagres", "email_verified": true, "phone_verified": false}', 'email', '2026-03-16 20:09:55.952579+00', '2026-03-16 20:09:55.952633+00', '2026-03-16 20:09:55.952633+00', DEFAULT, '657419e6-8c01-44e4-b6c1-2bde2f319fb0');


--
-- TOC entry 4782 (class 0 OID 16518)
-- Dependencies: 347
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4789 (class 0 OID 16770)
-- Dependencies: 357
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.mfa_amr_claims VALUES ('943a8995-1ad4-4c7f-8117-cf869d72dedc', '2026-03-16 20:10:03.595461+00', '2026-03-16 20:10:03.595461+00', 'otp', 'f754e5c2-20ea-426b-bcb5-03820ce65b63');
INSERT INTO auth.mfa_amr_claims VALUES ('6a2600de-650c-4ef8-a318-fe600e3c1ed1', '2026-03-16 23:49:17.672538+00', '2026-03-16 23:49:17.672538+00', 'password', '9adfe2f5-fb85-4584-8af6-2f3e1086262a');
INSERT INTO auth.mfa_amr_claims VALUES ('4a1e99ca-e400-4c54-8b0d-676fd7316b76', '2026-03-24 11:38:43.537532+00', '2026-03-24 11:38:43.537532+00', 'password', '0eb06b2c-0dba-4084-916a-90f6735d2983');
INSERT INTO auth.mfa_amr_claims VALUES ('83283a1d-bfbd-49fc-9f0a-44997689343e', '2026-03-24 17:59:32.202916+00', '2026-03-24 17:59:32.202916+00', 'password', 'c4f690f3-686a-41c3-ad8c-dbd512e52276');
INSERT INTO auth.mfa_amr_claims VALUES ('d9be39d9-ce61-4f53-bd1b-f7b109799574', '2026-03-26 19:47:55.440672+00', '2026-03-26 19:47:55.440672+00', 'password', '88070dfd-9008-42f0-a8b0-279c5d2eb28e');
INSERT INTO auth.mfa_amr_claims VALUES ('a3ea298a-129c-410d-ad67-51d05ccb937f', '2026-03-26 19:51:50.844988+00', '2026-03-26 19:51:50.844988+00', 'password', '4e32d02c-05f2-4275-bcb4-673a1745f00a');
INSERT INTO auth.mfa_amr_claims VALUES ('c1a54303-71fd-40a1-9aad-7e563b195470', '2026-03-26 22:31:18.511143+00', '2026-03-26 22:31:18.511143+00', 'password', 'a8d55bea-8e5c-45b8-b32f-721347bccfd7');
INSERT INTO auth.mfa_amr_claims VALUES ('81582d8b-8531-47ba-8f21-f41a6589a5c4', '2026-03-27 01:26:24.111815+00', '2026-03-27 01:26:24.111815+00', 'password', '5de372f9-eb7d-4b6c-ad3f-ef44a35f35e3');


--
-- TOC entry 4788 (class 0 OID 16758)
-- Dependencies: 356
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4787 (class 0 OID 16745)
-- Dependencies: 355
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4797 (class 0 OID 16995)
-- Dependencies: 365
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4799 (class 0 OID 17068)
-- Dependencies: 367
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4796 (class 0 OID 16965)
-- Dependencies: 364
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4798 (class 0 OID 17028)
-- Dependencies: 366
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4795 (class 0 OID 16933)
-- Dependencies: 363
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4781 (class 0 OID 16507)
-- Dependencies: 346
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 68, 'rhm535qhibvj', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-18 21:39:25.981485+00', '2026-03-22 20:36:05.767434+00', 'hcjwacsipuvb', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 51, 'v6ytifw5uddr', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-16 20:10:03.576033+00', '2026-03-23 13:21:28.694539+00', NULL, '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 141, 'hsv5zwrcz5ey', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 18:25:59.320064+00', '2026-03-24 20:22:58.03365+00', 'qzijpozda2f5', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 149, '4rmyszce47eh', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 21:47:33.29227+00', '2026-03-24 22:59:59.965691+00', 'x7zd56ipzvfr', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 197, 'vnfgehlb7khd', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-26 20:46:51.666034+00', '2026-03-26 21:45:52.012195+00', 'gzqcyz2u7gwl', 'd9be39d9-ce61-4f53-bd1b-f7b109799574');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 155, '64jo3vmshmv6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 02:04:29.874848+00', '2026-03-25 09:50:50.825346+00', '3u46eebynf4t', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 203, 'jnqatfdd2lwc', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', false, '2026-03-26 22:35:05.908991+00', '2026-03-26 22:35:05.908991+00', '7om2da4bj4n7', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 158, 'rtdhik57vl5p', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 11:02:51.515303+00', '2026-03-25 12:46:11.945888+00', '3fytnzuevkuj', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 200, '76u7imulqjcq', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-26 21:49:50.922386+00', '2026-03-26 22:48:51.009209+00', 'qogqwum5kwc6', 'a3ea298a-129c-410d-ad67-51d05ccb937f');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 161, 'x7c2h2klm2cu', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 12:53:02.42026+00', '2026-03-25 14:02:32.071072+00', 'f3xpmslg5bky', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 206, '3tpblbqkhtfe', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-26 23:34:21.894589+00', '2026-03-27 00:38:30.37528+00', 'kr6qszb2cclb', 'c1a54303-71fd-40a1-9aad-7e563b195470');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 209, '36bu6ocuzd2o', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-27 00:38:30.404545+00', '2026-03-27 00:38:30.404545+00', '3tpblbqkhtfe', 'c1a54303-71fd-40a1-9aad-7e563b195470');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 164, 'eyyk6yechq3x', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 15:01:46.410516+00', '2026-03-25 16:00:17.050757+00', 'yi7w2f2qfvaz', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 146, '3rfl4kt4hz66', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 19:56:18.383674+00', '2026-03-25 18:06:31.500382+00', '2cpcyz55dt5f', '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 173, 'fkrvbenoj3ya', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 18:06:31.528762+00', '2026-03-25 19:08:25.915976+00', '3rfl4kt4hz66', '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 152, 'gsnqqcgm63yz', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 23:54:56.676068+00', '2026-03-25 22:13:31.257428+00', '2ogzr5ktxe2g', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 177, 'e3fsrhhai4ae', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 20:27:56.694384+00', '2026-03-25 23:09:06.76759+00', 'i63jrz7oqf7k', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 180, '34al6pjowqr5', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 23:09:06.781236+00', '2026-03-26 00:10:05.277358+00', 'e3fsrhhai4ae', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 183, 'ywxlygt4op5l', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 00:12:37.231985+00', '2026-03-26 15:44:58.141981+00', 'ss7zg7da6tct', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 187, 'k4m7fmwwqxx4', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 14:32:41.923635+00', '2026-03-26 16:09:15.036839+00', 'gx6xqsikay4a', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 190, '4he5jmk4x4hc', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', false, '2026-03-26 16:38:40.485356+00', '2026-03-26 16:38:40.485356+00', 'bvsnk6oiw3mh', '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 52, 'hcjwacsipuvb', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-16 23:49:17.638416+00', '2026-03-18 21:39:25.953941+00', NULL, '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 133, 'qzijpozda2f5', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 11:38:43.510063+00', '2026-03-24 18:25:59.303638+00', NULL, '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 143, '2cpcyz55dt5f', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 18:57:41.485593+00', '2026-03-24 19:56:18.369382+00', 'upskhx4c3o5a', '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 195, 'gzqcyz2u7gwl', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-26 19:47:55.432893+00', '2026-03-26 20:46:51.646154+00', NULL, 'd9be39d9-ce61-4f53-bd1b-f7b109799574');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 123, 'wnh3dwjxo7jm', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-23 22:10:30.785579+00', '2026-03-24 21:36:10.89945+00', 'ha4qwj422d5a', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 147, 'x7zd56ipzvfr', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 20:22:58.061303+00', '2026-03-24 21:47:33.2849+00', 'hsv5zwrcz5ey', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 150, '2ogzr5ktxe2g', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 22:34:48.94268+00', '2026-03-24 23:54:56.653808+00', 'fxkrrnqb7nwk', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 198, 'qogqwum5kwc6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-26 20:50:51.027494+00', '2026-03-26 21:49:50.919156+00', 'hqqntgpaanku', 'a3ea298a-129c-410d-ad67-51d05ccb937f');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 153, '3u46eebynf4t', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 00:43:46.351305+00', '2026-03-25 02:04:29.845902+00', '2q5ix2cin5m5', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 188, 'fsf6cj33qxlu', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 15:44:58.170602+00', '2026-03-26 22:16:59.835704+00', 'ywxlygt4op5l', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 156, 'nqrfwbr7vx4g', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 09:50:50.857166+00', '2026-03-25 10:51:11.283558+00', '64jo3vmshmv6', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 201, '2ip5vqmp3k5b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', false, '2026-03-26 22:16:59.852586+00', '2026-03-26 22:16:59.852586+00', 'fsf6cj33qxlu', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 159, 'f3xpmslg5bky', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 11:54:24.128416+00', '2026-03-25 12:53:02.405796+00', 'p4iew337nh27', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 162, 'yi7w2f2qfvaz', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 14:02:32.10064+00', '2026-03-25 15:01:46.404616+00', 'x7c2h2klm2cu', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 204, 'itpawhjocfzi', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-26 22:44:51.683517+00', '2026-03-26 23:43:46.162896+00', 'wrw47fdmcer3', 'd9be39d9-ce61-4f53-bd1b-f7b109799574');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 165, '7icsrmdtbvkk', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 15:45:05.268544+00', '2026-03-25 16:43:22.854792+00', 'wp6zlbetwgbm', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 207, 'wzphibtymuxe', '2374d4c0-d9a8-455f-925d-f42f42f3522d', false, '2026-03-26 23:43:46.169303+00', '2026-03-26 23:43:46.169303+00', 'itpawhjocfzi', 'd9be39d9-ce61-4f53-bd1b-f7b109799574');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 171, '4sgbpivqxvbh', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 16:43:22.881071+00', '2026-03-25 17:41:46.27287+00', '7icsrmdtbvkk', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 210, 'mdc3feouiyft', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-27 01:26:24.093279+00', '2026-03-27 02:42:20.910734+00', NULL, '81582d8b-8531-47ba-8f21-f41a6589a5c4');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 178, 'ss7zg7da6tct', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 22:13:31.302265+00', '2026-03-26 00:12:37.214436+00', 'gsnqqcgm63yz', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 174, 'g6q6cvbs2gqp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 19:08:25.941998+00', '2026-03-26 12:10:54.418086+00', 'fkrvbenoj3ya', '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 185, 'ym7zo5zcjkfb', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 12:11:21.623575+00', '2026-03-26 14:23:07.334427+00', 'gbeilypxdeg2', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 184, 'bvsnk6oiw3mh', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 12:10:54.451148+00', '2026-03-26 16:38:40.467158+00', 'g6q6cvbs2gqp', '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 110, 'cl664lqeq2vv', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-22 20:36:05.786828+00', '2026-03-22 23:23:41.703511+00', 'rhm535qhibvj', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 119, 'f6t4yomjy55m', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-23 13:21:28.711713+00', '2026-03-23 17:58:46.306153+00', 'v6ytifw5uddr', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 114, 'ha4qwj422d5a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-22 23:23:41.724098+00', '2026-03-23 22:10:30.759535+00', 'cl664lqeq2vv', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 121, 'a4abqdndtagi', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-23 17:58:46.322755+00', '2026-03-24 12:36:34.351644+00', 'f6t4yomjy55m', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 135, '4kq5pepbb3bn', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 12:36:34.365391+00', '2026-03-24 17:55:31.596801+00', 'a4abqdndtagi', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 140, 'upskhx4c3o5a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 17:59:32.200325+00', '2026-03-24 18:57:41.484573+00', NULL, '83283a1d-bfbd-49fc-9f0a-44997689343e');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 138, '4mze3dleppix', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 17:55:31.597453+00', '2026-03-24 19:07:14.369312+00', '4kq5pepbb3bn', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 196, 'hqqntgpaanku', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-26 19:51:50.83696+00', '2026-03-26 20:50:51.023164+00', NULL, 'a3ea298a-129c-410d-ad67-51d05ccb937f');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 148, 'fxkrrnqb7nwk', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 21:36:10.913354+00', '2026-03-24 22:34:48.915781+00', 'wnh3dwjxo7jm', '6a2600de-650c-4ef8-a318-fe600e3c1ed1');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 189, '7om2da4bj4n7', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 16:09:15.050273+00', '2026-03-26 22:35:05.899799+00', 'k4m7fmwwqxx4', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 151, '2q5ix2cin5m5', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 22:59:59.978479+00', '2026-03-25 00:43:46.325778+00', '4rmyszce47eh', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 199, 'wrw47fdmcer3', '2374d4c0-d9a8-455f-925d-f42f42f3522d', true, '2026-03-26 21:45:52.036226+00', '2026-03-26 22:44:51.663932+00', 'vnfgehlb7khd', 'd9be39d9-ce61-4f53-bd1b-f7b109799574');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 145, '3fytnzuevkuj', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-24 19:07:14.388624+00', '2026-03-25 11:02:51.505065+00', '4mze3dleppix', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 157, 'p4iew337nh27', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 10:51:11.305132+00', '2026-03-25 11:54:24.102189+00', 'nqrfwbr7vx4g', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 202, 'kr6qszb2cclb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-26 22:31:18.496645+00', '2026-03-26 23:34:21.870121+00', NULL, 'c1a54303-71fd-40a1-9aad-7e563b195470');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 160, 'dvemnsrp2w5q', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 12:46:11.972529+00', '2026-03-25 14:45:48.949465+00', 'rtdhik57vl5p', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 205, '7iavvmqendfv', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', true, '2026-03-26 22:48:51.015605+00', '2026-03-26 23:47:51.093502+00', '76u7imulqjcq', 'a3ea298a-129c-410d-ad67-51d05ccb937f');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 163, 'wp6zlbetwgbm', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 14:45:48.980453+00', '2026-03-25 15:45:05.241569+00', 'dvemnsrp2w5q', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 208, 'xh4n2rskm6bk', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-26 23:47:51.106383+00', '2026-03-26 23:47:51.106383+00', '7iavvmqendfv', 'a3ea298a-129c-410d-ad67-51d05ccb937f');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 211, 'vl76stnu6xcx', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', false, '2026-03-27 02:42:20.925572+00', '2026-03-27 02:42:20.925572+00', 'mdc3feouiyft', '81582d8b-8531-47ba-8f21-f41a6589a5c4');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 169, 'dynfa4uhth2a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 16:00:17.057435+00', '2026-03-25 19:21:54.541428+00', 'eyyk6yechq3x', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 172, 'ksqq3hmqcttb', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 17:41:46.296843+00', '2026-03-25 19:22:20.784856+00', '4sgbpivqxvbh', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 175, 'i63jrz7oqf7k', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 19:21:54.561242+00', '2026-03-25 20:27:56.659048+00', 'dynfa4uhth2a', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 176, 'gbeilypxdeg2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-25 19:22:20.786014+00', '2026-03-26 12:11:21.611695+00', 'ksqq3hmqcttb', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 186, '54iqlntt7moh', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', false, '2026-03-26 14:23:07.361666+00', '2026-03-26 14:23:07.361666+00', 'ym7zo5zcjkfb', '943a8995-1ad4-4c7f-8117-cf869d72dedc');
INSERT INTO auth.refresh_tokens VALUES ('00000000-0000-0000-0000-000000000000', 182, 'gx6xqsikay4a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', true, '2026-03-26 00:10:05.280844+00', '2026-03-26 14:32:41.89951+00', '34al6pjowqr5', '4a1e99ca-e400-4c54-8b0d-676fd7316b76');


--
-- TOC entry 4792 (class 0 OID 16812)
-- Dependencies: 360
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4793 (class 0 OID 16830)
-- Dependencies: 361
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4784 (class 0 OID 16533)
-- Dependencies: 349
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
-- TOC entry 4786 (class 0 OID 16711)
-- Dependencies: 354
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.sessions VALUES ('a3ea298a-129c-410d-ad67-51d05ccb937f', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-26 19:51:50.82993+00', '2026-03-26 23:47:51.134571+00', NULL, 'aal1', NULL, '2026-03-26 23:47:51.134457', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('c1a54303-71fd-40a1-9aad-7e563b195470', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-26 22:31:18.461014+00', '2026-03-27 00:38:30.437185+00', NULL, 'aal1', NULL, '2026-03-27 00:38:30.437068', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36', '187.43.217.233', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('81582d8b-8531-47ba-8f21-f41a6589a5c4', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-27 01:26:24.066828+00', '2026-03-27 02:42:20.946958+00', NULL, 'aal1', NULL, '2026-03-27 02:42:20.946852', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '189.79.241.163', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('943a8995-1ad4-4c7f-8117-cf869d72dedc', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:10:03.564061+00', '2026-03-26 14:23:07.39863+00', NULL, 'aal1', NULL, '2026-03-26 14:23:07.398521', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('83283a1d-bfbd-49fc-9f0a-44997689343e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 17:59:32.198577+00', '2026-03-26 16:38:40.517394+00', NULL, 'aal1', NULL, '2026-03-26 16:38:40.517287', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('6a2600de-650c-4ef8-a318-fe600e3c1ed1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:49:17.589348+00', '2026-03-26 22:16:59.874574+00', NULL, 'aal1', NULL, '2026-03-26 22:16:59.874463', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0.0.0 Safari/537.36', '187.181.208.92', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('4a1e99ca-e400-4c54-8b0d-676fd7316b76', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 11:38:43.478133+00', '2026-03-26 22:35:05.93377+00', NULL, 'aal1', NULL, '2026-03-26 22:35:05.933654', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Mobile Safari/537.36', '187.181.208.92', NULL, NULL, NULL, NULL, NULL);
INSERT INTO auth.sessions VALUES ('d9be39d9-ce61-4f53-bd1b-f7b109799574', '2374d4c0-d9a8-455f-925d-f42f42f3522d', '2026-03-26 19:47:55.421943+00', '2026-03-26 23:43:46.188153+00', NULL, 'aal1', NULL, '2026-03-26 23:43:46.188047', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', '186.225.138.87', NULL, NULL, NULL, NULL, NULL);


--
-- TOC entry 4791 (class 0 OID 16797)
-- Dependencies: 359
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4790 (class 0 OID 16788)
-- Dependencies: 358
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4779 (class 0 OID 16495)
-- Dependencies: 344
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'authenticated', 'authenticated', 'amandacsagres@gmail.com', '$2a$10$GLlS9ei/99QSbTqAQloh6uEQMTIGAC/OlOxanAZ1joR71jDqVjG.W', '2026-03-16 20:12:26.749522+00', NULL, '', '2026-03-16 20:09:55.959872+00', '', NULL, '', '', NULL, '2026-03-24 17:59:32.198473+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "ae8dfd8c-5182-41d7-9a4a-c02ebba36890", "email": "amandacsagres@gmail.com", "full_name": "Amanda Cristine Sagres", "email_verified": true, "phone_verified": false}', NULL, '2026-03-16 20:09:55.917662+00', '2026-03-26 22:35:05.918004+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', '2374d4c0-d9a8-455f-925d-f42f42f3522d', 'authenticated', 'authenticated', 'gmgarcia@educacao.riopreto.sp.gov.br', '$2a$10$utMzV3mF5nCJwUmbLzz4j.FtKhzsK006mmYSKhZ3rL1RucQYeR1hW', '2026-03-15 18:39:06.954771+00', NULL, '', '2026-03-15 18:38:52.02234+00', '', NULL, '', '', NULL, '2026-03-26 19:47:55.420928+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "2374d4c0-d9a8-455f-925d-f42f42f3522d", "email": "gmgarcia@educacao.riopreto.sp.gov.br", "full_name": "Giuliano Moretti", "email_verified": true, "phone_verified": false}', NULL, '2026-03-15 18:38:51.985624+00', '2026-03-26 23:43:46.173463+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);
INSERT INTO auth.users VALUES ('00000000-0000-0000-0000-000000000000', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'authenticated', 'authenticated', 'giulianomsg@gmail.com', '$2a$10$7eDvyxe8qiBx6Ejse0mkfe0jNbUV0IzQfs0Re07k5WEBUkiVN7kA.', '2026-03-11 03:25:19.886791+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-03-27 01:26:24.066731+00', '{"provider": "email", "providers": ["email"]}', '{"email_verified": true}', NULL, '2026-03-11 03:11:05.174437+00', '2026-03-27 02:42:20.930083+00', NULL, NULL, '', '', NULL, DEFAULT, '', 0, NULL, '', NULL, false, NULL, false);


--
-- TOC entry 4838 (class 0 OID 27144)
-- Dependencies: 411
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4837 (class 0 OID 27121)
-- Dependencies: 410
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- TOC entry 4843 (class 0 OID 28470)
-- Dependencies: 416
-- Data for Name: admin_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.admin_settings VALUES ('active_scraper', '{"apiKey": "b2ea92fb367d8f8ff8a57acf3dc51130", "provider": "scraperapi"}', '2026-03-22 22:01:59.825958+00');
INSERT INTO public.admin_settings VALUES ('scraper_config', '{"keys": {"scrape.do": "f6a7507806a742ee93e693a00bc6fb1b08c4f89290d", "scraperapi": "b2ea92fb367d8f8ff8a57acf3dc51130", "scrapingant": "6ae92fa5f3f54712985005107df99de6", "scrapingbee": "VWYXU3Y0GC4ITXPIGHK3BNIF66W14S1C6NDMSF85FE7TEOSD0WPFGQ6S6OOX0LVR7JPI6DP774VWJMVH"}, "activeProvider": "scrape.do"}', '2026-03-22 22:10:00.15746+00');


--
-- TOC entry 4849 (class 0 OID 29710)
-- Dependencies: 422
-- Data for Name: amazon_product_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.amazon_product_mappings VALUES ('448c8546-38cd-49b9-ad30-e24f1dc8cfc8', '3b7de2f5-749e-4f0a-b085-22dcd1c4f631', 'B075XM6DKH', 59.30, 71.90, 'active', 4.70, 0, '2026-03-25 22:30:43.086574+00', '2026-03-25 22:30:43.086574+00', '2026-03-25 22:30:43.086574+00');
INSERT INTO public.amazon_product_mappings VALUES ('28e5e575-3f7f-438b-b786-053d2b555e64', 'df68154b-cc8e-4371-ad08-84b16061c6ed', 'B0GK2ZFK5D', 179.99, 239.99, 'active', 3.70, 0, '2026-03-25 22:33:25.928453+00', '2026-03-25 22:33:25.928453+00', '2026-03-25 22:33:25.928453+00');
INSERT INTO public.amazon_product_mappings VALUES ('1bebeaeb-8d76-4033-98c3-c7f0b5317650', '48810ae3-ce2a-4f66-b962-116d4a94a95e', 'B0FGZ6FCGY', 418.16, 569.00, 'active', 4.60, 0, '2026-03-26 00:17:44.846965+00', '2026-03-26 00:17:44.846965+00', '2026-03-26 00:17:44.846965+00');
INSERT INTO public.amazon_product_mappings VALUES ('2070b8ce-3e60-41f4-bb34-78f3e94d0f5f', '29ef0946-b25e-4f3d-9d90-8df9924e0a61', 'B0CN3WK5DZ', 68.70, 104.99, 'active', 4.40, 0, '2026-03-26 00:23:55.276849+00', '2026-03-26 00:23:55.276849+00', '2026-03-26 00:23:55.276849+00');
INSERT INTO public.amazon_product_mappings VALUES ('8cdc1929-a924-47a9-9354-e38123045aef', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', 'B0CDNJ3S3D', 69.90, NULL, 'active', 4.80, 0, '2026-03-26 12:12:27.606+00', '2026-03-24 05:23:00.999545+00', '2026-03-24 05:23:00.999545+00');
INSERT INTO public.amazon_product_mappings VALUES ('fa5e0413-83c4-461e-b36e-881bdb191cfb', '41d2c588-4b18-42c9-affb-1aaab6a3cf92', 'B0CFM67MPS', 198.91, 333.85, 'active', 4.70, 0, '2026-03-26 12:12:28.391+00', '2026-03-25 11:11:04.228157+00', '2026-03-25 11:11:04.228157+00');
INSERT INTO public.amazon_product_mappings VALUES ('75d68401-c266-470f-a1f3-b2b620e99ec2', 'f6b55013-88ec-4968-b251-94ba1535261e', 'B07LCRQL1W', 234.50, NULL, 'active', 4.80, 0, '2026-03-26 12:12:36.463+00', '2026-03-24 05:14:39.208667+00', '2026-03-24 05:14:39.208667+00');
INSERT INTO public.amazon_product_mappings VALUES ('d202712a-e3ff-4e1f-b20c-710c659969bf', 'd2eb75e2-53bf-45dc-877b-e4c96132b43d', 'B0FHWBZM8F', 69.80, NULL, 'active', 1.00, 0, '2026-03-26 12:12:40.392+00', '2026-03-25 17:34:25.535259+00', '2026-03-25 17:34:25.535259+00');
INSERT INTO public.amazon_product_mappings VALUES ('743ba7e5-53af-4be6-a54a-1728a79ffe71', 'ad502528-58d6-4f78-9971-e5286a526546', 'B09F75J3BK', 98.90, NULL, 'active', 4.30, 0, '2026-03-26 12:12:42.27+00', '2026-03-25 22:20:00.911694+00', '2026-03-25 22:20:00.911694+00');
INSERT INTO public.amazon_product_mappings VALUES ('4e013908-2eb4-4045-bf2b-edc6c3bc3624', '20a59a16-2821-49e6-b140-d06d8664af0a', 'B08PDFJVBQ', 47.99, NULL, 'active', 4.70, 0, '2026-03-26 12:12:49.72+00', '2026-03-25 16:56:49.849588+00', '2026-03-25 16:56:49.849588+00');
INSERT INTO public.amazon_product_mappings VALUES ('6e00b167-2702-4db0-9239-10459526badb', 'ae6ab7a4-165c-4c39-a209-f5f4cc516cf6', 'B0FS31FTP5', 37.90, NULL, 'active', 4.30, 0, '2026-03-26 12:12:51.868+00', '2026-03-25 22:25:32.615048+00', '2026-03-25 22:25:32.615048+00');
INSERT INTO public.amazon_product_mappings VALUES ('d3359fe9-0eef-4727-b31f-f38f67ac08e4', '2afe5d48-cdf8-4641-b2cf-d193ae4e93c7', 'B0CYTTVHDF', 33.97, 37.70, 'active', 4.50, 0, '2026-03-26 12:12:54.121+00', '2026-03-25 22:27:59.022622+00', '2026-03-25 22:27:59.022622+00');
INSERT INTO public.amazon_product_mappings VALUES ('b72840f3-33f7-468c-bdb0-d17b178bf61a', '1177c463-9ddd-4d01-ba58-070d95037d8b', 'B09XJL4B9H', 97.90, 129.90, 'active', 4.90, 0, '2026-03-26 12:12:56.856+00', '2026-03-25 22:23:09.208166+00', '2026-03-25 22:23:09.208166+00');
INSERT INTO public.amazon_product_mappings VALUES ('2669ee37-c09a-49e6-93a9-1a145bc4796d', '3dbbbda2-0da3-4eb5-8452-928abf2a902d', 'B0CZY1N1JY', 99.90, NULL, 'active', 4.80, 0, '2026-03-26 14:23:38.218395+00', '2026-03-26 14:23:38.218395+00', '2026-03-26 14:23:38.218395+00');
INSERT INTO public.amazon_product_mappings VALUES ('64c758a7-9cac-41d6-9f98-fdec7028b908', '2b2649bf-137c-4614-b2ed-9e7879872492', 'B0C3V5X3QT', 199.00, NULL, 'active', 4.80, 0, '2026-03-26 15:48:53.995057+00', '2026-03-26 15:48:53.995057+00', '2026-03-26 15:48:53.995057+00');
INSERT INTO public.amazon_product_mappings VALUES ('3a29dcd3-0a83-4cf6-a466-8b4af0489f57', '8e10d48e-849f-46c2-9457-fb7369e28706', 'B09B8XVSDP', 398.99, 459.00, 'active', 4.80, 0, '2026-03-26 15:51:33.390689+00', '2026-03-26 15:51:33.390689+00', '2026-03-26 15:51:33.390689+00');
INSERT INTO public.amazon_product_mappings VALUES ('ac9d8882-1344-492d-94f4-668663ab10c3', 'a9f0ec91-fb56-44f0-a187-1d8f83ef165a', 'B076N2S8FV', 93.10, 133.51, 'active', 4.70, 0, '2026-03-26 22:18:11.74512+00', '2026-03-26 22:18:11.74512+00', '2026-03-26 22:18:11.74512+00');
INSERT INTO public.amazon_product_mappings VALUES ('c877edf8-3c75-4f6b-acf1-39a786969c1c', '854666ec-2a9c-469a-abf2-90da03304e86', 'B0CVCLGV1W', 299.00, 599.00, 'active', 4.70, 0, '2026-03-26 22:22:22.57477+00', '2026-03-26 22:22:22.57477+00', '2026-03-26 22:22:22.57477+00');
INSERT INTO public.amazon_product_mappings VALUES ('3aff7612-0950-47f7-8d15-fe13d7655f2c', '177c4305-2669-48c3-b11f-37943399a858', 'B0G23Q2WK3', 57.62, 67.35, 'active', 4.70, 0, '2026-03-26 22:49:20.610935+00', '2026-03-26 22:49:20.610935+00', '2026-03-26 22:49:20.610935+00');
INSERT INTO public.amazon_product_mappings VALUES ('d84bff97-7984-4cc7-ab22-742ae450f490', '5353db0e-e430-4c53-879e-3c187d777f13', 'B076F9GTBC', 234.50, 299.00, 'active', 4.80, 0, '2026-03-26 23:00:10.947069+00', '2026-03-26 23:00:10.947069+00', '2026-03-26 23:00:10.947069+00');
INSERT INTO public.amazon_product_mappings VALUES ('4c3be717-321d-40f1-aec2-47dc5cc767c9', '506bd334-8dc9-458b-96c1-f99e9c6db36d', 'B09GKSWN8T', 57.90, 119.00, 'active', 4.10, 0, '2026-03-26 23:08:07.683518+00', '2026-03-26 23:08:07.683518+00', '2026-03-26 23:08:07.683518+00');


--
-- TOC entry 4815 (class 0 OID 17545)
-- Dependencies: 387
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.banners VALUES ('f31321c2-ee84-4415-96e5-6fc6cf798dab', NULL, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1773618191923-uuta2v4negc.png', NULL, NULL, true, 0, '2026-03-15 23:12:19.630775+00', '2026-03-15 23:43:53.043374+00');
INSERT INTO public.banners VALUES ('2b9ab906-f77a-4820-a40d-664bd445c56e', 'Parceiro', NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1774326570234-0ls9cs8l522g.webp', NULL, NULL, true, 1, '2026-03-24 04:30:23.665711+00', '2026-03-24 04:31:13.914159+00');
INSERT INTO public.banners VALUES ('cce0376b-f67a-4186-87ac-f2718e4a9974', 'Parceiro', NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1774326549802-aafysfcamnc.png', NULL, NULL, true, 2, '2026-03-24 04:30:02.174803+00', '2026-03-24 04:31:22.315451+00');
INSERT INTO public.banners VALUES ('5c824783-9613-40e9-aca1-7c4711bba451', 'Parceiro', NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1774326517123-kvf9a70k6dl.jpg', NULL, NULL, true, 3, '2026-03-24 04:28:30.443754+00', '2026-03-24 04:31:30.695239+00');
INSERT INTO public.banners VALUES ('0ff057aa-7f47-494d-b2e5-960278a8a4b2', 'Parceiro', NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1774326600268-mo9yzm1bzf8.webp', NULL, NULL, true, 4, '2026-03-24 04:30:49.138492+00', '2026-03-24 04:31:44.674386+00');
INSERT INTO public.banners VALUES ('09c0e1ec-56a5-42c4-9343-104f2620128a', NULL, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/banners/1773615722587-3l91xmo00el.jpg', NULL, NULL, true, 5, '2026-03-11 03:27:31.917478+00', '2026-03-24 04:32:03.70345+00');


--
-- TOC entry 4818 (class 0 OID 22129)
-- Dependencies: 391
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
INSERT INTO public.brands VALUES ('e0c0b6f0-fa5b-4231-b28c-af9e83dd92e8', ' Swap Home', '2026-03-21 18:59:04.303971+00');
INSERT INTO public.brands VALUES ('1a071b94-6208-4fc3-bfa5-2fc6be200de4', 'Tramontina', '2026-03-23 18:03:23.85776+00');
INSERT INTO public.brands VALUES ('abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', 'Natura', '2026-03-23 18:43:12.46157+00');
INSERT INTO public.brands VALUES ('c8ac1472-f7ac-46fe-9728-e0a2924d58f6', 'Xiaomi', '2026-03-23 22:45:51.256493+00');
INSERT INTO public.brands VALUES ('9336d222-8a26-427b-9e2d-d9e75457a042', 'Philips', '2026-03-24 01:45:46.928332+00');
INSERT INTO public.brands VALUES ('8ec9c60b-d172-44d3-a855-4fbdbf09146d', 'Garoto ', '2026-03-24 12:19:26.967704+00');
INSERT INTO public.brands VALUES ('49e78eb6-89b8-481b-915f-0d9fd7c43b81', 'Philco', '2026-03-25 11:12:03.560395+00');
INSERT INTO public.brands VALUES ('dcb39609-04ac-4acc-b4d3-a0f02c6917b8', 'Barbour´s Beauty', '2026-03-25 16:36:52.788014+00');
INSERT INTO public.brands VALUES ('232eb3f8-6e67-45c6-8a48-d56e83a85391', 'Cimed', '2026-03-25 16:58:16.334872+00');
INSERT INTO public.brands VALUES ('f2f2e3af-9143-4a2c-9194-f6282a1cfcd6', 'Genérica', '2026-03-25 17:01:42.879093+00');
INSERT INTO public.brands VALUES ('ac573dc8-afa4-4add-934e-b94ffc431780', 'Eletrolux', '2026-03-25 22:24:08.141135+00');
INSERT INTO public.brands VALUES ('e76da4cd-1bdc-490d-a450-5e21fd8979d2', 'Mor ', '2026-03-25 22:31:53.982723+00');
INSERT INTO public.brands VALUES ('ff2c9e35-9f68-4884-aab7-e2c9bd98a90f', 'Midea', '2026-03-26 00:19:00.712556+00');
INSERT INTO public.brands VALUES ('60189ea2-57db-4e2e-8629-a69c5176f72d', 'karsten', '2026-03-26 14:34:59.826195+00');
INSERT INTO public.brands VALUES ('ef395dcf-cccc-4966-938e-0aa7d16f6d0f', 'Alexa', '2026-03-26 15:53:15.99426+00');
INSERT INTO public.brands VALUES ('b7a0ca55-80f9-4068-a9d1-61a95e26e99b', 'Kemei', '2026-03-26 22:36:51.133195+00');
INSERT INTO public.brands VALUES ('562df9b8-8a3a-419d-bce3-152b980c7927', 'Poco', '2026-03-26 22:43:27.393567+00');
INSERT INTO public.brands VALUES ('77f33f36-2389-4d43-856e-cead4472697c', 'Oster', '2026-03-26 23:01:04.451608+00');
INSERT INTO public.brands VALUES ('382b00de-6d79-4e7b-9e18-673c1333a299', 'Athletica', '2026-03-26 23:27:30.693404+00');


--
-- TOC entry 4821 (class 0 OID 22173)
-- Dependencies: 394
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
INSERT INTO public.categories VALUES ('690738e5-d372-4f58-876f-ae093f3e1e43', 'Ternos', 'ternos', NULL, '2026-03-22 23:28:26.470128+00');
INSERT INTO public.categories VALUES ('4a8db87c-0ea4-45b7-8a36-1bad3a8eb410', 'Lavadoras de Jato Elétricas', 'lavadoras-de-jato-el-tricas', NULL, '2026-03-23 13:24:05.334576+00');
INSERT INTO public.categories VALUES ('84acab8d-e648-427d-8151-7643fbf3b860', 'Televisores', 'televisores', NULL, '2026-03-24 01:44:48.649119+00');
INSERT INTO public.categories VALUES ('1e7341b0-4f4f-4d53-bb6e-0bfd49f8ac1c', 'Colágeno', 'col-geno', NULL, '2026-03-24 05:14:38.293315+00');
INSERT INTO public.categories VALUES ('fd868bd5-d65d-4c62-8d3f-68597eef93e6', 'Vitaminas, Minerais e Suplementos', 'vitaminas-minerais-e-suplementos', NULL, '2026-03-24 05:22:59.845076+00');
INSERT INTO public.categories VALUES ('a0822333-17b8-40d1-acbb-c0401eb81fcf', 'Especial de Páscoa', 'especial-de-pascoa', NULL, '2026-03-24 12:19:01.369749+00');
INSERT INTO public.categories VALUES ('52799cb7-f5c8-499e-973d-d75cdb233752', 'Kit Chocolate Lindt', 'kit-chocolate-lindt', NULL, '2026-03-24 12:45:34.707525+00');
INSERT INTO public.categories VALUES ('dbfa7aaf-01cf-4399-a4c9-c3b3532e752b', 'Infantil', 'infantil', NULL, '2026-03-24 12:51:14.127865+00');
INSERT INTO public.categories VALUES ('742eba43-6a66-4fda-9a5d-5fd1eaf601fe', 'Adesivos Decorativos', 'adesivos-decorativos', NULL, '2026-03-24 18:34:50.1986+00');
INSERT INTO public.categories VALUES ('7f05683f-2ebc-4dd0-ab42-acb474bf1c5b', 'Meias', 'meias', NULL, '2026-03-25 11:05:22.751562+00');
INSERT INTO public.categories VALUES ('5acbc677-2669-463a-9f5d-164d6e3f47b3', 'Mixers', 'mixers', NULL, '2026-03-25 11:11:02.792569+00');
INSERT INTO public.categories VALUES ('de3f5599-5a99-45f2-b1b0-1e0aee84ff1a', 'Camiseta', 'camiseta', NULL, '2026-03-25 14:46:36.604236+00');
INSERT INTO public.categories VALUES ('bbeb5177-d74e-415d-b506-7761a97a0148', 'Balanças', 'balan-as', NULL, '2026-03-25 14:47:08.347028+00');
INSERT INTO public.categories VALUES ('786de21b-3b9a-4244-882c-a6853b336f03', 'Secadores de Cabelo', 'secadores-de-cabelo', NULL, '2026-03-25 14:48:55.056082+00');
INSERT INTO public.categories VALUES ('5168d6b0-95e4-40ad-becb-a8ea8f65a3bc', 'Elétricas', 'el-tricas', NULL, '2026-03-25 15:57:44.72139+00');
INSERT INTO public.categories VALUES ('10a537b3-3365-40e2-8f0d-4ffdf1d00973', 'Perfumes', 'perfumes', NULL, '2026-03-25 16:34:56.601857+00');
INSERT INTO public.categories VALUES ('79d999f5-49a3-41b3-bde3-85b904be8830', 'Conjuntos e Kits', 'conjuntos-e-kits', NULL, '2026-03-25 16:56:48.495578+00');
INSERT INTO public.categories VALUES ('dc47e24e-7379-4a17-8f6e-acbad91e9a6e', 'Cuecas Sungas', 'cuecas-sungas', NULL, '2026-03-25 22:19:58.957737+00');
INSERT INTO public.categories VALUES ('cca518e4-8d02-4446-a82f-bf796aa5c0ab', 'Jogos de Armazenamento e Organização de Cozinha', 'jogos-de-armazenamento-e-organiza-o-de-cozinha', NULL, '2026-03-25 22:23:07.806297+00');
INSERT INTO public.categories VALUES ('74f5efd2-4ff5-4dfd-975e-6dc63d60ef6b', 'Conjuntos de Copos e Taças', 'conjuntos-de-copos-e-ta-as', NULL, '2026-03-25 22:25:31.307992+00');
INSERT INTO public.categories VALUES ('1c6224ae-4375-47e1-946e-a39a4b50dc93', 'Lancheiras e Bolsas', 'lancheiras-e-bolsas', NULL, '2026-03-25 22:27:57.762102+00');
INSERT INTO public.categories VALUES ('c4cc1d6b-71ee-485e-b746-49c6a49c9762', 'Cadeiras', 'cadeiras', NULL, '2026-03-25 22:30:41.833625+00');
INSERT INTO public.categories VALUES ('d9de6559-365f-46e0-b9a7-aa6b7c02544f', 'Colchões', 'colch-es', NULL, '2026-03-25 22:33:24.458861+00');
INSERT INTO public.categories VALUES ('1e2a9f30-095f-439f-958b-8af8eaa1ad2f', 'Fornos de Micro-Ondas', 'fornos-de-micro-ondas', NULL, '2026-03-26 00:17:43.535583+00');
INSERT INTO public.categories VALUES ('f24ed06f-2811-4e24-8c7d-d26d3c4da2d3', 'Varais', 'varais', NULL, '2026-03-26 00:23:53.4808+00');
INSERT INTO public.categories VALUES ('8b573b54-b283-4f4b-ada1-253efa523053', 'Geladeiras Térmicas', 'geladeiras-t-rmicas', NULL, '2026-03-26 12:36:03.928784+00');
INSERT INTO public.categories VALUES ('1d9592ec-9f39-45a2-ac79-a61219f6ba67', 'Faca Tatica', 'faca-tatica', NULL, '2026-03-26 12:38:35.894589+00');
INSERT INTO public.categories VALUES ('46a1cbc4-f219-42d4-b37b-d4b77d3167cc', 'Kits com Shampoo e Condicionador', 'kits-com-shampoo-e-condicionador', NULL, '2026-03-26 14:23:36.516803+00');
INSERT INTO public.categories VALUES ('70557dfc-a88f-43f4-bfd0-58cfacb148e1', 'Toalhas de Banho', 'toalhas-de-banho', NULL, '2026-03-26 14:33:26.369649+00');
INSERT INTO public.categories VALUES ('36f1586a-dc89-4e01-814e-cdec410b3831', 'Fones de Ouvido Abertos', 'fones-de-ouvido-abertos', NULL, '2026-03-26 15:46:07.418772+00');
INSERT INTO public.categories VALUES ('b423df57-3f00-4209-8488-8b9747e205be', 'Fones de Ouvido', 'fones-de-ouvido', NULL, '2026-03-26 15:48:52.656062+00');
INSERT INTO public.categories VALUES ('21446767-ed48-47e3-82cf-2d5ec5630e76', 'Diversos', 'diversos', NULL, '2026-03-26 15:51:31.780589+00');
INSERT INTO public.categories VALUES ('a850da0e-9597-4921-9def-23ee83359bff', 'Kits de Ferramentas', 'kits-de-ferramentas', NULL, '2026-03-26 22:18:09.947258+00');
INSERT INTO public.categories VALUES ('4b889f34-2be4-4625-ba50-2f84028d3673', 'Smartwatches', 'smartwatches', NULL, '2026-03-26 22:22:21.783733+00');
INSERT INTO public.categories VALUES ('6236c797-1eb1-4ea6-98c7-11d6fa5e0dbd', 'Espelhos', 'espelhos', NULL, '2026-03-26 22:38:42.190373+00');
INSERT INTO public.categories VALUES ('d1baff6d-2ffd-4dba-be65-17296065b247', 'Brinquedos para Bebês', 'brinquedos-para-beb-s', NULL, '2026-03-26 22:49:19.290876+00');
INSERT INTO public.categories VALUES ('db1c4b76-eba9-4903-ad3c-104d8759e776', 'Cafeteiras de Filtro', 'cafeteiras-de-filtro', NULL, '2026-03-26 23:00:09.679763+00');
INSERT INTO public.categories VALUES ('30fb7ff4-862a-41cc-a6cd-210bf51c5427', 'Chaleiras Elétricas', 'chaleiras-el-tricas', NULL, '2026-03-26 23:08:06.60236+00');
INSERT INTO public.categories VALUES ('4c8d6d57-50cd-436e-becf-e1a9b7bf92e4', 'Beta Alanina', 'beta-alanina', NULL, '2026-03-26 23:26:53.399756+00');


--
-- TOC entry 4834 (class 0 OID 22458)
-- Dependencies: 407
-- Data for Name: coupon_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4833 (class 0 OID 22441)
-- Dependencies: 406
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4832 (class 0 OID 22426)
-- Dependencies: 405
-- Data for Name: institutional_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.institutional_pages VALUES ('67a57306-1b29-4d75-9c2c-2baeb5daaf40', 'Cupons', 'shopee', '<p><br></p>', true, '2026-03-16 00:46:37.853836+00', 'support');


--
-- TOC entry 4840 (class 0 OID 27177)
-- Dependencies: 413
-- Data for Name: ml_product_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ml_product_mappings VALUES ('1f0ef4db-12ea-4e02-84ce-ec387287f465', 'c2cd6c40-7828-4dcc-b08d-39f06e01f91c', 'MLB5199984244', 'https://produto.mercadolivre.com.br/MLB-5199984244-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta-_JM?searchVariation=186224801527', NULL, NULL, 'new', 100, NULL, NULL, 0, 'active', NULL, 183.9, 'https://http2.mlstatic.com/D_NQ_NP_2X_977736-MLB84818860104_052025-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp', 'active', '2026-03-26 12:13:00.862+00', '2026-03-23 00:41:01.99632+00');
INSERT INTO public.ml_product_mappings VALUES ('113f28ba-216b-4516-a937-1f6f0a4f665d', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 'MLB4016066645', 'https://produto.mercadolivre.com.br/MLB-4016066645-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano-_JM?searchVariation=196334674921', NULL, NULL, 'new', 500, NULL, NULL, 0, 'active', 129, 99.24, 'https://http2.mlstatic.com/D_NQ_NP_2X_661842-MLB94691381784_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp', 'active', '2026-03-26 12:13:00.084+00', '2026-03-23 00:36:54.533967+00');
INSERT INTO public.ml_product_mappings VALUES ('4cde1ef3-03d1-495d-bb2c-18600e01678e', '37e74a05-5862-47b3-b01d-ebb0f81c4d9a', 'MLB53989572', 'https://www.mercadolivre.com.br/jogo-de-toalhas-4-pcs-fio-cardado-100-algodo-bosco-karsten-cinza-bosco/p/MLB53989572', NULL, NULL, 'new', 1000, NULL, NULL, 0, 'active', 149, 116, 'https://http2.mlstatic.com/D_NQ_NP_2X_814876-MLA95676723136_102025-F.webp', 'active', '2026-03-26 14:33:26.912398+00', '2026-03-26 14:33:26.912398+00');
INSERT INTO public.ml_product_mappings VALUES ('8a24bcd8-d976-4c8e-a077-b2fcc4783018', '4f9c76f9-9bb1-43ee-90ce-04cf0754f4ec', 'MLB55898438', 'https://www.mercadolivre.com.br/balanca-digital-bioimpedncia-bluetooth-inteligente-corporal-alta-preciso-com-app-gratis-android-e-ios-preta-marca-hardline/p/MLB55898438?pdp_filters=deal%3AMLB779362-1', NULL, NULL, 'new', 10000, NULL, NULL, 0, 'not_found', 36, 32, 'https://http2.mlstatic.com/D_NQ_NP_2X_633197-MLA92889689146_092025-F.webp', 'active', '2026-03-26 12:13:04.52+00', '2026-03-25 14:47:08.879344+00');
INSERT INTO public.ml_product_mappings VALUES ('def59ce2-d9f4-4f06-9e53-66586d12dd78', 'a2c9ad39-f849-490c-ae4f-7860daa642c6', 'MLB64896444', 'https://www.mercadolivre.com.br/fechadura-digital-inteligente-airtag-polegar-idali-life-preto/p/MLB64896444', NULL, NULL, 'new', 100, NULL, NULL, 0, 'active', NULL, 269.98, 'https://http2.mlstatic.com/D_NQ_NP_2X_858896-MLA105692577097_012026-F.webp', 'active', '2026-03-26 12:12:53.465+00', '2026-03-25 15:57:45.294674+00');
INSERT INTO public.ml_product_mappings VALUES ('7b0b7626-023d-4d34-8557-3c3c58ca1d0e', 'cdeffb1e-5dab-413a-a8cf-31381f3ba852', 'MLB5830888824', 'https://produto.mercadolivre.com.br/MLB-5830888824-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala-_JM?searchVariation=192084415009', NULL, NULL, 'new', 1000, NULL, NULL, 0, 'active', 98, 78, 'https://http2.mlstatic.com/D_NQ_NP_2X_600271-MLB95836200945_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp', 'active', '2026-03-26 22:38:42.757575+00', '2026-03-26 22:38:42.757575+00');
INSERT INTO public.ml_product_mappings VALUES ('57b4c37b-276d-40e0-8a9d-b155bbd3ad3d', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', 'MLB2718664560', 'https://produto.mercadolivre.com.br/MLB-2718664560-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte-_JM?searchVariation=175590404283', NULL, NULL, 'new', 50000, NULL, NULL, 0, 'active', 78, 78.98, 'https://http2.mlstatic.com/D_NQ_NP_2X_832327-MLB52270809423_112022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp', 'active', '2026-03-26 12:13:03.99+00', '2026-03-25 14:46:37.121861+00');
INSERT INTO public.ml_product_mappings VALUES ('b8864386-7816-41a2-a48a-a1fd2bb37d8f', '0a03bc3e-74f1-415c-8a15-7da6336985e0', 'MLB5825242132', 'https://produto.mercadolivre.com.br/MLB-5825242132-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11-_JM?searchVariation=192021508253', NULL, NULL, 'new', 10000, NULL, NULL, 0, 'active', 69, 40, 'https://http2.mlstatic.com/D_NQ_NP_2X_791289-MLB96316102981_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp', 'active', '2026-03-26 12:12:54.583+00', '2026-03-24 18:34:50.781933+00');
INSERT INTO public.ml_product_mappings VALUES ('ef0a2c9e-ba1e-4914-af7a-05a5f7d7f9c5', 'cb3b34a4-7715-4237-ad79-989dd3b08561', 'MLB19538713', 'https://www.mercadolivre.com.br/beta-alanina-100-pura-atlhetica-nutrition-200g/p/MLB19538713', NULL, NULL, 'new', 10000, NULL, NULL, 0, 'active', 59, 43, 'https://http2.mlstatic.com/D_NQ_NP_2X_900699-MLA99607922852_122025-F.webp', 'active', '2026-03-26 23:26:54.002053+00', '2026-03-26 23:26:54.002053+00');
INSERT INTO public.ml_product_mappings VALUES ('f7aaafe1-0a8e-49e0-baa4-c8dbacbdc063', 'b889d94a-45fd-4443-9e42-f16afd61cc16', 'MLB63713706', 'https://www.mercadolivre.com.br/barbours-beauty-very-sexy-body-splash-perfume-capilar/p/MLB63713706', NULL, NULL, 'new', 100, NULL, NULL, 0, 'active', 139, 97.41, 'https://http2.mlstatic.com/D_NQ_NP_2X_836941-MLA103260970909_122025-F.webp', 'active', '2026-03-26 12:12:53.859+00', '2026-03-25 16:34:57.144356+00');
INSERT INTO public.ml_product_mappings VALUES ('6a5e75f7-2baf-4b14-a2ff-b55ee67a14ae', '0252b325-31e9-4f69-9952-8d821019dd14', 'MLB18638651', 'https://www.mercadolivre.com.br/secador-de-cabelos-mondial-2000w-scn-01/p/MLB18638651', NULL, NULL, 'new', 50000, NULL, NULL, 0, 'active', 172, 119, 'https://http2.mlstatic.com/D_NQ_NP_2X_931087-MLA100025900529_122025-F.webp', 'active', '2026-03-26 12:12:55.292+00', '2026-03-25 14:48:55.543806+00');
INSERT INTO public.ml_product_mappings VALUES ('da7fca56-6e43-44e7-bdb5-4b3dc06618d6', '3d3a7ef6-3197-44c8-8035-1627dbe6c690', 'MLB23965159', 'https://www.mercadolivre.com.br/2-caixas-de-37g-bombons-de-chocolate-suico-lindt-lindor/p/MLB23965159', NULL, NULL, 'new', 100, NULL, NULL, 0, 'active', 64, 51.92, 'https://http2.mlstatic.com/D_NQ_NP_2X_882912-MLA99372602906_112025-F.webp', 'active', '2026-03-26 12:12:56.481+00', '2026-03-24 12:45:35.292654+00');
INSERT INTO public.ml_product_mappings VALUES ('a539cf4a-ea23-4658-8491-736a3dab0f72', '8ec39689-5943-49d4-a09c-2c15c00bf6c1', 'MLB56241782', 'https://www.mercadolivre.com.br/perfume-capilar-body-splash-barbours-beauty-feminino-delight/p/MLB56241782', NULL, NULL, 'new', 100, NULL, NULL, 0, 'active', NULL, 110, 'https://http2.mlstatic.com/D_NQ_NP_2X_914915-MLA92101455506_092025-F.webp', 'active', '2026-03-26 12:12:59.787+00', '2026-03-25 16:35:00.051519+00');
INSERT INTO public.ml_product_mappings VALUES ('37aa1441-b61d-40b8-afb4-99da9ec86670', '61cca252-c069-4e3a-bda6-92bc353960b5', 'MLB25371983', 'https://www.mercadolivre.com.br/lavadora-de-alta-presso-krcher-compacta-1500-psilibras-1400w-300lh-com-aplicador-de-detergente-e-lanca-regulavel-220v/p/MLB25371983?pdp_filters=deal%3AMLB779362-1', NULL, NULL, 'new', 50000, NULL, NULL, 0, 'active', 445, 299, 'https://http2.mlstatic.com/D_NQ_NP_2X_933850-MLA100077907473_122025-F.webp', 'active', '2026-03-26 12:12:59.897+00', '2026-03-23 13:24:06.244949+00');
INSERT INTO public.ml_product_mappings VALUES ('33d3c1e0-1e1f-410f-903a-b318ccb6af5a', 'bebbe3c7-58a6-4dd0-9e52-76d918dd0a41', 'MLB37258896', 'https://www.mercadolivre.com.br/kit-8-alimentaco-beb-silicone-prato-babador-copo-tigela-cor-azul-aco/p/MLB37258896', NULL, NULL, 'new', 10000, NULL, NULL, 0, 'active', NULL, 36.24, 'https://http2.mlstatic.com/D_NQ_NP_2X_908926-MLA99598913234_122025-F.webp', 'active', '2026-03-26 12:13:00.198+00', '2026-03-24 12:50:20.26704+00');
INSERT INTO public.ml_product_mappings VALUES ('354d6be8-7883-42ea-bd81-ac02552a00f8', '60467af5-058e-4e64-a766-f8d0889d0acb', 'MLB57790379', 'https://www.mercadolivre.com.br/smart-tv-philips-55-4k-55pug7300-comando-de-voz-bluetooth/p/MLB57790379?pdp_filters=deal%3AMLB779362-1', NULL, NULL, 'new', 1000, NULL, NULL, 0, 'active', 3449, 2299, 'https://http2.mlstatic.com/D_NQ_NP_2X_651129-MLA92926667074_092025-F.webp', 'active', '2026-03-26 12:13:04.303+00', '2026-03-24 01:44:49.305977+00');
INSERT INTO public.ml_product_mappings VALUES ('ec2f1aa2-60b8-47fc-841f-84b8e484ceab', '37e717c9-51b3-41a2-9f71-fdaffc3f89f8', 'MLB50278452', 'https://www.mercadolivre.com.br/caixa-cooler-termico-pequeno-8-litros-ate-12-latas-termolar-cor-cinza/p/MLB50278452', NULL, NULL, 'new', 1000, NULL, NULL, 0, 'active', 66, 52, 'https://http2.mlstatic.com/D_NQ_NP_2X_781312-MLA99461750520_112025-F.webp', 'active', '2026-03-26 12:36:04.559945+00', '2026-03-26 12:36:04.559945+00');
INSERT INTO public.ml_product_mappings VALUES ('98c43135-71e1-4964-a380-8d9c62b6a08d', '0ee21374-b263-4f18-8d3e-403dc2d7b954', 'MLB35843098', 'https://www.mercadolivre.com.br/faca-tatica-com-bainha-bussola-apito-amolador-pederneira-ponta-quebra-vidro-e-clip-com-suporte-para-cinto-lamina-corte-misto-em-aco-inox-tipo-militar-para-camping-caca-mergulho-pesca-trilha-aventura/p/MLB35843098', NULL, NULL, 'new', 1000, NULL, NULL, 0, 'active', NULL, 40, 'https://http2.mlstatic.com/D_NQ_NP_2X_824469-MLA92353998912_092025-F.webp', 'active', '2026-03-26 12:38:36.798808+00', '2026-03-26 12:38:36.798808+00');


--
-- TOC entry 4841 (class 0 OID 27200)
-- Dependencies: 414
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
INSERT INTO public.ml_sync_logs VALUES ('fe8f18f1-a15d-4fff-83a3-2376d3cd476f', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 02:37:20.336+00', '2026-03-22 02:37:20.488765+00');
INSERT INTO public.ml_sync_logs VALUES ('bc8a04cd-b1df-4cd2-a257-0b317570b3d4', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 03:04:23.705+00', '2026-03-22 03:04:23.873145+00');
INSERT INTO public.ml_sync_logs VALUES ('8409b73c-83fd-4c81-aa62-e94bb562198c', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 03:05:14.456+00', '2026-03-22 03:05:14.599264+00');
INSERT INTO public.ml_sync_logs VALUES ('9fa5511f-e37e-4ce7-9e1e-54d6aaa5667f', 'batch_sync', 'partial', 2, 0, 1, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 03:08:04.924+00', '2026-03-22 03:08:05.098938+00');
INSERT INTO public.ml_sync_logs VALUES ('50040dc1-c4ce-427e-bb60-e07433034180', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 03:22:27.662+00', '2026-03-22 03:22:27.948149+00');
INSERT INTO public.ml_sync_logs VALUES ('80bfc86e-9709-4999-901e-a1ecc30f3877', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:06:27.77+00', '2026-03-22 17:06:27.88322+00');
INSERT INTO public.ml_sync_logs VALUES ('e8741c86-6d21-4f92-a6be-1593bb430fd7', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:07:22.764+00', '2026-03-22 17:07:22.878053+00');
INSERT INTO public.ml_sync_logs VALUES ('48d84883-f34b-489f-ad83-059c907d1629', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:22:22.621+00', '2026-03-22 17:22:22.739773+00');
INSERT INTO public.ml_sync_logs VALUES ('bad66253-8bc3-42b6-b34b-56d57beb3f92', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:28:08.135+00', '2026-03-22 17:28:08.254424+00');
INSERT INTO public.ml_sync_logs VALUES ('2eb17034-0008-4a12-aaee-8d18f17c3781', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:46:33.561+00', '2026-03-22 17:46:33.719058+00');
INSERT INTO public.ml_sync_logs VALUES ('06e192ee-4a34-498c-91c9-46929f201f10', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:53:43.718+00', '2026-03-22 17:53:43.875785+00');
INSERT INTO public.ml_sync_logs VALUES ('1026cf7b-6ad4-453c-9912-26170c90bfaa', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:54:50.511+00', '2026-03-22 17:54:50.659862+00');
INSERT INTO public.ml_sync_logs VALUES ('ea68f871-41b7-4395-84e3-dffa2975ce46', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:55:23.354+00', '2026-03-22 17:55:23.474412+00');
INSERT INTO public.ml_sync_logs VALUES ('be728527-80fb-486b-97c3-8df3dc6056c4', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:57:26.194+00', '2026-03-22 17:57:26.334206+00');
INSERT INTO public.ml_sync_logs VALUES ('bee1e5a3-e9a5-4086-ba4d-9b8e01cfdb10', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 17:57:56.655+00', '2026-03-22 17:57:56.792278+00');
INSERT INTO public.ml_sync_logs VALUES ('3a8c4569-8163-4a46-a5b2-a37417682129', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 18:09:51.872+00', '2026-03-22 18:09:52.001899+00');
INSERT INTO public.ml_sync_logs VALUES ('5f144364-87be-4e8a-98fd-783b9df23f19', 'batch_sync', 'partial', 3, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 18:11:33.868+00', '2026-03-22 18:11:33.987926+00');
INSERT INTO public.ml_sync_logs VALUES ('28d4aba0-cbdb-44c9-8e08-666e5a2ee671', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 19:08:45.642+00', '2026-03-22 19:08:45.766679+00');
INSERT INTO public.ml_sync_logs VALUES ('a24521d9-360b-4c64-a751-5d3099bf5eef', 'batch_sync', 'partial', 4, 0, 2, 'Item 403: {"code":403,"body":{"id":"MLB4122378095","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}; Item 403: {"code":403,"body":{"id":"MLB5199984244","message":"Access to the requested resource is forbidden","error":"access_denied","status":403,"cause":null}}', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 19:42:02.317+00', '2026-03-22 19:42:02.429019+00');
INSERT INTO public.ml_sync_logs VALUES ('e657fbff-0fbc-42d8-8387-f3cb1f40cb31', 'batch_sync_scraping', 'partial', 4, 1, 0, 'Scrape Error no MLB52941149: HTTP error! status: 404; Scrape Error no MLB61517857: HTTP error! status: 404', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 21:01:10.382+00', '2026-03-22 21:01:10.532989+00');
INSERT INTO public.ml_sync_logs VALUES ('9401f9c3-204b-4a81-9b21-d99e8c4ae87a', 'batch_sync_scraping', 'partial', 4, 0, 0, 'Scrape Error no MLB52941149: HTTP error! status: 404; Scrape Error no MLB61517857: HTTP error! status: 404', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 21:02:58.001+00', '2026-03-22 21:02:58.368617+00');
INSERT INTO public.ml_sync_logs VALUES ('566ebc5f-1d8a-4983-a438-52e097db0a4f', 'batch_sync_scraping', 'partial', 4, 0, 0, 'Scrape Error no MLB52941149: HTTP error! status: 404; Scrape Error no MLB61517857: HTTP error! status: 404', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 21:03:24.044+00', '2026-03-22 21:03:24.206998+00');
INSERT INTO public.ml_sync_logs VALUES ('370d7603-8b06-4a7f-9a08-df4b998b2098', 'batch_sync_scraping', 'success', 4, 2, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 21:14:08.015+00', '2026-03-22 21:14:08.130773+00');
INSERT INTO public.ml_sync_logs VALUES ('668e0fad-0c21-4b6f-ba4f-b4c0ebb53614', 'batch_sync_scraping', 'partial', 4, 1, 0, 'Scrape Error no MLB52941149: HTTP error! status: 409', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 22:52:58.328+00', '2026-03-22 22:52:58.436923+00');
INSERT INTO public.ml_sync_logs VALUES ('21ee79dc-4577-4391-86f2-376c3a590f71', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 23:28:27.212+00', '2026-03-22 23:28:27.349594+00');
INSERT INTO public.ml_sync_logs VALUES ('47a42baf-ca68-4ef9-92ad-41c0b2504851', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-22 23:49:59.702+00', '2026-03-22 23:49:59.846273+00');
INSERT INTO public.ml_sync_logs VALUES ('97ef6b7a-0283-4626-9a5e-152be7d75418', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-23 00:14:53.859+00', '2026-03-23 00:14:53.974923+00');
INSERT INTO public.ml_sync_logs VALUES ('569dfd7e-bddf-4ba9-94fe-d5d8f85082fc', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-23 00:20:16.587+00', '2026-03-23 00:20:16.705538+00');
INSERT INTO public.ml_sync_logs VALUES ('6a785a4b-e017-429b-9410-615017084381', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-23 00:36:54.669+00', '2026-03-23 00:36:54.812497+00');
INSERT INTO public.ml_sync_logs VALUES ('0e119450-89db-4d64-a4f6-9c39daa6b382', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-23 00:41:02.134+00', '2026-03-23 00:41:02.289618+00');
INSERT INTO public.ml_sync_logs VALUES ('bd90432f-329e-4475-bcc3-064ad74dcda2', 'batch_sync_scraping', 'partial', 5, 1, 0, 'Scrape Error no MLB52941149: HTTP error! status: 409; Scrape Error no MLB61517857: HTTP error! status: 409; Scrape Error no MLB4016066645: HTTP error! status: 409', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-23 01:09:14.807+00', '2026-03-23 01:09:14.953612+00');
INSERT INTO public.ml_sync_logs VALUES ('495486ab-db49-4caf-9197-ab23fa0a6f5a', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 13:24:06.378+00', '2026-03-23 13:24:06.483515+00');
INSERT INTO public.ml_sync_logs VALUES ('ac9271a5-57ad-4603-87eb-cf4c8732474d', 'batch_sync_scraping', 'partial', 6, 1, 0, 'Scrape Error no MLB5199984244: HTTP error! status: 409; Scrape Error no MLB4122378095: HTTP error! status: 409', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-23 20:28:41.079+00', '2026-03-23 20:28:41.184244+00');
INSERT INTO public.ml_sync_logs VALUES ('9825116e-4973-4d98-9d79-05af7ecb244c', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 01:44:49.44+00', '2026-03-24 01:44:49.580726+00');
INSERT INTO public.ml_sync_logs VALUES ('77a4b93c-d741-4cce-a999-3e7db44f631e', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:45:35.42+00', '2026-03-24 12:45:35.581884+00');
INSERT INTO public.ml_sync_logs VALUES ('e5928697-d2e8-4581-9527-1ae1e85064c7', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:50:20.377+00', '2026-03-24 12:50:20.491877+00');
INSERT INTO public.ml_sync_logs VALUES ('bbfa2e2f-dd9a-465f-9297-601230f9921e', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 18:34:50.92+00', '2026-03-24 18:34:51.03023+00');
INSERT INTO public.ml_sync_logs VALUES ('2a65767c-4cc8-4ad4-a44d-681dc012192a', 'batch_sync_scraping', 'success', 10, 4, 1, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 22:22:59.224+00', '2026-03-24 22:22:59.346239+00');
INSERT INTO public.ml_sync_logs VALUES ('c3a4405f-b75e-40c8-9ee5-b4a31b02b402', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 11:05:23.593+00', '2026-03-25 11:05:23.749531+00');
INSERT INTO public.ml_sync_logs VALUES ('07057643-e4e1-4c4d-b2eb-0ce965b97941', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 14:46:37.223+00', '2026-03-25 14:46:37.356852+00');
INSERT INTO public.ml_sync_logs VALUES ('bf6f7f4f-eb35-46ea-8c19-68a231992785', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 14:47:08.986+00', '2026-03-25 14:47:09.113415+00');
INSERT INTO public.ml_sync_logs VALUES ('ce13a38b-c3e8-4738-82f5-96948ea653ff', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 14:48:55.644+00', '2026-03-25 14:48:55.770257+00');
INSERT INTO public.ml_sync_logs VALUES ('4164c4a3-ada2-4239-bb94-ba5dee3ffe8d', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 15:57:45.43+00', '2026-03-25 15:57:45.550039+00');
INSERT INTO public.ml_sync_logs VALUES ('ce28c8de-d62c-4bad-a9df-476b115834ca', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 16:34:57.267+00', '2026-03-25 16:34:57.378084+00');
INSERT INTO public.ml_sync_logs VALUES ('335c5c13-488a-46f6-8447-4b175cbc5bfb', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 16:35:00.178+00', '2026-03-25 16:35:00.303574+00');
INSERT INTO public.ml_sync_logs VALUES ('255dd200-8732-4f1f-89be-e07321fa75b8', 'batch_sync_scraping', 'success', 13, 5, 1, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-26 12:13:05.236+00', '2026-03-26 12:13:05.351341+00');
INSERT INTO public.ml_sync_logs VALUES ('6e489779-567b-423b-b8b1-1f9c50a588c1', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-26 12:36:04.669+00', '2026-03-26 12:36:04.817609+00');
INSERT INTO public.ml_sync_logs VALUES ('dc5cf371-2896-4538-ad26-f25487dbffa6', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-26 12:38:36.911+00', '2026-03-26 12:38:37.028632+00');
INSERT INTO public.ml_sync_logs VALUES ('b72588c8-ff8b-4b52-8744-e0e928124768', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-26 14:33:27.03+00', '2026-03-26 14:33:27.184814+00');
INSERT INTO public.ml_sync_logs VALUES ('d39e532d-acf4-485b-b19d-aa70d6d04818', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-26 22:38:42.875+00', '2026-03-26 22:38:43.024283+00');
INSERT INTO public.ml_sync_logs VALUES ('15c0ed5c-5fe5-4516-99f2-6457735f6a72', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-26 23:26:54.123+00', '2026-03-26 23:26:54.307765+00');


--
-- TOC entry 4839 (class 0 OID 27166)
-- Dependencies: 412
-- Data for Name: ml_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ml_tokens VALUES ('a4c4140e-00ef-4995-9a55-f4c2c0403d1e', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'APP_USR-1311651017806191-032213-be4f61493a3ba829c9dec5dd28ca8e5a-225054608', 'TG-69c021923060ea0001dbbb37-225054608', '2026-03-22 23:06:26.217+00', '225054608', '2026-03-21 03:40:00.124155+00', '2026-03-22 17:06:26.217+00');


--
-- TOC entry 4819 (class 0 OID 22142)
-- Dependencies: 392
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
INSERT INTO public.models VALUES ('31cbc9c3-b624-4245-85e7-2e4d27e2c02e', 'e0c0b6f0-fa5b-4231-b28c-af9e83dd92e8', 'FFW-F11', '2026-03-21 18:59:24.641108+00');
INSERT INTO public.models VALUES ('0993958d-8938-48aa-b0d8-93f92a912f96', '1a071b94-6208-4fc3-bfa5-2fc6be200de4', 'Inox Búzios', '2026-03-23 18:03:33.543859+00');
INSERT INTO public.models VALUES ('5cbe6e44-319e-40d3-8f78-e32d09234a7a', 'abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', 'Todo Dia', '2026-03-23 18:43:53.650253+00');
INSERT INTO public.models VALUES ('f9ff2a1b-69b7-4b01-8916-93bbadae3351', 'abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', 'Mamãe e Bebê', '2026-03-23 22:22:32.610379+00');
INSERT INTO public.models VALUES ('ba7bc42e-11d1-4bf9-b887-4b9ff4daada7', 'c8ac1472-f7ac-46fe-9728-e0a2924d58f6', 'Redmi 15 pro', '2026-03-23 22:46:05.563754+00');
INSERT INTO public.models VALUES ('403c5506-f467-412c-a92c-e48972857671', '9336d222-8a26-427b-9e2d-d9e75457a042', '55pug7300', '2026-03-24 01:46:03.14593+00');
INSERT INTO public.models VALUES ('c253d78d-6b05-46ae-ba05-c36fddf50a17', '232eb3f8-6e67-45c6-8a48-d56e83a85391', 'Lavitan', '2026-03-25 16:58:27.376687+00');
INSERT INTO public.models VALUES ('02de7dec-e4f3-4653-9287-4c155ead3e0a', '562df9b8-8a3a-419d-bce3-152b980c7927', 'X7 5G', '2026-03-26 22:44:07.920294+00');
INSERT INTO public.models VALUES ('8d9a375f-9fc1-4958-bcf6-5fb8c52e087e', '382b00de-6d79-4e7b-9e18-673c1333a299', 'Beta Alanina Pura', '2026-03-26 23:27:40.816271+00');


--
-- TOC entry 4830 (class 0 OID 22381)
-- Dependencies: 403
-- Data for Name: newsletter_products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.newsletter_products VALUES ('a8f3404f-5dd7-41ca-ad30-6ee71bdcba1f', '8e10d48e-849f-46c2-9457-fb7369e28706');
INSERT INTO public.newsletter_products VALUES ('a8f3404f-5dd7-41ca-ad30-6ee71bdcba1f', '2b2649bf-137c-4614-b2ed-9e7879872492');
INSERT INTO public.newsletter_products VALUES ('a8f3404f-5dd7-41ca-ad30-6ee71bdcba1f', '37e74a05-5862-47b3-b01d-ebb0f81c4d9a');


--
-- TOC entry 4829 (class 0 OID 22370)
-- Dependencies: 402
-- Data for Name: newsletters; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.newsletters VALUES ('a8f3404f-5dd7-41ca-ad30-6ee71bdcba1f', 'Promoções da Semana', '<p>Olá,</p><p>Confira nossas ofertas imperdíveis desta semana!</p>', 'draft', '2026-03-26 19:54:38.154488+00');


--
-- TOC entry 4820 (class 0 OID 22160)
-- Dependencies: 393
-- Data for Name: platforms; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.platforms VALUES ('31640105-56f9-43ab-8204-465c8717d731', 'Amazon', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1773595590624.webp', '2026-03-15 17:27:07.602531+00');
INSERT INTO public.platforms VALUES ('5a54bf84-4707-4f0f-a23c-689469fdbbb7', 'Shopee', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1773595674820.png', '2026-03-15 17:28:28.049073+00');
INSERT INTO public.platforms VALUES ('470eab59-13aa-43e1-84f0-71712bd56389', 'Mercado Livre', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1774059464441.png', '2026-03-21 02:18:26.509464+00');
INSERT INTO public.platforms VALUES ('f729f5cd-3b0a-4ded-88d8-a5b578f0fb0b', 'Natura', 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/platform-1774325396039.png', '2026-03-24 04:07:23.945332+00');


--
-- TOC entry 4831 (class 0 OID 22408)
-- Dependencies: 404
-- Data for Name: price_history; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.price_history VALUES ('586adee0-f682-40f9-8278-5e2cc74b8bf1', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 96, '2026-03-23 00:36:54.21849+00');
INSERT INTO public.price_history VALUES ('b151b168-2ee2-4648-a189-ee18732c27e4', 'c2cd6c40-7828-4dcc-b08d-39f06e01f91c', 183, '2026-03-23 00:41:01.714081+00');
INSERT INTO public.price_history VALUES ('eabed315-abb7-4ce1-98c9-6b5f0c96f010', 'c2cd6c40-7828-4dcc-b08d-39f06e01f91c', 200, '2026-03-23 01:08:00.448735+00');
INSERT INTO public.price_history VALUES ('aab736f9-5f9d-4f65-a03a-5a5ddf8854e0', 'c2cd6c40-7828-4dcc-b08d-39f06e01f91c', 183.9, '2026-03-23 01:09:07.58298+00');
INSERT INTO public.price_history VALUES ('968687f7-d51c-4dbe-bffd-7e968bda208a', '61cca252-c069-4e3a-bda6-92bc353960b5', 299, '2026-03-23 13:24:05.97903+00');
INSERT INTO public.price_history VALUES ('3c13e57e-51dd-4ced-aa13-cece376000fd', '28d1f05e-c067-4725-a756-54448e085c8d', 14.76, '2026-03-23 13:40:38.126575+00');
INSERT INTO public.price_history VALUES ('ae3e11ac-5188-410c-acca-e8d80e1918c2', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 33.3183, '2026-03-23 18:02:39.092911+00');
INSERT INTO public.price_history VALUES ('c56cb531-5f71-4c01-8690-b9a59cd53699', '4fc7c7b9-083e-453c-a19e-8bba1652d258', 75.9, '2026-03-23 18:44:06.5212+00');
INSERT INTO public.price_history VALUES ('66ab06fb-6ad7-4dff-a011-eab7b6acb472', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 99.24, '2026-03-23 20:28:40.686025+00');
INSERT INTO public.price_history VALUES ('4f82c063-76d0-42a3-84f7-490951bb1d47', 'f6da7233-17ac-4252-8af4-e0216a3aebe9', 128.1, '2026-03-23 22:23:10.823822+00');
INSERT INTO public.price_history VALUES ('86ca0b87-86fa-41a2-873d-3c06c41a77eb', '6ca89580-baee-47a1-8ef0-890843531fe2', 229.9, '2026-03-23 22:30:27.364116+00');
INSERT INTO public.price_history VALUES ('0e1ee4f1-8f1e-4a5b-bb2c-2200100c7de9', '5ca3995f-eac6-4363-93fa-42b0c96761cf', 1079.3999999999999, '2026-03-23 22:42:11.063938+00');
INSERT INTO public.price_history VALUES ('39d63e91-7d94-40c2-a74b-105ac548a6a8', '5ca3995f-eac6-4363-93fa-42b0c96761cf', 1655.08, '2026-03-23 22:47:08.584357+00');
INSERT INTO public.price_history VALUES ('5f092d28-30a6-43cb-bded-71e4771d06ad', '60467af5-058e-4e64-a766-f8d0889d0acb', 2079, '2026-03-24 01:44:48.951482+00');
INSERT INTO public.price_history VALUES ('4cac38c7-aafa-4955-91bd-c5e8f483be23', 'f6b55013-88ec-4968-b251-94ba1535261e', 219, '2026-03-24 05:14:38.960866+00');
INSERT INTO public.price_history VALUES ('4f75957e-8236-4d55-ac3a-1cf2fc624187', 'f6b55013-88ec-4968-b251-94ba1535261e', 220, '2026-03-24 05:17:01.717137+00');
INSERT INTO public.price_history VALUES ('fee7179f-92cc-47ab-8514-bf9199e68e95', 'f6b55013-88ec-4968-b251-94ba1535261e', 219, '2026-03-24 05:17:31.996228+00');
INSERT INTO public.price_history VALUES ('77ba219f-2584-40e9-944c-3617888d7e49', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', 69.9, '2026-03-24 05:23:00.692898+00');
INSERT INTO public.price_history VALUES ('c32ffa49-daf6-416c-8c16-f492794ca7ea', '9016cde9-ce2b-4eef-9b4a-dfd1bd88d5aa', 19.99, '2026-03-24 11:54:41.610956+00');
INSERT INTO public.price_history VALUES ('9488a90e-2811-4941-bdc8-a00d2161c382', '8c9da536-3571-4884-adf2-53979297d96a', 49.99, '2026-03-24 11:55:15.881433+00');
INSERT INTO public.price_history VALUES ('e0e13b5f-03e7-43b3-9aee-cf5e21c2dbd0', 'ddb4a64b-3797-4277-9cf1-2322ca0a7f2e', 37.02, '2026-03-24 11:55:32.530478+00');
INSERT INTO public.price_history VALUES ('46fb483b-3b9d-43a6-b42f-397ad9303bb3', 'f6b55013-88ec-4968-b251-94ba1535261e', 220, '2026-03-24 12:24:39.219306+00');
INSERT INTO public.price_history VALUES ('159fc528-5d5e-4cfb-95a1-266f28ea737a', 'f6b55013-88ec-4968-b251-94ba1535261e', 219, '2026-03-24 12:25:03.311005+00');
INSERT INTO public.price_history VALUES ('0ed32426-b6ed-417b-8a07-ce3a9674e068', 'ddb4a64b-3797-4277-9cf1-2322ca0a7f2e', 67.7, '2026-03-24 12:40:24.035149+00');
INSERT INTO public.price_history VALUES ('9cb265fe-17bb-4915-bb22-3a1eaacc2b25', '3d3a7ef6-3197-44c8-8035-1627dbe6c690', 51, '2026-03-24 12:45:34.978946+00');
INSERT INTO public.price_history VALUES ('a85ee57d-0d4d-4cf6-9802-cd36cd61e1cc', 'bebbe3c7-58a6-4dd0-9e52-76d918dd0a41', 36, '2026-03-24 12:50:20.030835+00');
INSERT INTO public.price_history VALUES ('98f9649d-22b4-4a97-8b76-5d2071108d81', '8d949db7-5014-46e5-8398-24d545ad995b', 16.795800000000003, '2026-03-24 18:03:40.199651+00');
INSERT INTO public.price_history VALUES ('395a0790-109a-4ef8-b38f-6e1ca4ca9cf0', '8d949db7-5014-46e5-8398-24d545ad995b', 16.99, '2026-03-24 18:08:05.010271+00');
INSERT INTO public.price_history VALUES ('dabcc0ed-a4f0-4814-8602-d88bd5d7fccc', '0a03bc3e-74f1-415c-8a15-7da6336985e0', 40, '2026-03-24 18:34:50.465069+00');
INSERT INTO public.price_history VALUES ('ffc87cc0-a7d9-4644-be3b-7db73b30bd79', '0a03bc3e-74f1-415c-8a15-7da6336985e0', 40.54, '2026-03-24 18:36:28.140392+00');
INSERT INTO public.price_history VALUES ('45c01850-7d97-4ceb-a2ef-b227ea5744ea', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 70.89, '2026-03-24 19:53:23.439504+00');
INSERT INTO public.price_history VALUES ('c4ad7ed3-69d0-4a66-b3a8-4fc026276e64', 'b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', 26.1, '2026-03-24 21:42:21.24471+00');
INSERT INTO public.price_history VALUES ('b5dc0b15-df58-4812-9476-a2d92173188e', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 18.668, '2026-03-24 22:01:11.239937+00');
INSERT INTO public.price_history VALUES ('f2c3fa61-a9eb-4295-a238-df36ff9147f9', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 21.9, '2026-03-24 22:05:13.821807+00');
INSERT INTO public.price_history VALUES ('1ce4f4fd-8687-445b-8d17-fbe4fd1b3b7b', '5ca3995f-eac6-4363-93fa-42b0c96761cf', 1333.42, '2026-03-24 22:22:29.160885+00');
INSERT INTO public.price_history VALUES ('a8321d45-741f-499d-b6fb-151c02b2b01a', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 33.3183, '2026-03-24 22:22:32.197804+00');
INSERT INTO public.price_history VALUES ('81fdb238-58e7-4424-8dad-21910de45e00', 'ddb4a64b-3797-4277-9cf1-2322ca0a7f2e', 37.62, '2026-03-24 22:22:32.6716+00');
INSERT INTO public.price_history VALUES ('43760fd4-ccf2-40cc-b3e3-b4cd60331ac1', '8d949db7-5014-46e5-8398-24d545ad995b', 16.795800000000003, '2026-03-24 22:22:33.155813+00');
INSERT INTO public.price_history VALUES ('b07d4759-bc5b-455f-99ba-b00e452e5995', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 18.668, '2026-03-24 22:22:33.634142+00');
INSERT INTO public.price_history VALUES ('505b6e27-e924-4ca2-a1bc-d67a4889dc13', '3d3a7ef6-3197-44c8-8035-1627dbe6c690', 51.92, '2026-03-24 22:22:57.916244+00');
INSERT INTO public.price_history VALUES ('42196ae7-c9f9-4fe4-9d46-bbcd8b7628c9', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 96.57, '2026-03-24 22:22:58.135994+00');
INSERT INTO public.price_history VALUES ('14284d5b-2dee-4512-b70a-6a0e475ebe7c', 'bebbe3c7-58a6-4dd0-9e52-76d918dd0a41', 36.24, '2026-03-24 22:22:58.740778+00');
INSERT INTO public.price_history VALUES ('3c5298b2-775b-41a3-a6b8-9909eb67232d', 'f6b55013-88ec-4968-b251-94ba1535261e', 199, '2026-03-24 22:25:11.403107+00');
INSERT INTO public.price_history VALUES ('5d9657c5-9081-4fd8-86be-6e7960f8e77b', 'cbe4fef6-d959-449f-bb05-07ab8a84d026', 9.857100000000003, '2026-03-25 00:04:24.521111+00');
INSERT INTO public.price_history VALUES ('3a1c1a26-77f8-426b-becf-4d2dd9b67a91', 'cbe4fef6-d959-449f-bb05-07ab8a84d026', 29, '2026-03-25 00:08:35.912057+00');
INSERT INTO public.price_history VALUES ('e2245102-0c4a-4f33-b892-d284e42da3b3', '41d2c588-4b18-42c9-affb-1aaab6a3cf92', 198.9, '2026-03-25 11:11:03.947128+00');
INSERT INTO public.price_history VALUES ('c0d827a7-5ef7-4c4d-832d-4a51da371d42', 'fdcf0f14-b63d-42e0-ae79-ac2552282bf6', 24.99, '2026-03-25 12:58:49.303185+00');
INSERT INTO public.price_history VALUES ('c157c1bf-4db7-437a-a602-b2b5326f0956', 'fdcf0f14-b63d-42e0-ae79-ac2552282bf6', 39.98, '2026-03-25 13:02:10.810752+00');
INSERT INTO public.price_history VALUES ('47462265-780f-4154-af10-bd5f3bb0ae50', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', 75, '2026-03-25 14:46:36.852789+00');
INSERT INTO public.price_history VALUES ('a1c6755d-167a-4e29-9252-69d23fd3b267', '4f9c76f9-9bb1-43ee-90ce-04cf0754f4ec', 32, '2026-03-25 14:47:08.628231+00');
INSERT INTO public.price_history VALUES ('f2643744-25ec-4edc-a73e-5cfd2d008daa', '0252b325-31e9-4f69-9952-8d821019dd14', 119, '2026-03-25 14:48:55.296206+00');
INSERT INTO public.price_history VALUES ('8a836c86-f860-4455-8d7a-bad275060286', '0252b325-31e9-4f69-9952-8d821019dd14', 119.9, '2026-03-25 14:50:23.888237+00');
INSERT INTO public.price_history VALUES ('ad683bc0-6bdc-4025-90b6-4010e257c809', 'a2c9ad39-f849-490c-ae4f-7860daa642c6', 269, '2026-03-25 15:57:44.995872+00');
INSERT INTO public.price_history VALUES ('0e877b81-9143-4304-be46-f845c2e29583', 'b889d94a-45fd-4443-9e42-f16afd61cc16', 97, '2026-03-25 16:34:56.862129+00');
INSERT INTO public.price_history VALUES ('20892353-c64e-4ccf-8d58-3de8190c552c', '8ec39689-5943-49d4-a09c-2c15c00bf6c1', 110, '2026-03-25 16:34:59.788987+00');
INSERT INTO public.price_history VALUES ('c868a61a-a181-41d4-aa0b-2ed4f5ff89b3', 'b889d94a-45fd-4443-9e42-f16afd61cc16', 139, '2026-03-25 16:37:08.161459+00');
INSERT INTO public.price_history VALUES ('da07c516-eae2-41c2-b15a-e3a5e5ae92bb', '41e3e392-9d32-42a4-9afc-12a4bfcfda9d', 594.9915, '2026-03-25 16:39:57.94632+00');
INSERT INTO public.price_history VALUES ('76b3450d-33c0-49a3-9088-3011490d1519', '41e3e392-9d32-42a4-9afc-12a4bfcfda9d', 699.99, '2026-03-25 16:41:05.051345+00');
INSERT INTO public.price_history VALUES ('6b2c8e94-48d9-4758-b19c-a8e49d3c19d7', '20a59a16-2821-49e6-b140-d06d8664af0a', 47.99, '2026-03-25 16:56:49.513583+00');
INSERT INTO public.price_history VALUES ('c2be4305-a554-477e-9798-0110ce754414', '6e60439d-bb86-4de1-a6a3-a450669e31da', 46.7766, '2026-03-25 16:59:26.132668+00');
INSERT INTO public.price_history VALUES ('5f6fce08-8f28-4fd3-bf1d-fd16686372c0', 'd2eb75e2-53bf-45dc-877b-e4c96132b43d', 69.8, '2026-03-25 17:34:25.215775+00');
INSERT INTO public.price_history VALUES ('3d410268-1c55-4513-836e-1c095b6e3c29', 'ad502528-58d6-4f78-9971-e5286a526546', 98.9, '2026-03-25 22:20:00.558781+00');
INSERT INTO public.price_history VALUES ('e8505d82-b8a3-4b0f-ab54-62ca9b04ea42', '1177c463-9ddd-4d01-ba58-070d95037d8b', 99.9, '2026-03-25 22:23:08.875515+00');
INSERT INTO public.price_history VALUES ('636df0e0-a1ec-4124-84a3-32807fb490b1', 'ae6ab7a4-165c-4c39-a209-f5f4cc516cf6', 37.9, '2026-03-25 22:25:32.355646+00');
INSERT INTO public.price_history VALUES ('03adde31-eced-4ad8-96d5-34eafbf1c0cf', '2afe5d48-cdf8-4641-b2cf-d193ae4e93c7', 33.97, '2026-03-25 22:27:58.771336+00');
INSERT INTO public.price_history VALUES ('c817ba2e-edc8-4484-80a6-ff077c917c43', '3b7de2f5-749e-4f0a-b085-22dcd1c4f631', 59.3, '2026-03-25 22:30:42.822575+00');
INSERT INTO public.price_history VALUES ('f36acc0c-c764-4fd4-829e-447c55dee02e', 'df68154b-cc8e-4371-ad08-84b16061c6ed', 179.99, '2026-03-25 22:33:25.605061+00');
INSERT INTO public.price_history VALUES ('93996598-afca-42b5-b154-44b687cd66dd', '48810ae3-ce2a-4f66-b962-116d4a94a95e', 418.16, '2026-03-26 00:17:44.582132+00');
INSERT INTO public.price_history VALUES ('2cbc6bfa-3764-458b-b152-f806605fe0d0', '29ef0946-b25e-4f3d-9d90-8df9924e0a61', 68.7, '2026-03-26 00:23:54.825388+00');
INSERT INTO public.price_history VALUES ('e6186da1-80b3-4f33-8ece-a5453c2eb582', '48810ae3-ce2a-4f66-b962-116d4a94a95e', 499, '2026-03-26 12:11:52.644288+00');
INSERT INTO public.price_history VALUES ('ee23731b-7cd7-429a-98b3-3285db4cc802', 'f6b55013-88ec-4968-b251-94ba1535261e', 234.5, '2026-03-26 12:12:37.187431+00');
INSERT INTO public.price_history VALUES ('09d0a3eb-7935-444f-9925-e563f14a45f5', 'a2c9ad39-f849-490c-ae4f-7860daa642c6', 269.98, '2026-03-26 12:12:53.578054+00');
INSERT INTO public.price_history VALUES ('c45ddd6a-6968-42d3-bdc4-042925147e16', 'b889d94a-45fd-4443-9e42-f16afd61cc16', 97.41, '2026-03-26 12:12:54.441257+00');
INSERT INTO public.price_history VALUES ('7e5b0c49-8e6d-441e-bc70-1526b8c511ad', '1177c463-9ddd-4d01-ba58-070d95037d8b', 97.9, '2026-03-26 12:12:56.976048+00');
INSERT INTO public.price_history VALUES ('5007b9e1-f5a5-4432-988b-5b150c0373df', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 99.24, '2026-03-26 12:13:00.309251+00');
INSERT INTO public.price_history VALUES ('5fbb8077-a3ae-4c57-91ab-4d2bd8cd52d7', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', 78.98, '2026-03-26 12:13:04.103887+00');
INSERT INTO public.price_history VALUES ('e94371f3-4b9f-47f1-9dc7-c75495453e60', '60467af5-058e-4e64-a766-f8d0889d0acb', 2299, '2026-03-26 12:13:04.890988+00');
INSERT INTO public.price_history VALUES ('6cc8e009-8394-4357-8957-b036634dcbc3', '37e717c9-51b3-41a2-9f71-fdaffc3f89f8', 52, '2026-03-26 12:36:04.222613+00');
INSERT INTO public.price_history VALUES ('932906b2-73db-4356-9f57-ddb68c1ff375', '0ee21374-b263-4f18-8d3e-403dc2d7b954', 40, '2026-03-26 12:38:36.548311+00');
INSERT INTO public.price_history VALUES ('aab292cf-06db-477a-9ad7-879ca29fe639', '3dbbbda2-0da3-4eb5-8452-928abf2a902d', 99.9, '2026-03-26 14:23:37.937102+00');
INSERT INTO public.price_history VALUES ('c771fdb8-2743-40c9-a0c4-0a4943c5a692', '37e74a05-5862-47b3-b01d-ebb0f81c4d9a', 116, '2026-03-26 14:33:26.614746+00');
INSERT INTO public.price_history VALUES ('928de1ed-5f67-452e-bca8-08e8703f26a7', '2b2649bf-137c-4614-b2ed-9e7879872492', 199, '2026-03-26 15:48:53.711203+00');
INSERT INTO public.price_history VALUES ('4f2fc50e-bd59-4108-a42e-43abc8066465', '8e10d48e-849f-46c2-9457-fb7369e28706', 398.99, '2026-03-26 15:51:33.054562+00');
INSERT INTO public.price_history VALUES ('53d1d9aa-979f-41e4-8fa4-a3044543e833', '2b2649bf-137c-4614-b2ed-9e7879872492', 179.1, '2026-03-26 16:10:03.048248+00');
INSERT INTO public.price_history VALUES ('89d0f783-ff24-4924-b621-fad11b955952', 'a9f0ec91-fb56-44f0-a187-1d8f83ef165a', 93.1, '2026-03-26 22:18:11.470686+00');
INSERT INTO public.price_history VALUES ('cf24b676-30a3-4d0c-971d-a32281bea7ba', '854666ec-2a9c-469a-abf2-90da03304e86', 299, '2026-03-26 22:22:22.381254+00');
INSERT INTO public.price_history VALUES ('eb285b89-de1a-47fb-8ea6-0275db06f72b', 'cdeffb1e-5dab-413a-a8cf-31381f3ba852', 78, '2026-03-26 22:38:42.485224+00');
INSERT INTO public.price_history VALUES ('76eb4232-87d5-4379-8c3b-1bab7bd1aa9b', 'cdeffb1e-5dab-413a-a8cf-31381f3ba852', 78.9, '2026-03-26 22:40:24.197068+00');
INSERT INTO public.price_history VALUES ('b4655c9b-1bdf-4279-a408-60e4e9e7b63c', '0722cf53-1ac7-4c08-9cfb-8c677201c8ba', 2099.99, '2026-03-26 22:41:54.003318+00');
INSERT INTO public.price_history VALUES ('e5300503-3509-447c-a0e9-8179bc6d2c38', '0722cf53-1ac7-4c08-9cfb-8c677201c8ba', 1577.6, '2026-03-26 22:44:21.849337+00');
INSERT INTO public.price_history VALUES ('f0002b22-c0b3-44bd-ba85-113a3727a8a7', '177c4305-2669-48c3-b11f-37943399a858', 57.62, '2026-03-26 22:49:20.328942+00');
INSERT INTO public.price_history VALUES ('2622853d-67e1-4eb6-af6f-8038b02c76ab', '5353db0e-e430-4c53-879e-3c187d777f13', 234.5, '2026-03-26 23:00:10.702295+00');
INSERT INTO public.price_history VALUES ('ebff8a86-8c9b-4259-be17-348e2f11b73f', '506bd334-8dc9-458b-96c1-f99e9c6db36d', 57.9, '2026-03-26 23:08:07.415508+00');
INSERT INTO public.price_history VALUES ('1c8b8ea0-479d-4b90-948a-10ef0146f7f6', 'cb3b34a4-7715-4237-ad79-989dd3b08561', 43, '2026-03-26 23:26:53.688025+00');
INSERT INTO public.price_history VALUES ('4eb279ab-7f08-439a-a265-9e59bad14349', 'cb3b34a4-7715-4237-ad79-989dd3b08561', 43.7, '2026-03-26 23:27:58.637227+00');


--
-- TOC entry 4827 (class 0 OID 22328)
-- Dependencies: 400
-- Data for Name: product_clicks; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.product_clicks VALUES ('05d00cbb-0187-4321-94db-b1544ca92977', 'f891a701-12b9-4a70-8677-5c2bee61e4f2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-18 21:42:09.123581+00');
INSERT INTO public.product_clicks VALUES ('e2f1a9ce-bd34-4b8a-9c3c-586d227b1d24', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-23 00:38:05.127914+00');
INSERT INTO public.product_clicks VALUES ('c1245f61-3514-4dbf-a07f-b82b9e9d6dec', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-23 00:39:51.723963+00');
INSERT INTO public.product_clicks VALUES ('99384387-be15-4d23-866c-5cf4de2db6ef', '82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-23 13:22:22.4224+00');
INSERT INTO public.product_clicks VALUES ('f68b4111-a2a7-4a54-8ac0-150a43bd38d1', '5ca3995f-eac6-4363-93fa-42b0c96761cf', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 00:59:16.548512+00');
INSERT INTO public.product_clicks VALUES ('e26e1db7-3f06-4346-a2c1-c53d6e4eb75e', '60467af5-058e-4e64-a766-f8d0889d0acb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 01:49:32.598916+00');
INSERT INTO public.product_clicks VALUES ('bede0872-70d9-43b5-abdd-7c96c31fed1f', '60467af5-058e-4e64-a766-f8d0889d0acb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 02:07:48.70433+00');
INSERT INTO public.product_clicks VALUES ('2e016d49-5927-4620-9c53-64a232285fd7', '60467af5-058e-4e64-a766-f8d0889d0acb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 02:20:22.677612+00');
INSERT INTO public.product_clicks VALUES ('071d8bca-4cf1-4eff-ac04-a122cd2e7382', '60467af5-058e-4e64-a766-f8d0889d0acb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 02:20:42.823672+00');
INSERT INTO public.product_clicks VALUES ('cb71597e-367b-42e8-b698-952022526a5f', '60467af5-058e-4e64-a766-f8d0889d0acb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 02:43:49.54429+00');
INSERT INTO public.product_clicks VALUES ('dbb7a292-c8ed-459d-8bce-265991337a61', '60467af5-058e-4e64-a766-f8d0889d0acb', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 02:44:32.714676+00');
INSERT INTO public.product_clicks VALUES ('3cbe48e4-8c67-4164-82df-b923a76ccadc', 'f6b55013-88ec-4968-b251-94ba1535261e', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 05:16:08.188611+00');
INSERT INTO public.product_clicks VALUES ('958e6a17-fb77-4053-bf9d-fe496a6c6c23', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 12:55:16.023058+00');
INSERT INTO public.product_clicks VALUES ('a205ee42-1b1b-4e5a-8b49-626d2e3f9567', 'bebbe3c7-58a6-4dd0-9e52-76d918dd0a41', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 12:58:20.3777+00');
INSERT INTO public.product_clicks VALUES ('dee21f54-aa1d-4f98-8485-7930d489c3d7', '3d3a7ef6-3197-44c8-8035-1627dbe6c690', NULL, '93c245e0-1bc9-4724-98e4-46351abf34ae', '2026-03-24 13:47:30.570369+00');
INSERT INTO public.product_clicks VALUES ('b007904f-c412-49a8-b91c-378dbc2c1f42', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-24 14:44:46.645712+00');
INSERT INTO public.product_clicks VALUES ('35346427-aa47-43e4-b7d2-29b4f592852d', '0a03bc3e-74f1-415c-8a15-7da6336985e0', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 18:36:01.884369+00');
INSERT INTO public.product_clicks VALUES ('ae0db305-e989-41b7-ae88-faa14cd8d6ea', '8d949db7-5014-46e5-8398-24d545ad995b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 18:37:34.098404+00');
INSERT INTO public.product_clicks VALUES ('64668857-d694-4e7f-9cb8-d711657ad140', '0a03bc3e-74f1-415c-8a15-7da6336985e0', NULL, '20dca71a-5ed2-48d8-96ed-508496092b62', '2026-03-24 18:37:34.361014+00');
INSERT INTO public.product_clicks VALUES ('d8320787-248e-42f2-8062-f6f97071965c', '0a03bc3e-74f1-415c-8a15-7da6336985e0', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 18:39:57.647807+00');
INSERT INTO public.product_clicks VALUES ('5c6fe05e-39b6-4e62-98c8-b78144069522', '3d3a7ef6-3197-44c8-8035-1627dbe6c690', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 18:40:46.5176+00');
INSERT INTO public.product_clicks VALUES ('665896db-aeff-446d-925b-43a9d6c517ae', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 18:41:39.863845+00');
INSERT INTO public.product_clicks VALUES ('64a57fa2-cc1e-41fd-8864-647dae4c8453', '3d3a7ef6-3197-44c8-8035-1627dbe6c690', NULL, '573f4bbc-e5e4-4765-bd1a-909b640bbb00', '2026-03-24 19:11:28.982016+00');
INSERT INTO public.product_clicks VALUES ('2037f364-bf9b-41bc-81f2-70e2df9a2711', 'f891a701-12b9-4a70-8677-5c2bee61e4f2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 19:45:07.962547+00');
INSERT INTO public.product_clicks VALUES ('c7b48a64-7afc-4599-b267-1786e60f4205', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 19:52:32.872575+00');
INSERT INTO public.product_clicks VALUES ('c2a6db0c-5eb9-41d5-a083-a3ae78ba2f22', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 19:53:50.26667+00');
INSERT INTO public.product_clicks VALUES ('bfa4edd6-c740-4502-8248-0fca597c83da', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 20:23:02.338901+00');
INSERT INTO public.product_clicks VALUES ('d5d2a18e-22c5-46d4-b589-c1ba5ff4944b', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 21:20:28.624336+00');
INSERT INTO public.product_clicks VALUES ('705d8117-5a1d-4fe2-be21-37418a2f6553', 'b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 21:46:01.779652+00');
INSERT INTO public.product_clicks VALUES ('0a821789-8b8d-485e-a363-5061a0261657', '0a03bc3e-74f1-415c-8a15-7da6336985e0', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 21:47:38.693325+00');
INSERT INTO public.product_clicks VALUES ('9046b06a-f3ac-4ccc-92d9-7357308082f7', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 22:05:59.188364+00');
INSERT INTO public.product_clicks VALUES ('f453531d-59b0-40ad-b5c4-048cd755a187', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 22:08:03.728463+00');
INSERT INTO public.product_clicks VALUES ('c287a310-806d-4f8f-88b1-b3374373e2ca', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 22:17:44.888709+00');
INSERT INTO public.product_clicks VALUES ('aac6f9ff-792b-437c-9b3f-66e4cc37cd02', 'f6b55013-88ec-4968-b251-94ba1535261e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 22:24:22.658148+00');
INSERT INTO public.product_clicks VALUES ('6196062c-4642-4814-8c9e-37d650312e87', 'b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 23:00:05.345771+00');
INSERT INTO public.product_clicks VALUES ('3eace97e-43cc-4abf-8b01-4a0b79c438bd', 'b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', NULL, '4809713a-5fbf-40d5-b72b-273c12837c68', '2026-03-24 23:31:26.747774+00');
INSERT INTO public.product_clicks VALUES ('3cd21fa5-d0e3-46e4-9353-e6b974c0e763', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-24 23:39:48.898672+00');
INSERT INTO public.product_clicks VALUES ('bd5a9cd4-eb29-4e0c-8f82-8bead24e8f51', 'bebbe3c7-58a6-4dd0-9e52-76d918dd0a41', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 00:43:51.471524+00');
INSERT INTO public.product_clicks VALUES ('1c9645fa-175a-4141-a0fc-52d9f6fdc292', '8d949db7-5014-46e5-8398-24d545ad995b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 00:45:23.506247+00');
INSERT INTO public.product_clicks VALUES ('a860a6f7-85bb-4ceb-a34c-fe06476b70b6', 'cbe4fef6-d959-449f-bb05-07ab8a84d026', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 01:01:45.961624+00');
INSERT INTO public.product_clicks VALUES ('c3c235b4-7acd-4e1f-a9ab-ad647d109d7c', '8d949db7-5014-46e5-8398-24d545ad995b', NULL, '1f45279c-be5b-4752-98e8-eaa7e22046c6', '2026-03-25 01:05:26.303301+00');
INSERT INTO public.product_clicks VALUES ('649370ba-1ac8-4d9f-aa03-e2f089f697f4', '41d2c588-4b18-42c9-affb-1aaab6a3cf92', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 11:55:08.871606+00');
INSERT INTO public.product_clicks VALUES ('d39abf24-5371-4403-80fb-b840ada78a33', '41d2c588-4b18-42c9-affb-1aaab6a3cf92', NULL, '55e9ca56-ceb4-42f4-ac0b-108ed435c1f6', '2026-03-25 11:57:18.557529+00');
INSERT INTO public.product_clicks VALUES ('e7579e20-6b59-4f0d-b90e-5051a896386d', 'fdcf0f14-b63d-42e0-ae79-ac2552282bf6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 13:02:26.687977+00');
INSERT INTO public.product_clicks VALUES ('5d35a4ac-24b3-4ad7-a91e-7dbf531491e3', 'fdcf0f14-b63d-42e0-ae79-ac2552282bf6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:02:37.424144+00');
INSERT INTO public.product_clicks VALUES ('14ae546a-39a1-4404-b24a-71a2802dcdea', 'fdcf0f14-b63d-42e0-ae79-ac2552282bf6', NULL, '55e9ca56-ceb4-42f4-ac0b-108ed435c1f6', '2026-03-25 14:04:04.333789+00');
INSERT INTO public.product_clicks VALUES ('527f9296-9ca4-40c1-b005-92ea9ec084a1', '0252b325-31e9-4f69-9952-8d821019dd14', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:49:14.664841+00');
INSERT INTO public.product_clicks VALUES ('a7226c09-547c-49ab-9ce1-995f109b3b7b', '4f9c76f9-9bb1-43ee-90ce-04cf0754f4ec', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:50:38.694731+00');
INSERT INTO public.product_clicks VALUES ('f34357c4-0533-4881-8877-5be32bd2d809', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:53:23.362655+00');
INSERT INTO public.product_clicks VALUES ('e58aa3b5-9610-45c2-8f24-cdc82fab15d6', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:57:38.360207+00');
INSERT INTO public.product_clicks VALUES ('b44dcd89-0298-480b-bf6d-060003350e24', '4f9c76f9-9bb1-43ee-90ce-04cf0754f4ec', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:59:20.503529+00');
INSERT INTO public.product_clicks VALUES ('63500e4e-47f4-480c-a169-49c8979a3478', '4f9c76f9-9bb1-43ee-90ce-04cf0754f4ec', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 14:59:43.85658+00');
INSERT INTO public.product_clicks VALUES ('785b1127-0bd6-4c91-b027-cf0377dd4d3f', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', NULL, '6bab4c4d-d610-47d4-a4c5-9a787d0121c7', '2026-03-25 15:04:07.517992+00');
INSERT INTO public.product_clicks VALUES ('6b9c0194-c4b0-4011-a718-792c7055598b', 'a2c9ad39-f849-490c-ae4f-7860daa642c6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 16:01:55.928274+00');
INSERT INTO public.product_clicks VALUES ('320b7e5f-fc50-4e0d-bd4c-774915ed742a', 'a2c9ad39-f849-490c-ae4f-7860daa642c6', NULL, '7145039b-a61f-430c-ac07-9f7b7230b05a', '2026-03-25 16:04:41.916282+00');
INSERT INTO public.product_clicks VALUES ('90036b55-cf40-4f2f-9176-e68028325e11', 'ce7815cb-25e7-4ad4-bec8-f12273641fe2', NULL, 'd208601d-ddd2-4505-bea4-c536fd894129', '2026-03-25 16:31:57.664579+00');
INSERT INTO public.product_clicks VALUES ('a0e79a5b-8496-4e96-9b5b-1817b933cd03', 'b889d94a-45fd-4443-9e42-f16afd61cc16', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 16:35:18.51531+00');
INSERT INTO public.product_clicks VALUES ('b418f191-248b-4ddb-b807-a76eb43988d0', '8ec39689-5943-49d4-a09c-2c15c00bf6c1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 16:35:49.092265+00');
INSERT INTO public.product_clicks VALUES ('b1549fff-26f7-4ff7-b0ab-553a72f01f59', '8ec39689-5943-49d4-a09c-2c15c00bf6c1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 17:01:38.936523+00');
INSERT INTO public.product_clicks VALUES ('b5d86b40-92b1-4344-876e-a59bcc29d502', '28d1f05e-c067-4725-a756-54448e085c8d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 17:05:32.465195+00');
INSERT INTO public.product_clicks VALUES ('c22d5610-2701-4d3b-9acc-c81d79291994', '28d1f05e-c067-4725-a756-54448e085c8d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 18:06:35.041857+00');
INSERT INTO public.product_clicks VALUES ('5e925bd9-f008-4d44-9a4e-22a763de1737', 'd2eb75e2-53bf-45dc-877b-e4c96132b43d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 19:21:59.240961+00');
INSERT INTO public.product_clicks VALUES ('46a2e2d8-d7d7-478d-95de-ad66db4db7ba', '8ec39689-5943-49d4-a09c-2c15c00bf6c1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 20:35:05.304788+00');
INSERT INTO public.product_clicks VALUES ('d67753c7-9a3f-443d-874a-ecd964d4470c', '20a59a16-2821-49e6-b140-d06d8664af0a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 20:40:50.249731+00');
INSERT INTO public.product_clicks VALUES ('77579466-2685-488c-b8cf-94fccf38b06c', '20a59a16-2821-49e6-b140-d06d8664af0a', NULL, '4809713a-5fbf-40d5-b72b-273c12837c68', '2026-03-25 20:51:16.722999+00');
INSERT INTO public.product_clicks VALUES ('ffbd2df7-89b6-4745-b334-cfa0708be1de', 'ad502528-58d6-4f78-9971-e5286a526546', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 22:38:06.324336+00');
INSERT INTO public.product_clicks VALUES ('a0f04f36-7634-409a-bea0-7c2fdae25614', '1177c463-9ddd-4d01-ba58-070d95037d8b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 22:40:11.76696+00');
INSERT INTO public.product_clicks VALUES ('e8c55059-62a5-47c4-9e44-7d688580a3ec', '2afe5d48-cdf8-4641-b2cf-d193ae4e93c7', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 22:42:30.775976+00');
INSERT INTO public.product_clicks VALUES ('18702f6f-956d-48d9-ac37-9eadc142b6bc', 'ae6ab7a4-165c-4c39-a209-f5f4cc516cf6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 22:43:27.299588+00');
INSERT INTO public.product_clicks VALUES ('aee650ce-0702-483c-a65b-a7b332e3664d', '3b7de2f5-749e-4f0a-b085-22dcd1c4f631', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 22:45:15.327404+00');
INSERT INTO public.product_clicks VALUES ('002eaaf8-63cb-4fd2-abd9-ddad865b60c3', 'df68154b-cc8e-4371-ad08-84b16061c6ed', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 22:47:46.503505+00');
INSERT INTO public.product_clicks VALUES ('c6361c38-a11c-4fb6-9a0a-8f254b392759', 'df68154b-cc8e-4371-ad08-84b16061c6ed', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 23:09:12.141762+00');
INSERT INTO public.product_clicks VALUES ('4acb7f47-9749-431e-b0b2-05966ec73860', 'ae6ab7a4-165c-4c39-a209-f5f4cc516cf6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 23:33:42.095929+00');
INSERT INTO public.product_clicks VALUES ('99bd3b10-f987-4974-a7d7-0e8d65c0898f', '2afe5d48-cdf8-4641-b2cf-d193ae4e93c7', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-25 23:49:19.583156+00');
INSERT INTO public.product_clicks VALUES ('cf79be5c-033d-4e98-ba2c-214e95824b63', '1177c463-9ddd-4d01-ba58-070d95037d8b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 00:03:45.235555+00');
INSERT INTO public.product_clicks VALUES ('4a62b266-a633-47b1-a7f1-f93849ee7d1f', 'ad502528-58d6-4f78-9971-e5286a526546', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 00:10:11.471992+00');
INSERT INTO public.product_clicks VALUES ('bd436441-01e8-4ea6-a200-7de72832f23c', 'ad502528-58d6-4f78-9971-e5286a526546', NULL, '7145039b-a61f-430c-ac07-9f7b7230b05a', '2026-03-26 00:21:48.180481+00');
INSERT INTO public.product_clicks VALUES ('2a18dff9-454b-44b6-9397-014113d15dbf', '48810ae3-ce2a-4f66-b962-116d4a94a95e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 00:44:28.988679+00');
INSERT INTO public.product_clicks VALUES ('e95cb73a-a48c-413c-8e0d-9d140882ecbe', '29ef0946-b25e-4f3d-9d90-8df9924e0a61', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 00:47:07.073881+00');
INSERT INTO public.product_clicks VALUES ('282b5517-1d43-4357-9025-7dccf4cf1799', '29ef0946-b25e-4f3d-9d90-8df9924e0a61', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 01:04:14.492824+00');
INSERT INTO public.product_clicks VALUES ('688d6f28-adb9-47f8-973b-8bb4324bfb7b', '29ef0946-b25e-4f3d-9d90-8df9924e0a61', NULL, '5e72c752-0dab-4beb-891e-6c0b3f902d2c', '2026-03-26 09:20:27.662619+00');
INSERT INTO public.product_clicks VALUES ('3080e5db-6c91-4f52-8135-802bb6606c4b', '48810ae3-ce2a-4f66-b962-116d4a94a95e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 12:10:57.763973+00');
INSERT INTO public.product_clicks VALUES ('dda1e116-e73f-4768-ab03-7b9e636f37d9', '37e717c9-51b3-41a2-9f71-fdaffc3f89f8', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 12:40:55.551796+00');
INSERT INTO public.product_clicks VALUES ('0717bb3d-fc55-489e-b782-75f591830238', '0ee21374-b263-4f18-8d3e-403dc2d7b954', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 12:42:07.520721+00');
INSERT INTO public.product_clicks VALUES ('58b299b9-825b-4ab2-898e-f3bc661f14ed', '37e74a05-5862-47b3-b01d-ebb0f81c4d9a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 14:36:35.424955+00');
INSERT INTO public.product_clicks VALUES ('a1e8ecc0-7a71-41c5-b9e9-20486cfde36e', '37e74a05-5862-47b3-b01d-ebb0f81c4d9a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 15:04:41.946643+00');
INSERT INTO public.product_clicks VALUES ('bd728853-5995-4b7d-8945-35c1f0a9689e', '3dbbbda2-0da3-4eb5-8452-928abf2a902d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 15:22:25.094501+00');
INSERT INTO public.product_clicks VALUES ('3f02d2b3-3f96-4226-820e-33ff00d93b36', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', NULL, '20f3cbda-65ea-42c4-b5d5-6b0caa45dd71', '2026-03-26 15:25:09.235071+00');
INSERT INTO public.product_clicks VALUES ('159d5943-8d3d-4ba4-95ce-12a26a9e08cf', '2b2649bf-137c-4614-b2ed-9e7879872492', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 15:57:43.253443+00');
INSERT INTO public.product_clicks VALUES ('0ec067a1-8c0a-41a3-9f56-6f9b335391cf', '8e10d48e-849f-46c2-9457-fb7369e28706', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 15:59:04.712769+00');
INSERT INTO public.product_clicks VALUES ('03f50757-d0d9-4d17-ab5c-8cb4dcb7939c', '2b2649bf-137c-4614-b2ed-9e7879872492', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 16:09:21.068028+00');
INSERT INTO public.product_clicks VALUES ('1571e4ab-a1f0-4f58-bf72-64e25151c60d', '3dbbbda2-0da3-4eb5-8452-928abf2a902d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 16:12:21.260192+00');
INSERT INTO public.product_clicks VALUES ('70df6850-5534-4cc5-b6b9-57b0f6315c0e', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', NULL, '20f3cbda-65ea-42c4-b5d5-6b0caa45dd71', '2026-03-26 16:22:46.684044+00');
INSERT INTO public.product_clicks VALUES ('0633bfd2-5b6b-4bd2-9b64-829c50b41756', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', NULL, '20f3cbda-65ea-42c4-b5d5-6b0caa45dd71', '2026-03-26 16:23:17.283043+00');
INSERT INTO public.product_clicks VALUES ('f0c242f6-8cde-4f7b-b9e3-499d97729239', 'c0fc85ce-20f0-4ca2-87fc-035992a27bd3', NULL, '20f3cbda-65ea-42c4-b5d5-6b0caa45dd71', '2026-03-26 16:30:31.344312+00');
INSERT INTO public.product_clicks VALUES ('7d8e5021-4e58-4c51-92c9-eb5f18d958ae', '3dbbbda2-0da3-4eb5-8452-928abf2a902d', NULL, 'e93624b8-f100-4f39-872f-423fd0c7f06c', '2026-03-26 17:03:32.56576+00');
INSERT INTO public.product_clicks VALUES ('7a1a6523-04cd-449d-b8f4-563d8cd9bb18', 'b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', NULL, '7407b72b-6dc1-499c-a810-eb736e6f84a3', '2026-03-26 19:33:44.593265+00');
INSERT INTO public.product_clicks VALUES ('2172c3d5-0517-4eab-8fe3-8aef1be88d92', 'b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', NULL, '7407b72b-6dc1-499c-a810-eb736e6f84a3', '2026-03-26 19:34:00.491538+00');
INSERT INTO public.product_clicks VALUES ('25f6e1b0-1cc4-407d-905f-5989d63a65d0', 'a9f0ec91-fb56-44f0-a187-1d8f83ef165a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', NULL, '2026-03-26 22:19:19.712124+00');
INSERT INTO public.product_clicks VALUES ('99fd9d8b-4a30-4975-93e1-c8fa080b2912', '0722cf53-1ac7-4c08-9cfb-8c677201c8ba', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-26 22:49:03.965067+00');
INSERT INTO public.product_clicks VALUES ('edeefef6-5963-4194-954a-e9e3b15b709c', '0722cf53-1ac7-4c08-9cfb-8c677201c8ba', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-26 22:59:39.741185+00');
INSERT INTO public.product_clicks VALUES ('6d862b2a-8093-47d9-aa34-b6a3461bdea8', 'a9f0ec91-fb56-44f0-a187-1d8f83ef165a', NULL, '3280ec93-46a3-4557-a9d8-1c811d7a1dca', '2026-03-26 23:00:40.030579+00');
INSERT INTO public.product_clicks VALUES ('cf5792c4-8ea1-44c6-85f2-d737a49de105', 'cb3b34a4-7715-4237-ad79-989dd3b08561', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-26 23:59:33.49594+00');
INSERT INTO public.product_clicks VALUES ('f12d763e-e77e-475f-a784-038c04fb2860', 'cb3b34a4-7715-4237-ad79-989dd3b08561', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', NULL, '2026-03-27 00:02:39.762115+00');


--
-- TOC entry 4826 (class 0 OID 22254)
-- Dependencies: 399
-- Data for Name: product_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4828 (class 0 OID 22349)
-- Dependencies: 401
-- Data for Name: product_trust_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4814 (class 0 OID 17530)
-- Dependencies: 386
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES ('0a03bc3e-74f1-415c-8a15-7da6336985e0', '20 Placas Adesivas Painel Madeira Ripada Montável Mdf 45x11', 'Painel Ripado MDF - Kit Peças Autocolantes | Revestimento Decorativo de Alto Padrão 

Transforme o visual dos seus ambientes com o Painel Ripado de MDF, uma solução moderna e prática para quem busca sofisticação e estilo! Este kit completo de 20 peças é ideal para criar um acabamento impecável em paredes, cabeceiras de cama, móveis, e muito mais.

Principais Benefícios:
Design Versátil e Elegante: A textura ripada proporciona um visual contemporâneo e aconchegante, sendo perfeita para salas, quartos, escritórios ou lojas.
Fácil Instalação: As placas de MDF podem ser facilmente instaladas com fita dupla face, adesivo de contato ou pregos, de acordo com a necessidade e superfície.
Material de Alta Qualidade: Fabricadas em MDF resistente e durável, com acabamento que garante a uniformidade e durabilidade.

Kit Completo:
Com as peças, você tem a liberdade de criar diferentes composições e cobrir áreas de variados tamanhos, adaptando o design à sua preferência.
Personalização e Praticidade: Pode ser pintado, envernizado ou mantido no acabamento original, atendendo a diversos estilos de decoração.

Especificações Técnicas:
Material: MDF de alta qualidade
Quantidade:
***************** Kit com 20 peças - Equivale a 1 m2 *****************

Garantia do vendedor: 7 dias', 40.54, 69, 41, 'https://http2.mlstatic.com/D_NQ_NP_2X_791289-MLB96316102981_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_791289-MLB96316102981_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_991387-MLB95230742326_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_740025-MLB95667862131_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_807936-MLB95668178209_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_928191-MLB95667921329_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_859446-MLB95230762144_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_840056-MLB95668148247_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_709179-MLB95230752588_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp,https://http2.mlstatic.com/D_NQ_NP_2X_772539-MLB95667901615_102025-F-20-placas-adesivas-painel-madeira-ripada-montavel-mdf-45x11.webp}', 'Novo', 'SOFT DECOR', 'https://meli.la/2AfzVdk', 4.8, 0, 4, true, NULL, '2026-03-24 18:34:50.465069+00', '2026-03-25 16:45:28.344575+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 41.2, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 20, 10000, '[{"name": "Cor", "value": "Disponível"}]', 99, '{"cashback": "", "meli_plus": false, "variations": [{"group": "Cor", "options": ["Castanho", "Freijo", "Preto"]}], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('29ef0946-b25e-4f3d-9d90-8df9924e0a61', 'Varal De Roupas Vertical 3 Andares De Chão Dobrável Portátil - VARI TUDO', 'Varal de roupas vertical com 3 andares, dobrável e portátil para fácil armazenamento e transporte
Design de chão com estrutura vermelha, oferecendo praticidade e estilo para sua área de lavanderia
Ideal para secar roupas em espaços inters ou exters, com montagem simples chão', 68.7, 104.99, NULL, 'https://m.media-amazon.com/images/I/51lzgdQRCuL._AC_SL1191_.jpg', '{https://m.media-amazon.com/images/I/51lzgdQRCuL._AC_SL1191_.jpg,https://m.media-amazon.com/images/I/717Xp7VTMqL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/61-3tRZWMkL._AC_SL1199_.jpg,https://m.media-amazon.com/images/I/613SJMY9GqL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61VFORPMvZL._AC_SL1200_.jpg}', NULL, 'VARI TUDO', 'https://amzn.to/4sJVPta', 5, 0, 3, true, NULL, '2026-03-26 00:23:54.825388+00', '2026-03-26 09:20:27.662619+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 34.6, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', 'B0CN3WK5DZ', 8, 1000, '[{"name": "Material", "value": "Aço inoxidável"}, {"name": "Marca", "value": "VARI TUDO"}, {"name": "Cor", "value": "vermelho"}, {"name": "Adequação do controle por rádio", "value": "Roupas"}, {"name": "Tipo de montagem", "value": "Montagem no chão"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sábado, 28 de Março Sábado, 28 de Março"}');
INSERT INTO public.products VALUES ('f6b55013-88ec-4968-b251-94ba1535261e', 'EQUALIV - Body Protein Neutro em Pó - Rico em Colágeno e Aminoácidos Essenciais para Desenvolvimento e Recuperação Muscular - Sem Glúten, Sem Lactose, Zero Açúcar - Sem Sabor, Lata (450g)', 'Body Protein (600g), Neutro (450g), Equaliv', 234.5, 222.9, 11, 'https://m.media-amazon.com/images/I/716WP3+z5uL._AC_SL1500_.jpg', '{https://m.media-amazon.com/images/I/716WP3+z5uL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/81B85BmFpbL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71JsGi+J2TL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/81Rof8ipAIL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/81-P8fweT9L._AC_SL1500_.jpg}', NULL, 'Equaliv', 'https://amzn.to/3NIMRNN', 5, 0, 2, true, NULL, '2026-03-24 05:14:38.960866+00', '2026-03-26 12:12:37.187431+00', '22e97655-8957-45f8-9512-3fb1d2b14b9f', '313ff752-18c8-41fe-a46e-7e91796ea889', '31640105-56f9-43ab-8204-465c8717d731', NULL, -5.2, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'af115fa7-66eb-4445-a35b-232023d163f6', 'B07LCRQL1W', 13, 800, '[{"name": "Marca", "value": "Equaliv"}, {"name": "Sabor", "value": "Sem sabor"}, {"name": "Peso do produto", "value": "398 Gramas"}, {"name": "Tipo de material livre", "value": "Sem adoçantes artificiais, Sem açúcar"}, {"name": "Tipo de dieta", "value": "Sem glúten"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Amanhã, 25 de Março. Se pedir dentro de 4 hrs 45 mins. Ver detalhes Amanhã, 25 de Março4 hrs 45 mins"}');
INSERT INTO public.products VALUES ('cdeffb1e-5dab-413a-a8cf-31381f3ba852', 'Espelho Redondo 60cm C/ Led Para Parede Quarto Banheiro Sala', 'Espelho Rendondo 60cm com LED

O espelho Rendondo 60cm com LED da Rei dos Vidros é a escolha ideal para quem busca não apenas funcionalidade, mas também um toque de sofisticação e estilo em sua decoração. Com um design moderno e elegante, este espelho não só reflete sua imagem de maneira impecável, mas também complementa qualquer ambiente, seja em casa ou em estabelecimentos comerciais.

Características Principais:

Design Moderno e Sofisticado: O espelho possui um formato orgânico que traz um ar contemporâneo e diferenciado ao espaço, tornando-o uma peça central atraente em qualquer ambiente.

Estrutura Reforçada: Fabricado com vidro de alta qualidade de 3 mm de espessura, garantindo resistência e durabilidade. A borda é feita de materiais que evitam lascas e quebras, proporcionando segurança.

Iluminação LED Personalizada: Disponível com duas opções de iluminação:

LED Frio: Ideal para ambientes que exigem uma iluminação mais clara e energizante, perfeita para maquiagem e cuidados pessoais.

LED Quente: Proporciona uma luz suave e acolhedora, ideal para criar uma atmosfera relaxante em banheiros ou salas.

Tecnologia de Corte CNC: O corte preciso permite um acabamento impecável, garantindo que as bordas sejam lisas e seguras, além de contribuir para a estética geral do produto.

Embalagem Segura: Cada espelho é cuidadosamente embalado para garantir que chegue em perfeitas condições, independentemente da distância de transporte, assegurando a proteção contra impactos.

Especificações Técnicas

Marca: Rei dos Vidros  
Modelo: Rendondo – Moldura em vidro lapidado  
Espelho: Guardian  
Iluminação: LED quente e frio, com fácil troca de modo  
Estrutura: Vidro de 3 mm, E.V.A e LED integrado  
Formato: Orgânico  
Dimensões: 60cm (altura) x 60cm (largura)

Garantia

100% de garantia contra defeitos de fabricação em 90 dias, cobrindo:
Manchas no espelho
Defeitos no vidro
Distorção de imagem

Perguntas Frequentes

A entrega é segura? E se o espelho chegar quebrado?Sim! Garantimos a entrega em perfeitas condições. Caso o espelho chegue danificado, enviamos uma nova peça sem custo adicional.

Qual a espessura do espelho?
O espelho possui 3 mm de espessura, o que proporciona segurança e durabilidade.

Do que é feita a estrutura do espelho?
A estrutura é composta por vidro de 3 mm e LED, proporcionando uma combinação ideal de beleza e funcionalidade.

Posso fixar o espelho na parede?
Sim! O espelho vem com um suporte para instalação na parede.

Quais são as dimensões do espelho?
O espelho tem dimensões de 60cm de altura x 60cm de largura, ideal para criar um impacto visual em qualquer espaço.

Como posso instalar o espelho na parede?
Recomendamos a ajuda de um profissional. Para a instalação, você precisará de:
Furadeira
Broca 08mm
Bucha 08mm
Parafuso 08mm', 78.9, 98.9, 20, 'https://http2.mlstatic.com/D_NQ_NP_2X_600271-MLB95836200945_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_600271-MLB95836200945_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp,https://http2.mlstatic.com/D_NQ_NP_2X_956621-MLB95836646961_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp,https://http2.mlstatic.com/D_NQ_NP_2X_955416-MLB95397511852_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp,https://http2.mlstatic.com/D_NQ_NP_2X_703271-MLB95836299503_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp,https://http2.mlstatic.com/D_NQ_NP_2X_659901-MLB95837158551_102025-F-espelho-redondo-60cm-c-led-para-parede-quarto-banheiro-sala.webp}', 'Novo', 'Loja oficialRei Dos Vidros', 'https://meli.la/2uBYwMh', 4.8, 0, 0, true, NULL, '2026-03-26 22:38:42.485224+00', '2026-03-26 22:40:24.197068+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 20.2, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 18, 1000, '[{"name": "Cor Da Moldura", "value": "Disponível"}]', 99, '{"cashback": "", "meli_plus": false, "variations": [{"group": "Cor Da Moldura", "options": ["Redondo 60cm Led Frio", "Redondo 60cm Led Quente"]}], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('cb3b34a4-7715-4237-ad79-989dd3b08561', 'Beta Alanina 100% Pura Atlhetica Nutrition - 200g', 'Beta Alanina 100% Pura - 200g Natural

Eleve seu desempenho com nossa Beta Alanina 100% Pura! Cada porção oferece 2g de beta alanina de alta qualidade, um aminoácido essencial que ajuda a aumentar a resistência muscular e retardar a fadiga. Ideal para atletas e entusiastas do fitness, este suplemento é perfeito para intensificar seus treinos e melhorar a recuperação.

Características:

Pureza garantida: 100% beta alanina, sem aditivos ou conservantes.
Melhora da performance: Aumenta os níveis de carnosina nos músculos, promovendo maior resistência e performance em exercícios de alta intensidade.
Natural e eficaz: Fórmula limpa que se adapta a diferentes dietas.
Modo de uso: Misture uma porção (2g) em água ou sua bebida favorita antes do treino.

Benefícios:

Aumenta a resistência muscular
Retarda a fadiga
Promove a recuperação muscular
Transforme seus treinos com a Beta Alanina 100% Pura e sinta a diferença na sua performance!

Aviso legal
• Idade mínima recomendada: 19 anos.
• Consumir junto com alimentos para facilitar sua assimilação.
• Este produto é um suplemento dietético, não um medicamento. Suplementa dietas insuficientes. Consulte o seu médico e/ou farmacêutico.', 43.7, 59, 26, 'https://http2.mlstatic.com/D_NQ_NP_2X_900699-MLA99607922852_122025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_900699-MLA99607922852_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_621246-MLA80351052077_102024-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_749446-MLA80095976386_102024-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_625009-MLA80096035856_102024-F.webp}', 'Novo', 'Loja oficialFit House Loja oficialAtlhetica Nutrition Vendido porGRUPOALFAS', 'https://www.mercadolivre.com.br/beta-alanina-100-pura-atlhetica-nutrition-200g/p/MLB19538713', 4.8, 0, 2, true, NULL, '2026-03-26 23:26:53.688025+00', '2026-03-27 00:02:39.762115+00', '382b00de-6d79-4e7b-9e18-673c1333a299', '8d9a375f-9fc1-4958-bcf6-5fb8c52e087e', '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 25.9, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'af115fa7-66eb-4445-a35b-232023d163f6', NULL, NULL, 10000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('cbe4fef6-d959-449f-bb05-07ab8a84d026', 'KIT 12 Peças de Utensílios Para Cozinha em Silicone e Bambu', '<p>Apresentamos o nosso Kit de Utensílios para Cozinha em Silicone com Cabo de Madeira, uma combinação elegante de funcionalidade e estilo para transformar a sua experiência culinária. Este conjunto exclusivo oferece uma seleção cuidadosa de utensílios essenciais, projetados para atender às demandas da cozinha moderna.</p><p><br></p><p>Cada utensílio é cuidadosamente elaborado com material de silicone de alta qualidade, que não apenas garante resistência ao calor, mas também preserva a integridade de suas panelas e utensílios de cozinha. O silicone é antiaderente, facilitando o manuseio dos alimentos e proporcionando uma limpeza rápida e eficiente.</p><p><br></p><p>Os cabos de madeira proporcionam uma aderência confortável e firme, além de adicionar um toque de elegância ao seu espaço culinário. A madeira utilizada é de alta qualidade, durável e sustentável, conferindo um visual sofisticado aos utensílios.</p><p><br></p><p>O conjunto inclui uma variedade de utensílios indispensáveis, como colher de silicone, espátula, concha e pegador, atendendo a diversas necessidades na cozinha. Seja você um chef experiente ou alguém que está começando a se aventurar na culinária, este Kit de Utensílios em Silicone com Cabo de Madeira é a escolha perfeita para tornar cada preparo mais eficiente e agradável.</p><p><br></p><p>Além de sua funcionalidade excepcional, este conjunto se destaca como uma adição elegante à sua cozinha, combinando design moderno, durabilidade e praticidade. Eleve o seu espaço culinário com o Kit de Utensílios para Cozinha em Silicone com Cabo de Madeira e descubra como a qualidade dos utensílios pode fazer toda a diferença em suas criações gastronômicas.</p><p><br></p><p>Itens inclusos:</p><p><br></p><p>1 Escumadeira</p><p>1 Colher de alinhavar</p><p>1 Colher de Arroz</p><p>1 Colher de Skimmer</p><p>1 Turner com fenda quadrada</p><p>1 Concha de sopa</p><p>1 Colher de espaguete</p><p>1 Espátula de carne</p><p>1 Fuê</p><p>1 Pinça</p><p>1 Pincel</p><p>1 Balde para armazenamento</p><p><br></p><p>Especificações técnicas:</p><p><br></p><p>Material:</p><p>Silicone resistente 480oC de calor sustentado e grau alimentício </p><p><br></p><p>Disponível envio aleatório</p>', 29, 99, 71, 'https://cf.shopee.com.br/file/sg-11134201-7rdx1-m1egwx31u1x61f', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.6826810539320676.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.17922385780395.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7230824503314834.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4908170594646226.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9122669907373486.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.11666030154676355.webp}', NULL, 'Shopee', 'https://s.shopee.com.br/LilE9K8GI', 4.7, 0, 1, true, NULL, '2026-03-25 00:04:24.521111+00', '2026-03-25 01:01:45.961624+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 70.7, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 11, 9303, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('b889d94a-45fd-4443-9e42-f16afd61cc16', 'Barbour''s Beauty Very Sexy Body Splash + Perfume Capilar', 'O Kit Perfume de Cabelo e Body Splash Desodorante Colônia Very Sexy combina o poder de uma fragrância sensual e envolvente, com notas quentes e atraentes, para uma experiência luxuosa. 

O Body Splash proporciona frescor e perfume duradouro para a pele, enquanto o Perfume de Cabelo traz a mesma fragrância com proteção térmica e ação antiodor para os fios, garantindo que você se sinta irresistível durante todo o dia.', 97.41, NULL, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_836941-MLA103260970909_122025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_836941-MLA103260970909_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_695051-MLA102748149386_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_800922-MLA102748248780_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_678609-MLA106827433149_022026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_612583-MLA106827433153_022026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_793784-MLA106203116800_022026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_617242-MLA106828047045_022026-F.webp}', 'Frete Grátis', 'Mercado Livre', 'https://meli.la/2JnuAA3', 4.8, 0, 1, true, NULL, '2026-03-25 16:34:56.862129+00', '2026-03-26 12:12:54.441257+00', 'dcb39609-04ac-4acc-b4d3-a0f02c6917b8', NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '95a00be7-7f36-4590-a2d9-f78cd0a12689', NULL, 20, 100, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('9016cde9-ce2b-4eef-9b4a-dfd1bd88d5aa', 'Ovo de Páscoa Ao Leite Chocolate Premium Garoto 250g Ovos de Páscoa Barato Envio Rápido Premium', '<p>---------------- Envio Imediato -----------------------</p><p><br></p><p>====== ATENÇÃO TODOS OS OVOS SÃO ENVIADOS COM CAIXA DE ISOPOR PARA NAO QUEBRAR NO TRANSPORTE =========</p><p><br></p><p>Ovo de Páscoa 250g chocolate de alta qualidade, é delicioso! </p><p><br></p><p>Chocolate de Qualidade: Feito com os melhores ingredientes, nosso chocolate é rico, cremoso e satisfatório, proporcionando uma experiência gastronômica inesquecível.</p><p><br></p><p>Presente Perfeito: Não apenas um mimo para si mesmo, mas também uma ótima opção para presentear. Combinando o sabor delicioso do chocolate com a emoção de um brinquedo divertido, nosso ovo de Páscoa é o presente ideal para compartilhar a alegria desta temporada especial.</p><p><br></p><p>Celebre a Páscoa de uma maneira única e emocionante com nosso Ovo de Páscoa com Brinquedo. Disponível por tempo limitado, antecipe suas compras e nao deixe para ultima hora, então não perca a chance de tornar esta Páscoa verdadeiramente memorável!</p><p><br></p><p>Enviamos em caixa para nao danificar e pedimos apenas que antes de abri-lo, colocar na geladeira por cerca de 15 minutos pois devido a temperatura das agencias pode aquecer o chocolate.</p><p><br></p><p>Garantia do vendedor: 7 dias</p><p><br></p><p>Garantia do vendedor: 7 dias</p>', 19.99, NULL, NULL, 'https://cf.shopee.com.br/file/sg-11134201-8261e-mkiyummn7v2c20', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7345162422952085.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.1589116043710067.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2726485529732041.webp}', NULL, 'D&G PROMOÇOES', 'https://s.shopee.com.br/7VBuxEXbHN', 3.9, 0, 0, true, NULL, '2026-03-24 11:54:41.610956+00', '2026-03-24 22:22:30.19194+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'a0822333-17b8-40d1-acbb-c0401eb81fcf', NULL, 3, 404, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('fdcf0f14-b63d-42e0-ae79-ac2552282bf6', 'ROMANTIC CROWN Copo Térmico Inox Portátil 1200ml/600ml/1.2L Garrafa Térmica Inoxidável com Tampa e Canudo', '<p>🔥Manter quente : 12H   ❄️Manter gelo : 24H</p><p>- Peso : 1200ml/550g | 600ml/360g</p><p>- Cor : Creme/Rosa Claro/Preto/Vermelho/Rosa escuro</p><p>- Estilo : Resistente a vazamentos, isolada a vácuo</p><p>- Recomendado : Água/suco/chá gelado/Bebida quente</p><p>- Atenção: o copo de 600 ml não tem asa; apenas o copo de 1200 ml tem asa</p><p><br></p><p>📦 Conteúdo da Embalagem: </p><p>1 x Copo de 1200ml/600ml</p><p>1 x Tampa do Copo</p><p>1 x Canudo de Aço Inoxidável (Atualização do Produto)</p><p>1 x Capinha de Silicone para Canudo (Atualização do Produto)</p><p>1 x Escova para Canudo (Atualização do Produto)</p><p><br></p><p>🏆TAMANHO EXTRA GRANDE: </p><p>Romantic Crown Copo Térmico tem capacidade de até 40 onças, sendo perfeito para quem precisa beber bastante de suas bebidas. Se você prefere um copo de café gelado, um refrescante chá gelado ou uma sopa quente e substancial, refrigerantes, água ou leite, este copo é a sua escolha ideal.</p><p><br></p><p>🗑️Design Ecológico e Higiênico:</p><p>Romantic Crown Copo Térmico é projetado com foco na durabilidade, evitando o uso de garrafas plásticas descartáveis e canudos. O copo utiliza canudos de aço inoxidável e capas protetoras de silicone, com a tampa apresentando um design de rosca dupla. A abertura do canudo é projetada para evitar respingos, e o selo é utilizado para fixar o canudo reutilizável, enquanto a abertura para bebida e o topo da tampa aumentam a proteção contra vazamentos.</p><p><br></p><p>🥇Aço inoxidável a vácuo duplo:</p><p>Romantic Crown Copo Térmico é produzido em 304 aço inoxidável com uma técnica de parede dupla e vácuo entre as paredes, conservando sua bebida por mais tempo. Mantém as bebidas frias por até 24 horas e quentes por até 12 horas. O aço 18/8 evita que os copos ou canecas fiquem com cheiro e gosto de bebidas e alimentos.</p><p><br></p><p>💧Fácil de Limpar: </p><p>O copo vem com “canudo de aço inoxidável” e “capa protetora de silicone”, podendo ser limpo com “uma escova de limpeza”. Reduza o tempo se curvando sobre a pia e tenha mais tempo para fazer o que você ama. Limpar o copo e a tampa não poderia ser mais simples, basta colocá-los na lava-louças. Ao contrário das garrafas plásticas que retêm manchas e odores, este copo metálico parecerá novo.</p><p><br></p><p>🎁Presente Perfeito:</p><p>Romantic Crown Copo Térmico é o presente perfeito para bons amigos, familiares, amantes, colegas, vizinhos e parceiros de negócios, especialmente para aqueles que precisam manter uma boa hidratação ou que têm dificuldade em se reabastecer. Seja no Dia dos Namorados, Dia das Mães, Dia dos Pais, Natal, Ação de Graças, Páscoa ou aniversários, este copo é uma escolha excelente, permitindo que você expresse carinho e amor em datas especiais.</p><p><br></p><p>(Garantia do vendedor: 30 dias)</p>', 39.98, 60, 33, 'https://cf.shopee.com.br/file/br-11134207-81ztc-mj2ddyi3zfgi6a', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7680479737627378.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9069651944189062.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7406187774776257.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.3745469439165241.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.06662447064288157.webp}', NULL, 'Romantic.Crown.03', 'https://s.shopee.com.br/1gE9fpfXee', 4.9, 0, 3, true, NULL, '2026-03-25 12:58:49.303185+00', '2026-03-25 14:04:04.333789+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 33.4, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '863befde-b087-4dee-bc39-36e519b18a48', NULL, 11, 10635, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('3d3a7ef6-3197-44c8-8035-1627dbe6c690', '2 Caixas De 37g, Bombons De Chocolate Suiço, Lindt Lindor', 'Bombons de chocolate suiço Lindt Lindor, embalados em caixas tradicionais, ideais para degustação.

Sobre o chocolate Lindor:
- Recheio cremoso que se dissolve na boca;
- Chocolate suiço ao leite com mais de 175 anos de tradição;
- Apreciado em mais de 80 países;
- Embalagem ideal para presentear.

Conteúdo do kit:
- 2 caixas de 37g de bombons de chocolate ao leite.

Sabores do kit:
- 2x Lindor Milk;
- Bombom vermelho Lindor, feito de chocolate ao leite com recheio cremoso que se dissolve suavemente.

Fabricação: Suíça.', 51.92, 64, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_882912-MLA99372602906_112025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_882912-MLA99372602906_112025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_988078-MLU75115235545_032024-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_911209-MLU74974698540_032024-F.webp}', 'Novo', 'Loja oficialCafezale Loja oficialCafezale', 'https://meli.la/1aonRLQ', 4.6, 0, 3, true, NULL, '2026-03-24 12:45:34.978946+00', '2026-03-25 16:46:53.652251+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 18.9, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'a0822333-17b8-40d1-acbb-c0401eb81fcf', NULL, 10, 100, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('0722cf53-1ac7-4c08-9cfb-8c677201c8ba', 'Smartphone Poco X7 5G 512GB / 256GB - 12GB / 8GB RAM - Tela 6.67 - Versão GLOBAL - LANÇAMENTO 2025', NULL, 1577.6, 1779.99, 11, 'https://cf.shopee.com.br/file/br-11134207-7r98o-m6ssruqg9dtc5a', '{}', NULL, 'MOCI STORE', 'https://s.shopee.com.br/7VByrR3aca', 4.9, 0, 2, true, NULL, '2026-03-26 22:41:54.003318+00', '2026-03-26 22:59:39.741185+00', '562df9b8-8a3a-419d-bce3-152b980c7927', '02de7dec-e4f3-4653-9287-4c155ead3e0a', '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 11.4, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', NULL, 3, 410, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('60467af5-058e-4e64-a766-f8d0889d0acb', 'Smart Tv Philips 55 4k 55pug7300 Comando De Voz Bluetooth', 'Experimente a revolução da visualização com a Smart TV Philips 55" 4K 55PUG7300, uma verdadeira obra-prima da tecnologia. 

Com uma resolução 4K UHD e uma impressionante relação de contraste de 1:200000, cada cena ganhará vida com detalhes vibrantes e cores ricas. Seu sistema DLED proporciona um brilho de 250 cd/m2, garantindo uma experiência visual excepcional em qualquer ambiente.

Equipada com um processador de 4 núcleos e uma taxa de atualização de 60 Hz, essa TV oferece tempos de resposta rápidos e uma navegação fluida por meio do sistema operativo Titan OS. Conta com suporte para assistentes virtuais como Alexa e Apple Home, possibilitando um controle por voz simplificado. Além disso, o armazenamento de 8 GB permite que você baixe seus aplicativos favoritos, como Netflix, YouTube e HBO, diretamente na TV.

Com conectividade Bluetooth e Wi-Fi, a 55PUG7300 oferece fácil acesso a uma variedade de opções de entretenimento e multi-conexões com dispositivos. Seus recursos de áudio incluem Dolby Atmos e DTS-X, proporcionando uma experiência sonora imersiva que complementa a visualização. 

Com um design moderno e elegante, essa TV é uma adição perfeita para qualquer sala de estar.', 2299, 3449, 40, 'https://http2.mlstatic.com/D_NQ_NP_2X_651129-MLA92926667074_092025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_651129-MLA92926667074_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_677111-MLA92926072818_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_723947-MLA92926687014_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_757442-MLA92926072822_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_930104-MLA92926825274_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_903954-MLA92926290956_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_798987-MLA92926072828_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_987009-MLA92926825224_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_908101-MLA92926072832_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_834120-MLA93340279261_092025-F.webp}', 'Novo', 'Loja oficial Eshop', 'https://meli.la/32mjJ1E', 4.7, 0, 6, true, NULL, '2026-03-24 01:44:48.951482+00', '2026-03-26 12:13:04.890988+00', '9336d222-8a26-427b-9e2d-d9e75457a042', '403c5506-f467-412c-a92c-e48972857671', '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 33.3, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', NULL, 5, 1000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('4fc7c7b9-083e-453c-a19e-8bba1652d258', 'Creme Merengue para o Corpo Tododia Morango e Baunilha Dourada', '<p>Creme com textura deliciosa e benefícios 6 em 1:</p><p><strong>• hidratação intensa</strong>, com tecnologia prebiótica;</p><p><strong>• mais firmeza</strong>&nbsp;para sua pele, com ativo que estimula a produção de colágeno;</p><p><strong>•</strong>&nbsp;melhora a textura da pele, deixando a&nbsp;<strong>macia como veludo;</strong></p><p><strong>•</strong>&nbsp;perfumação intensa e prolongada, com&nbsp;<strong>duas vezes mais fragrância;</strong></p><p><strong>•</strong>&nbsp;pele protegida de danos externos;</p><p><strong>• toque sequinho</strong>, não deixa a pele pegajosa e é fácil de espalhar.</p>', 75.9, 84.9, 11, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1774291286536-wqh8aice5m.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.3951931865428787.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.10322008556880014.jpg}', 'Lançamento', 'Natura', 'https://www.minhaloja.natura.com/p/creme-merengue-para-o-corpo-tododia-morango-e-baunilha-dourada-250-g/NATBRA-205941?marca=natura&redirect=%2Fp%2Fcreme-merengue-para-o-corpo-tododia-morango-e-baunilha-dourada-250-g%2FNATBRA-205941&origin=menu&consultoria=ofertashop', 0, 0, 0, true, NULL, '2026-03-23 18:44:06.5212+00', '2026-03-24 04:09:44.085439+00', 'abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', '5cbe6e44-319e-40d3-8f78-e32d09234a7a', 'f729f5cd-3b0a-4ded-88d8-a5b578f0fb0b', NULL, 10.6, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '95a00be7-7f36-4590-a2d9-f78cd0a12689', NULL, NULL, 0, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('37e717c9-51b3-41a2-9f71-fdaffc3f89f8', 'Caixa Cooler Térmico Pequeno 8 Litros Ate 12 Latas Termolar Cor Cinza', 'Caixa Térmica SUV 8 Litros Termolar

A SUV 8 L é a caixa térmica da Termolar que une design funcional e inovação em um formato compacto. 
Possui capacidade para até 12 latas de 350 mL, 9 garrafas de 330 mL ou 8 latões de 473 mL. 
Sua tampa reversível vira uma mesinha com porta-copos e porta-celular, e o estojo para utensílios traz ainda mais praticidade. 
Com conservação térmica diferenciada, mantém até 9 horas de frio sem uso de gelo para alimentos e até 20 horas de frio com uso de gelo para bebidas. 
A tecnologia AirFlow permite a circulação de ar pela base sem contato com o piso, garantindo eficiência térmica. 
Alça retrátil com trava de segurança facilita o transporte e proporciona mais estabilidade, tornando a SUV 8 Litros a companheira perfeita para passeios e aventuras do dia a dia.

Informações Técnicas:
Marca: Termolar
Acabamento: Lisa
Capacidade: 8 Litros
Conservação Térmica com Gelo: 20 Horas Aproximada
Conservação Térmica sem Gelo: 8 Horas Aproximada
Isolamento Térmico: Poliestireno Expandido (EPS)
Livre de BPA: Sim
Material Externo: Plástico
Possui Porta-Copos: Sim
Possui Porta-Celular: Sim

Dimensões Aproximadas:
Caixa com a TAMPA aberta: 35cm
Largura: 18cm
Comprimento: 31cm
Altura: 26cm
Profundidade: 21cm', 52, 66, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_781312-MLA99461750520_112025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_781312-MLA99461750520_112025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_615408-MLA84759569056_052025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_943373-MLA84757914222_052025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_896598-MLA93475735901_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_911383-MLA93060245782_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_800147-MLA93475607901_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_687765-MLA93060147702_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_838955-MLA93475441307_092025-F.webp}', 'Novo', 'Mercado Livre', 'https://meli.la/1j8q6tr', 4.9, 0, 1, true, NULL, '2026-03-26 12:36:04.222613+00', '2026-03-26 12:40:55.551796+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 21.2, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '8b573b54-b283-4f4b-ada1-253efa523053', NULL, 31, 1000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('20a59a16-2821-49e6-b140-d06d8664af0a', 'Kit Lavitan Hair Cabelos Unhas 180 Cápsulas', 'Kit contém 180 cápsulas para cuidados com cabelos e unhas
Suplemento da marca Cimed para saúde capilar e das unhas', 47.99, NULL, NULL, 'https://m.media-amazon.com/images/I/6162cW7605L._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/6162cW7605L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61YPRyvXMzL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61Kk7LafX7L._AC_SL1280_.jpg}', NULL, 'Cimed', 'https://amzn.to/3PIrf4C', 5, 0, 2, true, NULL, '2026-03-25 16:56:49.513583+00', '2026-03-25 20:51:16.722999+00', '232eb3f8-6e67-45c6-8a48-d56e83a85391', 'c253d78d-6b05-46ae-ba05-c36fddf50a17', '31640105-56f9-43ab-8204-465c8717d731', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'af115fa7-66eb-4445-a35b-232023d163f6', 'B08PDFJVBQ', 13, 400, '[{"name": "Marca", "value": "Cimed"}, {"name": "Forma do produto", "value": "Cápsula"}, {"name": "Tipo de suplemento primário", "value": "Biotina"}, {"name": "Tipo de dieta", "value": "À base de plantas"}, {"name": "Sabor", "value": "Sem sabor"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Amanhã, 26 de Março. Se pedir dentro de 3 mins. Ver detalhes Amanhã, 26 de MarçoSe pedir dentro de 3 minsSe pedir dentro de 3 mins3 mins"}');
INSERT INTO public.products VALUES ('6e60439d-bb86-4de1-a6a3-a450669e31da', 'Aparelho De Medir Pressão Arterial De Braço Visor Digital Inteligante', '<p>Características:</p><p>1. Display LED: Nosso monitor de pressão arterial é equipado com um grande display LED, que proporciona uma ótima experiência de visualização, tornando as leituras mais claras e os usuários podem ver os resultados mais rápidos. Limpar grandes fontes e uma tela retroiluminada de alta definição proporcionam leituras claras à noite para uma experiência avançada de medição.</p><p>2. Maior precisão: O monitor automático de pressão arterial tem tecnologia de medição avançada para fornecer as leituras mais precisas. Conveniente para rastrear sua saúde diária.</p><p>3. Operação de um botão: A máquina de pressão arterial é totalmente automática, você só precisa pressionar o botão "Start" para medir sua pressão arterial e frequência cardíaca. Todo o processo leva apenas meio minuto. O design amigável do usuário pode ser adequado para a maioria das pessoas, mesmo os usuários sêniores podem operar se forem sem esforço por si mesmos, sem necessidade da orientação dos outros.</p><p>4. Detecção de arritmia: monitores de pressão arterial são sensíveis o suficiente para rastrear mau funcionamento do batimento cardíaco que você pode não ter notado. Isso disse, medindo estresse, você também pode verificar sua frequência cardíaca.</p><p>5. Grande capacidade de armazenamento: 99 medidas permitem que você saiba sua pressão arterial a qualquer momento. Compare as leituras dos últimos dias para que você possa dar passos para evitar surpresas desagradáveis. 3 minutos de dispositivo de economia de energia automática, depuração de equipamentos inteligentes, detecção automática.</p><p><br></p><p>Descrição:</p><p>Inteligentemente projetado para leitura fácil e clara, o punho de pressão arterial é equipado com uma tela LCD grande para leituras mais precisas em 45 segundos. O monitor automático de pressão arterial tem tecnologia de medição avançada para fornecer as leituras mais precisas. Conveniente para rastrear sua saúde diária.</p><p><br></p><p>Especificações:</p><p>Material: Plástico ABS</p><p>Tamanho: 118*98*85mm</p><p>Pressão Sangue: 20-280mmHg</p><p>Taxa cardíaca: 40-165 batidas/min</p><p>Fonte de alimentação: bateria AAA*4 (não incluída), pode usar energia CA</p><p>Pressurização: Modo de Pressurização Automática</p><p>Temperatura de Operação: 15%-90%</p><p>Umidade de Operação: 40a-r59%</p><p>Temperatura de Armazenamento: -20℃-50℃</p><p>Umidade de Armazenamento: -20℃-50℃</p><p>Pulso: 40-200 Beatsainuto</p><p>Aplicação: Pulso</p><p><br></p><p>Incluído no Pacote:</p><p>1 pc * Hematomanômetro (Unidade principal)</p><p>1 pc * Faixa de Manguito</p><p>1 pc * Manual do usuário</p><p>1pc*cabo TYPC</p>', 46.7766, 59.97, NULL, 'https://cf.shopee.com.br/file/sg-11134201-7ra11-mba5kx8345u8b8', '{}', NULL, 'LOJA AGIL ', 'https://s.shopee.com.br/10yT98Z5BL', 4.8, 0, 0, true, NULL, '2026-03-25 16:59:26.132668+00', '2026-03-25 17:01:55.354192+00', 'f2f2e3af-9143-4a2c-9194-f6282a1cfcd6', NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 22.0, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '95a00be7-7f36-4590-a2d9-f78cd0a12689', NULL, 36, 313, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('8d949db7-5014-46e5-8398-24d545ad995b', 'Kit 3 Ou 1 Unidade Baby Tee Feminina Blusa Slim Fit Baby Look Manga Curta Blusa de Compressão Academia', '<p>Apresentamos a blusa baby tee, a peça essencial que combina estilo e conforto em perfeita harmonia. Confeccionada em tecido romantic, esta blusa foi ajustada para dar um realce a sua silhueta. Ideal para diversas ocasiões, desde um look casual de dia, atividades ao ar livre ou uma produção mais elaborada à noite.  A blusa slim fit oferece o equilíbrio perfeito entre estilo e praticidade e foi desenhada para se moldar suavemente ao seu corpo, proporcionando um visual moderno.</p><p><br></p><p>Atenção ao caimento!</p><p><br></p><p>Essa blusa tem modelagem SLIM e, por ser uma baby tee, a proposta é realmente ficar mais justinha ao corpo.</p>', 16.795800000000003, 39.99, 58, 'https://cf.shopee.com.br/file/br-11134207-81ztc-mjaae4ds39qafc', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.163328654934927.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.0088711799504394.webp}', NULL, 'Use_lay', 'https://s.shopee.com.br/2LTpD6TQ7O', 4.8, 0, 3, true, NULL, '2026-03-24 18:03:40.199651+00', '2026-03-25 01:16:27.104416+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 58.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '863befde-b087-4dee-bc39-36e519b18a48', NULL, 3, 5991, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('3b7de2f5-749e-4f0a-b085-22dcd1c4f631', 'Mor - Cadeira Alta Aço Sortido', 'A Cadeira de Praia Alta MOR é dobrável, ocupa pouco espaço e de fácil transporte.
Resistente: Suporta até 110Kg.
Sugestão de uso: varandas, sala de estar, camping e praças.
Estrutura em aço pintado, com braços plásticos e tela em polietileno listrada. As estampas são sortidas, assim você pode diversificar a decoração do seu espaço.', 59.3, 71.9, NULL, 'https://m.media-amazon.com/images/I/51UTATMAgUL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/51UTATMAgUL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/71zlzGAGW8L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/51CHm73+pQL._AC_SL1055_.jpg,https://m.media-amazon.com/images/I/61nGqVNp6IL._AC_SL1350_.jpg,https://m.media-amazon.com/images/I/517idA7ihdL._AC_SL1000_.jpg}', NULL, 'MOR', 'https://amzn.to/4lXgyYe', 5, 0, 1, true, NULL, '2026-03-25 22:30:42.822575+00', '2026-03-25 22:45:15.327404+00', 'e76da4cd-1bdc-490d-a450-5e21fd8979d2', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 17.5, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'c4cc1d6b-71ee-485e-b746-49c6a49c9762', 'B075XM6DKH', 8, 1000, '[{"name": "Marca", "value": "MOR"}, {"name": "Cor", "value": "Sortido"}, {"name": "Material", "value": "Metal, Plástico, Tecido"}, {"name": "Dimensões do produto", "value": "53P x 54L x 72A centímetros"}, {"name": "Tamanho", "value": "Cadeira"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sábado, 28 de Março Sábado, 28 de Março"}');
INSERT INTO public.products VALUES ('0ee21374-b263-4f18-8d3e-403dc2d7b954', 'Faca Tatica Com Bainha Bussola Apito Amolador Pederneira Ponta Quebra Vidro e Clip com Suporte Para Cinto Lamina Corte Misto Em Aço Inox Tipo Militar Para Camping Caça Mergulho Pesca Trilha Aventura', 'A Faca possui lâmina lisa em Aço Inox com bainha.
Com uma beleza que vai impressionar, a faca multifuncional é projetada para atender diversas necessidades tanto dentro de casa quanto ao ar livre, ideal para uso em pesca, camping, trilha, mochilada, caça, churrasco e outros. Projetada para ter alta durabilidade e uma lâmina afiada.

Especificações:
- Material da lâmina: Aço 440.
- Tamanho total: 27,5 cm.
- Tamanho do cabo: 14 cm.
- Tamanho da lâmina: 13,5 cm.
- Espessura da lâmina: 3 mm.
- Altura da lâmina: 3,5 cm.
- Lâmina afiada.
- Cabo ergonômico.
- Detalhes que impressionam.

ITENS INCLUSOS:
- 1 Faca.
- 1 Bainha com bússola e clip.
- 1 Pederneira com apito.
- 1 Amolador afiador de 9 cm.', 40, NULL, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_824469-MLA92353998912_092025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_824469-MLA92353998912_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_838015-MLA99624160550_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_923424-MLA92762456367_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_935487-MLA92762446345_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_964910-MLA92762199129_092025-F.webp}', 'Novo', 'Mercado Livre', 'https://meli.la/2p7euep', 4.8, 0, 1, true, NULL, '2026-03-26 12:38:36.548311+00', '2026-03-26 12:42:07.520721+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '14d349aa-ea80-4c42-b91a-720c2ef3497c', NULL, 26, 1000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('4f9c76f9-9bb1-43ee-90ce-04cf0754f4ec', 'Balança Digital Bioimpedância Bluetooth Inteligente Corporal Alta Precisão Com App Grátis Android E Ios Preta Marca Hardline Preto', 'Este produto é de titularidade da marca Hardline registrada no INPI e BPP protegida pela Lei da Propriedade Industrial (Lei nº 9.279/96). Qualquer vendedor ou empresa que tentarem fazer quaisquer alteração nesse anúncio será denunciada as autoridades competentes e processada. A comercialização, divulgação ou qualquer tipo de alteração neste anúncio sem autorização do detentor da marca constitui violação de direito de marca e concorrência desleal, passível de sanções cíveis e criminais conforme os artigos 129, 189 e 195 da referida lei.
Todas as ocorrências de alteração indevida serão formalmente notificadas e encaminhadas às autoridades competentes, bem como denunciadas à plataforma com pedido de suspensão da conta infratora.


Balança Digital Hardline – Bioimpedância Bluetooth

A Balança Digital Hardline traz tecnologia e praticidade para você acompanhar sua saúde de forma completa.
Com conexão Bluetooth e monitoramento de até 79 dados corporais, é ideal para quem busca evolução e bem-estar.

 Benefícios:

-79 dados monitorados (peso, IMC, gordura, massa muscular e mais)

-Conexão rápida via Bluetooth (Android e iOS)

-Liga automaticamente ao subir

-Design moderno e resistente

-Perfeita para atletas e famílias', 32, 36, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1774450600012-0e29tnjdsege.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_633197-MLA92889689146_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_996815-MLA93303003817_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_628036-MLA93303101359_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_735598-MLA92889659568_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_918964-MLA92889570242_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_874601-MLA91914421916_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_759459-MLA91914650138_092025-F.webp}', 'Novo', 'Mercado Livre', 'https://meli.la/2JBRdHt', 4.8, 0, 3, false, NULL, '2026-03-25 14:47:08.628231+00', '2026-03-26 12:13:04.275488+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 11.1, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'bbeb5177-d74e-415d-b506-7761a97a0148', NULL, 12, 10000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('28d1f05e-c067-4725-a756-54448e085c8d', 'Kit 5 a 30 prato fundo com borda branco refeição churrasco festa jantar sopa Jogo de pratos plastico', '<p>O prato fundo é ideal para servir refeições como sopas, caldos, risotos, carnes mais encorpadas, massas entre outras refeições. </p><p><br></p><p>Informações: </p><p>- Cores: BRANCO OFF WHITE</p><p>- Formato: REDONDO</p><p>- Medidas: 2 x 23 x 2 cm (Altura x Largura x Profundidade)</p><p> - Material: Plástico</p><p>- Detalhe: Desenho de Pétala</p><p><br></p><p>Cuidados: Sempre prefira lavar em água corrente, esponja macia para não danificar a pintura e detergente de sua preferência. </p><p><br></p><p>Temos uma equipe especializada para atender todas as suas dúvidas e experiência na sua compra pela internet. Garantindo assim, a satisfação de nossos clientes.</p><p><br></p><p>ENVIO EM MENOS DE 24 HORAS - - - - PRODUTO 100% NACIONAL</p>', 14.76, 36.9, NULL, 'https://cf.shopee.com.br/file/br-11134207-7qukw-lh9n45zmoho5f7', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.12205278632137817.webp}', NULL, 'Guiba Casa&Decor', 'https://s.shopee.com.br/3LMKVvH6SC', 4.5, 0, 2, true, NULL, '2026-03-23 13:40:38.126575+00', '2026-03-25 18:06:35.041857+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 60.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '863befde-b087-4dee-bc39-36e519b18a48', NULL, 13, 3218, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('df68154b-cc8e-4371-ad08-84b16061c6ed', '150×180×68cm Cercadinho para Bebe Para Bebês e Crianças Pequenas Chiqueirinho Bebe Para Internos & Externos Cercadinho de Segurança Resistente Para Bebês com Malha Macia e Respirável', '👶 Espaço de sobra para brincar! Com 150×180×68cm, esse cercadinho acomoda até 4 bebês ao mesmo tempo, oferecendo liberdade para engatinhar, explorar e se desenvolver com segurança.
🛡️ Mais segurança, menos preocupações Estrutura resistente e estável, feita com liga de aço e conectores ABS, além de ventosas antiderrapantes na base e zíper externo com trava de segurança – seu bebê protegido o tempo todo!
💨 Malha respirável e transparente Permite ventilação total e visibilidade completa. Acompanhe seu bebê de qualquer ângulo, mesmo enquanto realiza outras tarefas.
🏠 Perfeito para dentro e fora de casa Ideal para uso interno e externo, seja na sala, no quarto, no quintal ou varanda. A versatilidade que pais modernos precisam.
🧸 Cabe brinquedos, tapetes e muito mais! Espaço generoso para montar um verdadeiro cantinho da diversão. Estimula a criatividade e o desenvolvimento motor dos pequenos.
⏱️ Montagem rápida e sem ferramentas Sistema prático de encaixe com tubos e conectores que qualquer adulto consegue montar e desmontar com facilidade.
🧼 Tecido impermeável e fácil de limpar Feito com tecido Oxford de alta qualidade, é resistente a respingos e manchas, ideal para a rotina com crianças pequenas.
🙌 Liberdade para os pais Deixe seu bebê em um local seguro enquanto você cozinha, trabalha ou relaxa. Mais tranquilidade no seu dia a dia.
🧳 Leve, portátil e fácil de guardar Compacto quando desmontado. Ótimo para levar em viagens, mudar de cômodo ou guardar sem ocupar espaço.
💙 Qualidade e conforto em cada detalhe Acabamento macio, cantos arredondados e material sem BPA. Um produto que une segurança, praticidade e bem-estar para o seu bebê.', 179.99, 239.99, NULL, 'https://m.media-amazon.com/images/I/61ZDOL-6FqL._AC_SL1024_.jpg', '{https://m.media-amazon.com/images/I/61ZDOL-6FqL._AC_SL1024_.jpg,https://m.media-amazon.com/images/I/71iBRqqHNRL._AC_SL1024_.jpg,https://m.media-amazon.com/images/I/61qIXHAksIL._AC_SL1024_.jpg,https://m.media-amazon.com/images/I/61TGuOFJ5lL._AC_SL1024_.jpg,https://m.media-amazon.com/images/I/71RiOWZFx+L._AC_SL1024_.jpg}', NULL, 'RHEAD RED HIGH END STUDIOS', 'https://amzn.to/47p9oWv', 5, 0, 2, true, NULL, '2026-03-25 22:33:25.605061+00', '2026-03-25 23:09:12.141762+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 25.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'dbfa7aaf-01cf-4399-a4c9-c3b3532e752b', 'B0GK2ZFK5D', 13, 300, '[{"name": "Marca", "value": "RHEAD RED HIGH END STUDIOS"}, {"name": "Cor", "value": "Multicolor"}, {"name": "Material", "value": "Malha Macia E Respirável"}, {"name": "Peso do produto", "value": "3 Quilogramas"}, {"name": "Dimensões do item C x L x A", "value": "150 x 180 x 68 centímetros"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sábado, 28 de Março Sábado, 28 de Março"}');
INSERT INTO public.products VALUES ('0252b325-31e9-4f69-9952-8d821019dd14', 'Secador De Cabelos, Mondial, 2000w - Scn-01 Preto/violeta 127v', 'Cabelo seco de forma super-rápida: check! Os 2.000W de potência do Black Purple SCN-01 garantem um excelente desempenho para secagem ágil e eficiente. Além disso, a tecnologia Tourmaline Íon proporciona um aspecto mais saudável aos fios, reduzindo o frizz. Saiba mais sobre o Secador de cabelo Mondial:

TOURMALINE ÍON
Com o calor, o mineral emite íons negativos que fecham as cutículas dos fios e reduzem o frizz. Seu cabelo fica mais brilhante e macio!

ALTA POTÊNCIA
Os 2.000W deixam seu cabelo seco, modelado e lindo com rapidez e eficiência.

BOCAL DIRECIONADOR DE AR
Com o acessório, o fluxo de ar é mais preciso, facilitando a modelagem das mechas.

GRADE CERÂMICA
A parte frontal do secador é revestida de cerâmica. Assim, o calor é distribuído uniformemente e reduz os danos aos fios.

3 TEMPERATURAS + 2 VELOCIDADES
Escolha a combinação ideal para o seu tipo de cabelo.

JATO DE AR FRIO
O choque de temperatura no final da secagem reduz o frizz e ajuda a fixar a modelagem.

DESIGN ERGONÔMICO
É ergonômico e encaixa perfeitamente em sua mão. Garante mais conforto para você modelar os cabelos sem cansar.

GRADE TRASEIRA REMOVÍVEL
Facilita a limpeza e aumenta a durabilidade do secador.

ALÇA PARA PENDURAR
O secador pode ser guardado de forma fácil ou pendurado durante o uso.', 119.9, 172, 30, 'https://http2.mlstatic.com/D_NQ_NP_2X_931087-MLA100025900529_122025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_931087-MLA100025900529_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_939584-MLA88497137141_072025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_888512-MLA88155254926_072025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_845901-MLA88497305485_072025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_861168-MLA88497137177_072025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_747029-MLA88497186859_072025-F.webp}', 'Novo', 'Loja oficialMercado Livre', 'https://meli.la/17frkL2', 4.7, 0, 1, true, NULL, '2026-03-25 14:48:55.296206+00', '2026-03-25 16:47:37.458584+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 30.3, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '786de21b-3b9a-4244-882c-a6853b336f03', NULL, 16, 50000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('37e74a05-5862-47b3-b01d-ebb0f81c4d9a', 'Jogo De Toalhas 4 Pçs Fio Cardado 100% Algodão Bosco Karsten Cinza Bosco', 'A linha de toalhas Karsten Softmax é confeccionada em tecido 100% algodão de altíssima qualidade. Sua alta gramatura de 340 g/m² com corpo felpudo em fio cardado proporciona ótima absorção e toque super macio e suave, além de promover ótima absorção e secagem eficiente. Suas cores modernas com estilo cosmopolita trazem o charme que seu ambiente precisa.

Seu design elegante conta com detalhe Floral diferenciado na barra, deixando-a delicada e cheia de detalhes que fazem toda a diferença. Além disso, ela Possui tratamento pré-encolhimento e antipilling, que impede a formação das indesejadas “bolinhas”.

Volumosa e macia com qualidade e toque superior. Possui toque macio e fios aerados, com melhor absorção da água e secagem rápida.

- 100% Algodão

- Toque extra macio

- Volume acentuado

- Alta absorção

- Leveza e praticidade

- Pré-lavada e pré-encolhida

- Acabamento antipilling', 116, 149, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_814876-MLA95676723136_102025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_814876-MLA95676723136_102025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_649447-MLA92176831812_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_783757-MLA90352385227_082025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_983535-MLA90352120205_082025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_875697-MLA89972501078_082025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_639155-MLA89972530540_082025-F.webp}', 'Novo', 'Loja oficialMercado Livre', 'https://meli.la/1SJ6C9t', 4.7, 0, 2, true, NULL, '2026-03-26 14:33:26.614746+00', '2026-03-26 15:04:41.946643+00', '60189ea2-57db-4e2e-8629-a69c5176f72d', NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 22.1, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 12, 1000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('6ca89580-baee-47a1-8ef0-890843531fe2', 'Presente Dia das Mães Natura Essencial Clássico', '<p>Para as mães que amam a potência de uma perfumação abundante.</p><p><strong>•</strong>&nbsp;um sofisticado&nbsp;<strong>buquê floral</strong>&nbsp;de jasmin e violeta</p><p><strong>•</strong>&nbsp;com pitanga na composição, ingrediente da&nbsp;<strong>biodiversidade brasileira</strong></p><p><strong>•</strong>&nbsp;o&nbsp;<strong>floral intenso e amadeirado do deo parfum</strong>&nbsp;revela uma fragrância marcante e refinada</p><p><strong>•</strong>&nbsp;já o&nbsp;<strong>desodorante corporal potencializa a perfumação</strong>&nbsp;e protege contra odores da transpiração</p><p><strong>•</strong>&nbsp;um presente para transbordar elegância e sofisticação.</p><p>&nbsp;</p><p><strong>contém:</strong></p><p>1 deo parfum feminino 100 ml</p><p>1 desodorante corporal feminino 100 ml</p><p>1 caixa G especial Dia das Mães</p>', 229.9, 352.8, 35, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1774304870268-zsvtjej1q8.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.1906356219702663.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4565933991985949.webp}', NULL, 'Natura', 'https://www.minhaloja.natura.com/p/presente-dia-das-maes-natura-essencial-classico/NATBRA-238433?position=7&listTitle=manual+showcase+-++&consultoria=ofertashop&marca=natura', 0, 0, 0, true, NULL, '2026-03-23 22:30:27.364116+00', '2026-03-24 04:09:19.857726+00', 'abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', NULL, 'f729f5cd-3b0a-4ded-88d8-a5b578f0fb0b', NULL, 34.8, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '95a00be7-7f36-4590-a2d9-f78cd0a12689', NULL, NULL, 0, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('f6da7233-17ac-4252-8af4-e0216a3aebe9', 'Kit Mamãe e Bebê Shampoo, Condicionador, Sabonete em Barra e Hidratante (4 produtos)', '<p>Limpeza delicada desde o primeiro banho:</p><p>• a linha&nbsp;<strong>Mamãe e Bebê</strong>&nbsp;é formulada somente com o essencial para a pele e cabelos sensíveis do bebê</p><p>• todos os produtos são hipoalergênicos e formulados de maneira minimizar possível surgimento de alergia</p><p>• com ingredientes naturais</p><p>• o shampoo e o condicionador limpam, desembaraçam e hidratam os fios sem ressecar</p><p>• o sabonete tem fórmula 100% vegetal, limpa suavemente e protege a pele</p><p>• e o hidratante protege e hidrata com rápida absorção</p><p>&nbsp;</p><p><strong>contém:</strong></p><p>1 shampoo Mamãe Bebê 200 ml</p><p>1 condicionador Mamãe e Bebê 200 ml</p><p>1 sabonete Mamãe e Bebê 5 un de 100 g cada</p><p>1 hidratante Mamãe e Bebê 200 ml</p>', 128.1, 213.6, 40, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1774304376106-jq5z6u3wwx.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9945551052975483.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.3075905899564977.webp}', NULL, 'Natura', 'https://www.minhaloja.natura.com/p/kit-mamae-e-bebe-shampoo-condicionador-sabonete-em-barra-e-hidratante-4-produtos/NATBRA-218198?position=12&listTitle=category+page+list+showcase+-+infantil&consultoria=ofertashop&marca=natura', 0, 0, 0, true, NULL, '2026-03-23 22:23:10.823822+00', '2026-03-24 04:09:30.875505+00', 'abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', 'f9ff2a1b-69b7-4b01-8916-93bbadae3351', 'f729f5cd-3b0a-4ded-88d8-a5b578f0fb0b', NULL, 40.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '95a00be7-7f36-4590-a2d9-f78cd0a12689', NULL, NULL, 0, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('8c9da536-3571-4884-adf2-53979297d96a', 'Kit Ovo de Pascoa + Stitch Boneca e Copo Rosa Brinquedos ao Leite Promoção Infantil Meninas Promoção', '<p>Faça a alegria da Criançada neste Pascoa! Ótima opção de presente.</p><p><br></p><p>Tamanho dos bonecos: 16CM</p><p>COPO:19CM</p><p><br></p><p>VALIDADE: 30/05/27</p><p><br></p><p>ENVIADO NO ISOPOR.</p><p><br></p><p>ESCOLHA A QUANTIDADE DE BRINDES </p><p><br></p><p>Exclusividade Ovo de páscoa 265 gramas feito com chocolate nobre ao leite Garoto </p><p><br></p><p>Celebre a Páscoa em grande estilo com o irresistível Ovo de Páscoa  Este ovo de Páscoa não é apenas uma delícia de chocolate, mas também vem com um brinde exclusivo  garantindo momentos de diversão e alegria.</p><p><br></p><p>Este ovo de Páscoa Com 265g de chocolate ao leite de alta qualidade é perfeito para presentear ou para se deliciar sozinho. Além disso torna este ovo de Páscoa ainda mais especial e divertido.</p><p><br></p><p>Não perca a chance de ter o seu próprio Ovo de Páscoa do Stitch com um brinde incrível! Peça agora mesmo e faça desta Páscoa uma data ainda mais memorável.</p>', 49.99, NULL, NULL, 'https://cf.shopee.com.br/file/br-11134207-820lk-mld1czrwwvlz0e', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7081899827648043.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7133745931360366.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5818045829116851.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9199188989262441.webp}', NULL, 'LUTENSILIOS', 'https://s.shopee.com.br/6KzxZ9IglZ', 4.4, 0, 0, true, NULL, '2026-03-24 11:55:15.881433+00', '2026-03-24 22:22:30.715909+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'a0822333-17b8-40d1-acbb-c0401eb81fcf', NULL, 3, 283, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('5353db0e-e430-4c53-879e-3c187d777f13', 'Oster Cafeteira Flavor Programável, Vermelha, 220v,', 'Painel digital programável em aço inox, permite programar a hora ideal para você ter o seu café fresquinho e conta com o seletor de intensidade de pó, que possibilita escolher a dosagem certa para um café mais forte ou mais fraco.
Capacidade para fazer 36 xícaras de 42ml, escolhendo a intensidade para um café mais forte ou mais fraco
Função Timer que indica quanto tempo passou desde o preparo do seu café.
Filtro em Nylon, removível e lavável, transformando a limpeza da sua cafeteira muito mais eficiente.
Aviso sonoro, a Cafeteira Digital Oster emite um sinal sonoro para avisar quando seu café está pronto.', 234.5, 299, NULL, 'https://m.media-amazon.com/images/I/51HQ6ID+8sL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/51HQ6ID+8sL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/51pmhzAqsbL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/41gyNqxLZ8S._AC_SL1000_.jpg}', 'Menor preço em 365 dias', 'Oster', 'https://amzn.to/4tgJyMZ', 5, 0, 0, true, NULL, '2026-03-26 23:00:10.702295+00', '2026-03-26 23:01:07.2271+00', '77f33f36-2389-4d43-856e-cead4472697c', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 21.6, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '1cf6748a-3b9d-4d59-8946-dedaad54eea3', 'B076F9GTBC', 8, 200, '[{"name": "Marca", "value": "Oster"}, {"name": "Capacidade", "value": "1,5 Litros"}, {"name": "Cor", "value": "Vermelha"}, {"name": "Características especiais", "value": "Programável"}, {"name": "Tipo de cafeteira", "value": "Máquina de café gota a gota"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: quarta-feira, 1 de Abril. Se pedir dentro de 14 hrs 59 mins. Ver detalhes quarta-feira, 1 de Abril14 hrs 59 mins"}');
INSERT INTO public.products VALUES ('ce7815cb-25e7-4ad4-bec8-f12273641fe2', 'Kit 5 Camiseta Masculina 100% Algodão  Basica Treino Esporte', 'NOS da DZ.army sempre prezamos pela qualidade de nossos produtos e pelo otimo atendimento de nossos clientes, costuras bem feitas muita qualidade
 
nossas camisetas são fabricadas com materia prima de altissima qualidade e por profissionais capacitados.

somos fabricantes isso garante que temos total controle da cadeia produtiva


modelagem exclusiva q como podem ver nas fotos tem um otimo caimento
 uma camiseta muito versatil q pode ser usada tanto para ir trabalhar,, academia,,aquele passeio de fim de semana,,,ate mesmo uma balada,, com uma calça jeans descolada e um tenis (como em nossas fotos) vc ja estara muito bem vestido com um look muito bacana/

nossas peças tem o melhor custo beneficio do mercado livre.

o modelo da foto tem 1,84 de altura e 88kg

modelagem slim
composicão 100% algodão exceto a cor cinza q tem 88% algodão e 12% outras fibras.

tamanhos:

P: altura 69,0 cm /cintura: 51,0 cm/peito; 53,0cm/manga; 23,0 cm
M; altura 72,0cm /cintura; 52,0cm /peito; 57,0 cm/manga; 23,5 cm
G; altura 75,0 cm /cintura; 53,0 cm /peito; 58,0 cm/manga; 24,0 cm
GG; altura 76,0 cm/ cintura; 57,0 cm/peito; 61,0 cm/manga; 25,0 cm

nosso kit e composto por
 cores SORTIDAS


ATENCÃO:::: visando sempre o melhor para nossos clientes,,caso queira,, vc podera escolher as cores do seu kit para sua melhos satisfação.

perguntas frequentes:::

posso trocar? sim vc tem ate 30 dias para fazer a troca

posso escolher as cores? SIM temos essa flexibilidade

algodão? sim,,toque macio fio 30.1 penteado da melhor qualidade

Garantia do vendedor: 1 meses', 78.98, 78, NULL, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1774450609824-v5yocrjlz9q.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_832327-MLB52270809423_112022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_698581-MLB52270885073_112022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_884119-MLB50728295684_072022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_885359-MLB52270727698_112022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_876420-MLB52270780651_112022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_973225-MLB52270773723_112022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_933063-MLB51029797959_082022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_924672-MLB50728325617_072022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_619982-MLB51029807874_082022-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp,https://http2.mlstatic.com/D_NQ_NP_2X_949662-MLB93769122226_102025-F-kit-5-camiseta-masculina-100-algodo-basica-treino-esporte.webp}', 'Novo', 'Mercado Livre', 'https://meli.la/2RjGS7X', 4.7, 0, 4, true, NULL, '2026-03-25 14:46:36.852789+00', '2026-03-26 12:13:04.103887+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, -1.3, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'de3f5599-5a99-45f2-b1b0-1e0aee84ff1a', NULL, 26, 50000, '[{"name": "Cor", "value": "Disponível"}, {"name": "Tamanho", "value": "Disponível"}]', 99, '{"cashback": "", "meli_plus": false, "variations": [{"group": "Cor", "options": ["sortidas", "todas Cinza-escuro", "todas Preto", "todas Azul-escuro", "todas Cinza-claro", "todas Branco"]}, {"group": "Tamanho", "options": ["Perfeito para 85%"]}], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('d2eb75e2-53bf-45dc-877b-e4c96132b43d', 'Secador de Cabelo Profissional com Secagem Rápida Tecnologia Iônica, Bicos Inclusos – 110V – Cor: Rosa – Modelo Médio', 'Secagem rápida e eficiente – Ideal para todos os tipos de cabelo, reduzindo o tempo de secagem com ar potente e controlado.
Tecnologia iônica que reduz frizz e volume – Deixa os fios mais lisos, brilhantes e saudáveis após cada uso.
4 níveis de temperatura e 3 velocidades ajustáveis – Adapta-se a diferentes texturas e necessidades de finalização.
Bicos profissionais inclusos – Concentrador, difusor e bico arredondado para modelar, definir cachos e escovar com precisão.
Design ergonômico e leve – Confortável para uso prolongado, perfeito para casa ou salão de beleza.
Funcionamento silencioso e confortável – Menos ruído e maior praticidade no dia a dia.', 69.8, NULL, NULL, 'https://m.media-amazon.com/images/I/51Q7GYhBo0L._AC_UL320_.jpg', '{https://m.media-amazon.com/images/I/51Q7GYhBo0L._AC_UL320_.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5859488048640895.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.17310964950050756.jpg}', NULL, 'Amazon', 'https://amzn.to/4sF9cLw', 5, 0, 1, true, NULL, '2026-03-25 17:34:25.215775+00', '2026-03-25 19:21:59.240961+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '786de21b-3b9a-4244-882c-a6853b336f03', 'B0FHWBZM8F', 13, NULL, '[{"name": "Marca", "value": "Genérico"}, {"name": "Cor", "value": "Rosa"}, {"name": "Potência", "value": "368"}, {"name": "Fonte de alimentação", "value": "AC"}, {"name": "Características especiais", "value": "Acessórios: Bocal concentrador, difusor e bico arredondado, Nível de ruído: Baixo (menos de 60dB), Peso: Aproximadamente 400g – 550g (modelo leve e ergonômico), Tecnologia: Íons negativos (iônica), Voltagem: 110V Acessórios: Bocal concentrador, difusor e bico arredondado, Nível de ruído: Baixo (menos de 60dB), Peso: Aproximadamente 400g – 550g (modelo leve e ergonômico), Tecnologia: Íons negativos (iônica), Voltagem: 110VAcessórios: Bocal concentrador, difusor e bico arredondado, Nível de ruído: Baixo (menos de 60dB), Peso: Aproximadamente 400g – 550g (modelo leve e ergonômico), Tecnologia: Íons negativos (iônica), Voltagem: 110V Ver mais"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sexta-feira, 27 de Março. Ver detalhes Sexta-feira, 27 de Março"}');
INSERT INTO public.products VALUES ('ae6ab7a4-165c-4c39-a209-f5f4cc516cf6', 'Jogo com 6 Copos de Vidro Balão 470ml Design Elegante e Resistente Ideal para Suco Água Refrigerante Drinks e Café Transparente para Cozinha Bar e Restaurante', 'DESIGN ELEGANTE: Conjunto de 6 copos de vidro sem haste com formato arredondado e acabamento cristalino, perfeito para uso diário e ocasiões especiais
VERSATILIDADE: Copos multiuso ideais para servir água, sucos, refrigerantes e outras bebidas, adequados tanto para uso casual quanto formal
MATERIAL PREMIUM: Fabricados em vidro de alta qualidade, oferecendo durabilidade excepcional e transparência cristalina para melhor apreciação das bebidas
PRATICIDADE: Formato ergonômico que proporciona pegada confortável e segura, facilitando o uso no dia a dia
DIMENSÕES IDEAIS: Tamanho versátil para diferentes tipos de bebidas, com design que permite empilhamento fácil para armazenamento eficiente', 37.9, NULL, NULL, 'https://m.media-amazon.com/images/I/51-0dgnmfNL._AC_SL1200_.jpg', '{https://m.media-amazon.com/images/I/51-0dgnmfNL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61kK7LJyqwL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61AGThb+T9L._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/616leik7zgL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61SRAyUmMPL._AC_SL1200_.jpg}', NULL, 'Genérico', 'https://amzn.to/487IJxA', 5, 0, 2, true, NULL, '2026-03-25 22:25:32.355646+00', '2026-03-25 23:33:42.095929+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '74f5efd2-4ff5-4dfd-975e-6dc63d60ef6b', 'B0FS31FTP5', 8, 600, '[{"name": "Marca", "value": "Genérico"}, {"name": "Material", "value": "Vidro"}, {"name": "Cor", "value": "Transparente"}, {"name": "Capacidade", "value": "470 Millilitros"}, {"name": "Características especiais", "value": "Base Reforçada, Sem Haste, Vidro Resistente"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sábado, 28 de Março Sábado, 28 de Março"}');
INSERT INTO public.products VALUES ('a2c9ad39-f849-490c-ae4f-7860daa642c6', 'Fechadura Digital Inteligente Airtag Polegar Idali Life Preto', 'Controle sua fechadura de qualquer lugar
Conecte sua fechadura ao aplicativo e controle o acesso a sua propriedade de onde você estiver. Gerencie usuários, verifique o histórico de acesso e receba notificações no seu celular.

Maior segurança com proteção de choque
O sistema antichoque evita que a fechadura seja aberta por meio de uma descarga elétrica (arma de choque ou taser), tornando-a ainda mais segura contra intrusões.', 269.98, NULL, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_858896-MLA105692577097_012026-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_858896-MLA105692577097_012026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_777549-MLA105691566513_012026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_733620-MLA105113232300_012026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_777107-MLA105692547157_012026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_777060-MLA105691949809_012026-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_635514-MLA105692039369_012026-F.webp}', 'Novo', 'IDALI LIFE', 'https://meli.la/18eKoN2', 0, 0, 2, true, NULL, '2026-03-25 15:57:44.995872+00', '2026-03-26 12:12:53.578054+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '5168d6b0-95e4-40ad-becb-a8ea8f65a3bc', NULL, 12, 100, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('5ca3995f-eac6-4363-93fa-42b0c96761cf', 'Celular Xiaomi Redmi Note 15 Pro 512GB OU 256GB ', '<p>📱 Xiaomi Redmi Note 15 Pro 4G – Potência Extra, Câmeras Avançadas e Tela Premium</p><p><br></p><p>✅ Produto 100% Original Xiaomi</p><p>✅ Novo, Lacrado na Caixa</p><p>✅ Versão Global</p><p>✅ Pronta Entrega – Envio Rápido para Todo o Brasil</p><p><br></p><p>O Redmi Note 15 Pro 4G combina alto desempenho, fotografia avançada e uma tela premium AMOLED 120Hz, ideal para redes sociais, vídeos, jogos e multitarefas diárias. Com sistema Android 15 + HyperOS, ele entrega fluidez e confiabilidade em todas as tarefas. </p><p><br></p><p>⚙️ Especificações Técnicas</p><p><br></p><p>🔹 Modelo: Xiaomi Redmi Note 15 Pro 4G</p><p>🔹 Rede: 4G / LTE</p><p>🔹 Sistema Operacional: Android 15 com HyperOS</p><p>🔹 Processador: MediaTek Helio G200 Ultra</p><p>🔹 Dual SIM: Sim </p><p><br></p><p>💾 Memória &amp; Armazenamento</p><p><br></p><p>📦 Opções disponíveis (confira no seu estoque):</p><p><br></p><p>✔️ 8GB RAM + 256GB armazenamento</p><p>✔️ 8GB RAM + 512GB armazenamento</p><p><br></p><p>➡️ Armazenamento interno rápido e RAM ideal para multitarefas, apps pesados e jogos. </p><p><br></p><p>📺 Tela</p><p><br></p><p>🖥️ Tela AMOLED de 6,77” com 120Hz</p><p>🌈 Cores vibrantes, alto brilho com Gorilla Glass Victus 2 para proteção</p><p>👁️ Perfeita para vídeos, streaming e jogos com fluidez visual. </p><p><br></p><p>📸 Câmeras</p><p><br></p><p>📷 Câmera principal de 200 MP + 8 MP ultrawide + 2 MP macro</p><p>🤳 Câmera frontal de 32 MP</p><p>📸 Fotos com detalhes impressionantes e vídeos de ótima qualidade no dia a dia. </p><p><br></p><p>🔋 Bateria</p><p><br></p><p>🔋 Bateria de 6500 mAh com carregamento rápido 45 W</p><p>🔌 Bateria duradoura para um dia inteiro de uso ativo sem preocupações. </p><p><br></p><p>🌐 Conectividade &amp; Extras</p><p><br></p><p>✔️ NFC </p><p>✔️ Bluetooth</p><p>✔️ USB-C com OTG</p><p>✔️ Rádio FM</p><p>✔️ Sensores: impressão digital sob a tela, proximidade, giroscópio</p><p>✔️ Alto-falantes estéreo com Dolby Atmos</p><p>✔️ Proteção contra poeira/água (certificação conforme mercado) </p><p><br></p><p>🎨 Cores Disponíveis</p><p>✔️ Preto</p><p>✔️ Azul</p><p>✔️ Titânio (Cinza)</p><p><br></p><p>📦 Conteúdo da Embalagem</p><p><br></p><p>📱 Smartphone Redmi Note 15 Pro 4G</p><p>🔌 Carregador original</p><p>🔋 Cabo USB-C</p><p>📌 Ferramenta do SIM</p><p>📖 Manual</p><p>📦 Caixa original lacrada</p><p><br></p><p>🛡️ Garantia &amp; Segurança</p><p>✔️ Produto original Xiaomi</p><p>✔️ Envio seguro e bem embalado</p><p>✔️ Compra tranquila pela Shopee</p><p><br></p><p>🚚 Envio</p><p>📦 Postagem rápida após confirmação do pagamento</p><p>🚛 Entrega para todo o Brasil</p><p><br></p><p>💡 Ideal para quem procura:</p><p>✔️ Tela AMOLED 120Hz com excelente brilho</p><p>✔️ Câmera de 200 MP para fotos detalhadas</p><p>✔️ Bateria 6500 mAh para uso prolongado</p><p>✔️ Ótimo custo-benefício na série Pro da Xiaomi</p>', 1333.42, 2299, 8, 'https://cf.shopee.com.br/file/sg-11134201-825zo-mjh92aoo20p09a', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7335373658557995.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2772577975895163.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7003721364175077.webp}', 'Oferta!', 'CBO COMERCIAL', 'https://s.shopee.com.br/4VYIVJGoOb', 5, 0, 1, true, NULL, '2026-03-23 22:42:11.063938+00', '2026-03-24 22:22:29.160885+00', 'c8ac1472-f7ac-46fe-9728-e0a2924d58f6', 'ba7bc42e-11d1-4bf9-b887-4b9ff4daada7', '5a54bf84-4707-4f0f-a23c-689469fdbbb7', 'br-11110105-6v65e-mk2p97mzwmbl63.16000081769706627.mp4', 42.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', NULL, 4, 342, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('41d2c588-4b18-42c9-affb-1aaab6a3cf92', 'Mixer Philco PMX2000 3 em 1 Inox 800W 220V', '3 em 1 - Mixer, processador e batedor que proporcionam mais autonomia e versatilidade na cozinha
4 lâminas em inox - Duas grandes e duas pequenas que garantem maior resistência e durabilidade.
800W - Potência ideal para otimizar o preparo de receitas
Corpo desmontável - Muito mais fácil de limpar e armazenar
Batedor de Claras - Eficiente para bater omeletes, suspiros, claras e outros.', 198.9, 333.85, 40, 'https://m.media-amazon.com/images/I/5108-u5pe0L._AC_SL1200_.jpg', '{https://m.media-amazon.com/images/I/5108-u5pe0L._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/41PFXri0-uL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/41J9JCtNLbL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/412OM1f5JVL._AC_SL1200_.jpg}', NULL, 'PHILCO', 'https://amzn.to/4bxfCWT', 5, 0, 2, true, NULL, '2026-03-25 11:11:03.947128+00', '2026-03-25 16:49:14.799186+00', '49e78eb6-89b8-481b-915f-0d9fd7c43b81', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 40.4, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '1cf6748a-3b9d-4d59-8946-dedaad54eea3', 'B0CFM67MPS', 8, 1000, '[{"name": "Marca", "value": "PHILCO"}, {"name": "Cor", "value": "Preto e Inox"}, {"name": "Dimensões do produto", "value": "8,5P x 5,2L x 39,5A centímetros"}, {"name": "Material", "value": "Aço inoxidável"}, {"name": "Características especiais", "value": "Multiuso"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS Expressa: Sexta-feira, 27 de Março. Se pedir dentro de 10 hrs 29 mins Sexta-feira, 27 de Março10 hrs 29 mins Entrega GRÁTIS: Amanhã, 26 de Março Amanhã, 26 de Março"}');
INSERT INTO public.products VALUES ('f891a701-12b9-4a70-8677-5c2bee61e4f2', 'Sanduicheira Elétrica Cadence Toast & Grill, Preta, 750W, 110V', '<ul><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">NOVO DESIGN exclusivo Cadence, com Porta-fio e trava na alça;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">IDEAL para preparar 2 sanduíches ao mesmo tempo;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">CHAPA antiaderente, luz indicadora de funcionamento;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">ALTA POTÊNCIA: 750W para preparos rápidos e práticos para o dia a dia;</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">COM ALÇA ISOTÉRMICA, trava de segurança e pés antiderrapantes que auxiliam na segurança durante o uso.</span></li></ul><p><br></p>', 59.7, 100.89, 41, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1773706011992-sbubl28shd.jpg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.19691294741351384.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.8038771897070267.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.9852977507152725.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.2849525776766926.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.5340661938006928.jpg,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.01045378692862764.jpg}', 'Oferta', 'Amazon', 'https://amzn.to/4bj54sQ', 0, 0, 2, true, NULL, '2026-03-17 00:07:00.220193+00', '2026-03-25 16:49:54.445726+00', 'ba613e78-541a-42cd-af86-a45ce0aeb055', 'ea5cf827-a778-498f-8e6e-0547df9157a3', '31640105-56f9-43ab-8204-465c8717d731', NULL, 40.8, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 8, 0, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('2afe5d48-cdf8-4641-b2cf-d193ae4e93c7', 'Bolsa Termica Marmita Lancheira Grande Alça Ombro Trabalho Passeio Academia Dois Andares (Bolsa Cinza)', '📏 Tamanho compacto: 27,5cm de altura x 25cm de largura x 18cm de profundidade!
👜 Leve e fácil de transportar!
🌟 Mantenha suas refeições quentes ou frias por horas!
🎒 Versátil e funcional, pode ser usada como mochila!
🧼 Fácil de limpar, graças ao material de Oxford!
👌 Design elegante com fechamento em zíperes e bolsos extras!
🥗 Espaçosa, ideal para seu almoço saudável e suas bebidas!', 33.97, 37.7, NULL, 'https://m.media-amazon.com/images/I/61kmjyUJRKL._AC_SL1200_.jpg', '{https://m.media-amazon.com/images/I/61kmjyUJRKL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/71eWc1SYV8L._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/81sgWNoGlHL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61rGPduux4L._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61H6fUTtJWL._AC_SL1200_.jpg}', NULL, 'Amazon', 'https://amzn.to/4lWSPHG', 5, 0, 2, true, NULL, '2026-03-25 22:27:58.771336+00', '2026-03-25 23:49:19.583156+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 9.9, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'cca518e4-8d02-4446-a82f-bf796aa5c0ab', 'B0CYTTVHDF', 8, 1000, '[{"name": "Cor", "value": "Bolsa Cinza"}, {"name": "Material", "value": "Isolante Térmico, Nylon, Oxford"}, {"name": "Marca", "value": "Qubccum"}, {"name": "Características especiais", "value": "Alça de ombro ajustável, Impermeável, Isolado termicamente, Resistente a vazamentos, Resistente ao calor Alça de ombro ajustável, Impermeável, Isolado termicamente, Resistente a vazamentos, Resistente ao calorAlça de ombro ajustável, Impermeável, Isolado termicamente, Resistente a vazamentos, Resistente ao calor Ver mais"}, {"name": "Capacidade", "value": "10 Litros"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sexta-feira, 27 de Março. Ver detalhes Sexta-feira, 27 de Março"}');
INSERT INTO public.products VALUES ('82e3df48-ddf2-4cc9-8ce6-2719a46db8a8', 'Blazer Masculino Exalt Slim Fit 2 Botões Corte Italiano', 'Blazer masculino Exalt desenvolvido para quem busca um visual elegante, moderno e alinhado. Possui modelagem slim fit com corte italiano, oferecendo um caimento ajustado ao corpo que valoriza a silhueta masculina sem comprometer o conforto.

Confeccionado em tecido bengaline com elastano, proporciona elasticidade na medida certa, garantindo liberdade de movimento, conforto no uso diário e excelente estrutura, mantendo a sofisticação de um blazer social.

É uma peça versátil, ideal para trabalho, eventos, reuniões, jantares, festas e ocasiões sociais. Combina facilmente com camisas sociais, camisetas, calças sociais ou jeans.

Características do produto
Modelagem slim fit
Corte italiano
Tecido bengaline com elastano
Confortável e flexível
Boa elasticidade
Não limita os movimentos
Visual moderno e elegante

Tabela de medidas aproximadas
Antes de comprar, compare com uma peça semelhante que você já possua.

Tamanho P
Comprimento 57 cm
Comprimento da manga 60 cm
Largura 46 cm

Tamanho M
Comprimento 58 cm
Comprimento da manga 62 cm
Largura 48 cm

Tamanho G
Comprimento 59 cm
Comprimento da manga 64 cm
Largura 50 cm

Tamanho GG
Comprimento 60 cm
Comprimento da manga 66 cm
Largura 52 cm

Observação
Por se tratar de um blazer slim fit, o caimento é mais ajustado ao corpo. Caso prefira um ajuste mais confortável, recomendamos escolher um tamanho acima.

Informações adicionais
Produto novo
Envio imediato
Acompanha nota fiscal
Garantia de 30 dias contra defeitos de fabricação

Atenção
Este anúncio refere-se somente ao blazer. A calça não está inclusa. Temos outros anúncios em nossa loja com conjunto de blazer e calça.

Perguntas frequentes

O produto é novo
Sim, todos os produtos são novos.

O produto é original
Sim, produto original da loja Right Time.

Posso trocar ou devolver
Sim, conforme as políticas do Mercado Livre, desde que o produto esteja sem uso e em sua embalagem original.

Acompanha nota fiscal
Sim, todos os pedidos são enviados com nota fiscal.

Garantia do vendedor
30 dias contra defeitos de fabricação.

Garantia do vendedor: 30 dias', 99.24, 129, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_661842-MLB94691381784_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_661842-MLB94691381784_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_652182-MLB94691695986_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_940466-MLB94691372796_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_988084-MLB95123874639_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_814884-MLB94691313194_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_993690-MLB95123914437_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_902479-MLB95123942739_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_694326-MLB94691341796_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_625283-MLB95124098757_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp,https://http2.mlstatic.com/D_NQ_NP_2X_999276-MLB95123833881_102025-F-blazer-masculino-exalt-slim-fit-2-botoes-corte-italiano.webp}', 'Novo', 'RIGHTTIME02', 'https://meli.la/29Gts6a', 4.4, 0, 3, true, NULL, '2026-03-23 00:36:54.21849+00', '2026-03-26 12:13:00.309251+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 23.1, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '49a45f32-5dad-4d05-97be-ed6dafa73c97', NULL, 22, 500, '[{"name": "Cor", "value": "Disponível"}, {"name": "Tamanho", "value": "Disponível"}]', 99, '{"cashback": "", "meli_plus": false, "variations": [{"group": "Cor", "options": ["Azul-marinho", "Cinza-escuro"]}, {"group": "Tamanho", "options": ["Perfeito para 76%"]}], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('c2cd6c40-7828-4dcc-b08d-39f06e01f91c', 'Blazer Masculino Slim 2 Botões Corte Italiano - Mega Oferta', '**********LEIA A DESCRIÇÃO TEMOS TODAS SUAS DÚVIDAS RESPONDIDAS********
---------------------------------------- PEÇA PELA NUMERAÇÃO DO PALETÓ, A CALÇA É CORRESPONDENTE EM 6 NÚMEROS ABAIXO --------------------------------------------------------

"A loja virtual que lhe oferece o melhor TERNO SLIM MASCULINO do mercado"

PORQUE COMPRAR CONOSCO?
*Porque somos os melhores do mercado!
*Temos os melhores ternos Slim masculinos!
*Temos os melhores tecidos e o acabamento é de primeira linha.
*Temos os melhores preços!
*Temos entrega rápida!
*Temos uma equipe preparada pra dar o melhor atendimento.

CARACTERÍSTICAS do produto

Tecido Oxford
Slim 02 botões
Corte Italiano
Pespontado no interior
Alta qualidade
Caimento perfeito no corpo
Direto da Fabrica
Ano do lançamento: 2022

TAMANHO DO BLAZER BASEANDO COM A CALÇA:

PP = BLAZER 42 E CALÇA 36
P = BLAZER 44 E CALÇA 38
M = BLAZER 46 E CALÇA 40
G = BLAZER 48 E CALÇA 42
GG = BLAZER 50 E CALÇA 44
EG = BLAZER 52 E CALÇA 46
EGG = BLAZER 54 E CALÇA 48
XGG = BLAZER 56 E CALÇA 50
XXG = BLAZER 58 E CALÇA 52
G7 = BLAZER 60 E CALÇA 54

ITEM INCLUSO: SOMENTE BLAZER.

O Blazer Masculino Slim 2 Botões Corte Italiano da marca CW-ADONAI é a escolha perfeita para homens que buscam elegância e sofisticação em suas vestimentas. Com um corte italiano que valoriza a silhueta, este blazer é ideal para pastores, palestrantes e advogados que desejam se destacar em eventos formais e profissionais.

Confeccionado em poliéster de alta qualidade, o modelo oferece conforto e durabilidade, sendo uma peça versátil para a primavera e o verão. Seu estilo slim fit proporciona um ajuste moderno, garantindo que você se sinta confiante e à vontade durante todo o dia.

A composição em Oxford confere um toque de classe, tornando este blazer uma adição indispensável ao guarda-roupa masculino. Seja para uma apresentação importante ou uma reunião de negócios, o Blazer Slim 2 Botões é a escolha certa para quem valoriza a imagem e a apresentação pessoal.

Garantia do vendedor: 7 dias', 183.9, NULL, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_977736-MLB84818860104_052025-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_977736-MLB84818860104_052025-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp,https://http2.mlstatic.com/D_NQ_NP_2X_662082-MLB48465897573_122021-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp,https://http2.mlstatic.com/D_NQ_NP_2X_961938-MLB48465922404_122021-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp,https://http2.mlstatic.com/D_NQ_NP_2X_702538-MLB52647043601_112022-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp,https://http2.mlstatic.com/D_NQ_NP_2X_917162-MLB48465851996_122021-F-blazer-masculino-slim-2-botoes-corte-italiano-mega-oferta.webp}', 'Novo', 'CW ADONAI', 'https://meli.la/22WPmqc', 4.3, 0, 0, true, NULL, '2026-03-23 00:41:01.714081+00', '2026-03-25 16:44:48.479149+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '49a45f32-5dad-4d05-97be-ed6dafa73c97', NULL, 16, 100, '[{"name": "Cor", "value": "Disponível"}, {"name": "Tamanho", "value": "Disponível"}]', 99, '{"cashback": "", "meli_plus": false, "variations": [{"group": "Cor", "options": ["Azul bebe", "Azul Royal", "Azul-marinho", "Cinza-escuro", "Marsala", "Preto"]}, {"group": "Tamanho", "options": ["Perfeito para 50%"]}], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('b62b2e31-1d8c-4ab0-b9b5-722b43ad75d3', 'Sabonete em Barra Puro Vegetal Tododia Romã e Flor de Amora', '<p>Limpa sem ressecar e perfuma a pele com a fragrância envolvente de Romã e Flor de Amora.</p><p><br></p><p>Viva um banho cheio de sentidos com o Sabonete em Barra Puro Vegetal Tododia Romã e Flor de Amora. Sua fórmula gentil envolve uma cuidadosa combinação de ingredientes de origem natural que mantém a hidratação da sua pele e a deixa perfumada.</p>', 26.1, 34.9, 25, 'https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/1774388379220-o45sfsjrz6.jpeg', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.007576596784928169.webp}', 'Muito Barato', 'Natura', 'https://sminhaloja.natura.com/memkRUw', 0, 0, 5, true, NULL, '2026-03-24 21:42:21.24471+00', '2026-03-26 19:34:00.491538+00', 'abbed348-d0b2-42d9-a2a9-ff8c1ec9f689', '5cbe6e44-319e-40d3-8f78-e32d09234a7a', 'f729f5cd-3b0a-4ded-88d8-a5b578f0fb0b', NULL, 25.2, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '95a00be7-7f36-4590-a2d9-f78cd0a12689', NULL, NULL, 0, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('bebbe3c7-58a6-4dd0-9e52-76d918dd0a41', 'Kit 8 Alimentação Bebê Silicone Prato Babador Copo Tigela Cor Azul-aço', 'Este conjunto de 8 peças de pratos com ventosa infantil é feito de silicone de alta qualidade, livre de BPA, garantindo segurança durante as refeições. O babador de silicone é macio, e os outros utensílios, como tigelas, pratos, garfos e colheres, são resistentes a quedas.

A textura antiderrapante do silicone incentiva os bebês a comerem de forma independente, evitando respingos e bagunças. É perfeito para uso diário, resistindo ao desgaste e ao uso constante.

Compacto e leve, é ideal para viagens, camping, piqueniques e jantares em família. Seu tamanho moderado se adapta à maioria das mesas e cadeiras infantis, facilitando o transporte.

Além disso, pode ser usado no micro-ondas e na geladeira, mantendo a comida na temperatura certa. Este conjunto completo de talheres é um presente significativo para novos pais.

Especificações:

Cores disponíveis: azul, rosa
Material: silicone de qualidade alimentar (BPA free)
Tamanhos: prato (19x18.2 cm), babador (24x29.5 cm), tigela (11.2x11 cm), colher (13.5 x 3.5 cm), copo de água (14 x 14 cm)
Faixa etária: acima de 3 meses
O pacote inclui:

1 prato de silicone
1 tigela
1 colher e 1 garfo com cabo de madeira
1 colher e 1 garfo em silicone
1 babador
1 copo de água com tampa canudo.', 36.24, NULL, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_908926-MLA99598913234_122025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_908926-MLA99598913234_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_619917-MLA91512913510_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_612686-MLA91513459236_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_955038-MLA91911660313_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_935499-MLA91512933554_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_765762-MLA91513489110_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_948849-MLA91911214269_092025-F.webp}', 'Novo', 'maiscomprasrj Vendido porGCTECOMM Vendido porMRGIFTS', 'https://meli.la/2JL5KEQ', 4.8, 0, 2, true, NULL, '2026-03-24 12:50:20.030835+00', '2026-03-25 16:45:06.52297+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'dbfa7aaf-01cf-4399-a4c9-c3b3532e752b', NULL, 12, 10000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('ad502528-58d6-4f78-9971-e5286a526546', 'Kit 8 Cuecas Boxer Polo Wear Microfibra', '<ul><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Ideal para o dia a dia</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Super Confortável</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Modelagem Perfeita ao Corpo</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Modelo: Boxer</span></li><li><span style="color: var(--__dChNmAmGoMXsw4B,#0f1111);">Microfira</span></li></ul><p><br></p>', 98.9, NULL, NULL, 'https://m.media-amazon.com/images/I/51GUgMHf+qL._AC_SL1080_.jpg', '{https://m.media-amazon.com/images/I/51GUgMHf+qL._AC_SL1080_.jpg,https://m.media-amazon.com/images/I/61EHtD+SPtL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61i79Nch-zL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/51gm8F1vUVL._AC_SL1200_.jpg,https://m.media-amazon.com/images/I/61e3XA1KqOL._AC_SL1200_.jpg}', NULL, 'Polo Wear', 'https://amzn.to/4bKeMVw', 5, 0, 3, true, NULL, '2026-03-25 22:20:00.558781+00', '2026-03-26 00:21:48.180481+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'dc47e24e-7379-4a17-8f6e-acbad91e9a6e', 'B09F75J3BK', 11, NULL, NULL, NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Quinta-feira, 9 de Abril. Ver detalhes Quinta-feira, 9 de Abril"}');
INSERT INTO public.products VALUES ('506bd334-8dc9-458b-96c1-f99e9c6db36d', 'Chaleira Elétrica Inox Elgin - Jarra Sem Fio 2 Litros Desligamento Automático 110V', 'CAPACIDADE DE 2L: Preparo de chá, café, sopa instantânea, chimarrão e outras bebidas.
JARRA SEM FIO: Muito mais praticidade para transportar.
DESLIGAMENTO AUTOMÁTICO: Impede que a água ferva até seca.
ACABAMENTO INOX: Mais fácil de limpar e alta durabilidade.
GARANTIA DE 1 ANO: Garantia expressa de 1 ano.', 57.9, 119, NULL, 'https://m.media-amazon.com/images/I/518J6L5BsHL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/518J6L5BsHL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/613L07kE1DL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/61uYIOWK0jL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/61AWz6qClML._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/61RE2b+UZFL._AC_SL1500_.jpg}', NULL, 'Elgin', 'https://amzn.to/4rVknOU', 4.1, 0, 0, true, NULL, '2026-03-26 23:08:07.415508+00', '2026-03-26 23:09:02.544822+00', '2f146099-debe-472a-9333-7229545a2f08', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 51.3, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '1cf6748a-3b9d-4d59-8946-dedaad54eea3', 'B09GKSWN8T', 8, 2000, '[{"name": "Marca", "value": "Elgin"}, {"name": "Capacidade", "value": "1,8 Litros"}, {"name": "Material", "value": "Plástico"}, {"name": "Cor", "value": "Prata"}, {"name": "Características especiais", "value": "Portátil"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: quarta-feira, 1 de Abril. Se pedir dentro de 14 hrs 51 mins. Ver detalhes quarta-feira, 1 de Abril14 hrs 51 mins"}');
INSERT INTO public.products VALUES ('61cca252-c069-4e3a-bda6-92bc353960b5', 'Lavadora De Alta Pressão Kärcher Compacta 1500 Psi/libras 1400w 300l/h Com Aplicador De Detergente E Lança Regulável 220v Amarelo/preto 50/60hz', 'Lavadora de Alta Pressão Kärcher Compacta 1500PSI 1400W

A Lavadora de Alta Pressão Kärcher Compacta é ideal para as tarefas do dia-a-dia, proporcionando uma limpeza profunda, rápida e sem esforço com ótimo custo-benefício. É um equipamento compacto, fácil de transportar e armazenar.

Com 1500PSI de pressão, a Lavadora ajuda na remoção das sujeiras mais difíceis do seu carro, casa, quintal, garagem, e muito mais. Acompanha uma Lança de Jato Reto regulável e um canhão de espumas que facilita a remoção da sujeira, economizando tempo e água em comparação com uma mangueira de jardim convencional.

Diferenciais:

- Aplicador de detergente: Facilita a remoção da sujeira na hora da limpeza.
- Bomba com conector em alumínio e cabeçote em N-Cor: Alta resistência e durabilidade.
- Porta acessórios integrado: Maior praticidade durante o uso e facilidade no transporte e armazenamento.
- Economia de água: Em comparação com uma mangueira de jardim, garante a economia de água em até 80%.
- Lavadora ergonômica: Design prático e compacto que garante conforto e facilidade na hora do uso.

Dados Técnicos:

Pressão máx.(PSI): 1500  
Vazão máx.(L/h): 300  
Potência (W): 1400  
Cabo Elétrico: 5 metros  
Tipo de Motor: Universal  
Tipo de Bomba: Alumínio  
Material do Cabeçote: N-cor  
Material dos pistões: Inox  
Dimensões do produto montado (CxLxA): 400 x 210 x 200 mm  
Peso da máquina(kg): 4  

Acessórios inclusos:

- 1 lavadora de alta pressão Kärcher Compacta  
- 1 lança de jato reto regulável  
- 1 pistola de alta pressão  
- 1 mangueira de alta pressão de 3 metros  
- 1 canhão de espumas (300ml)  
- 1 engate rápido  
- 1 manual de instruções  

Recomendamos o uso com os produtos de limpeza:

- Kärcher Deterjet  
- Kärcher Shampoo automotivo  
- Kärcher Detergente Alcalino Clorado  
- Kärcher Pinho Fresh  
- Kärcher Multiuso  
- Kärcher Desengraxante  

Aviso legal
• Certificado pela INMETRO.', 299, 445, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_933850-MLA100077907473_122025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_933850-MLA100077907473_122025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_601308-MLU72699959379_112023-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_601720-MLU72699920337_112023-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_833593-MLU72627743160_112023-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_994871-MLU72699920345_112023-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_773000-MLU72627743164_112023-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_895452-MLU72627743172_112023-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_975117-MLU72699959411_112023-F.webp}', 'Novo', 'Loja oficialDesconto Magazine', 'https://meli.la/1VTjLYW', 4.8, 0, 0, true, NULL, '2026-03-23 13:24:05.97903+00', '2026-03-25 16:45:14.593939+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, 32.8, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4a8db87c-0ea4-45b7-8a36-1bad3a8eb410', NULL, 12, 50000, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('8ec39689-5943-49d4-a09c-2c15c00bf6c1', 'Perfume Capilar + Body Splash Barbour''s Beauty Feminino Delight', 'Kit Delight – Body Splash 200ml + Perfume Capilar 50ml

Fragrância feminina e envolvente. Um dos queridinhos da linha Barbour’s Beauty!

Ideal para uso diário, com fixação leve e marcante.

Notas olfativas: Lichia, Peônia e Cedro.

Body Splash 200ml
• Perfume corporal leve, com alta refrescância
• Ideal para borrifar após o banho ou ao longo do dia
• Fragrância duradoura com toque suave

Perfume Capilar 50ml
• Perfuma os cabelos sem pesar
• Ação condicionante, brilho e proteção contra odores externos
• Pode ser usado com cabelos secos ou úmidos', 110, NULL, NULL, 'https://http2.mlstatic.com/D_NQ_NP_2X_914915-MLA92101455506_092025-F.webp', '{https://http2.mlstatic.com/D_NQ_NP_2X_914915-MLA92101455506_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_633513-MLA92101455522_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_704399-MLA92506566201_092025-F.webp,https://http2.mlstatic.com/D_NQ_NP_2X_845814-MLA92506487995_092025-F.webp}', 'Novo', 'mimosdossonhos Vendido porSANDY-009', 'https://meli.la/2oHW354', 4.7, 0, 3, true, NULL, '2026-03-25 16:34:59.788987+00', '2026-03-25 20:35:05.304788+00', NULL, NULL, '470eab59-13aa-43e1-84f0-71712bd56389', NULL, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '10a537b3-3365-40e2-8f0d-4ffdf1d00973', NULL, 16, 100, NULL, 99, '{"cashback": "", "meli_plus": false, "variations": [], "shipping_details": "Frete Grátis", "seller_reputation": ""}');
INSERT INTO public.products VALUES ('bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', 'Kit 10 Marmita conjunto Potes 750ml com Travas Laterais BPA FREE - Alimentos organizadores de congelador', '<p>Kit com 10 Marmitas  750ml MATERIAL MATERIAL PLÁSTICO  – Práticas, Resistentes e Versáteis!</p><p><br></p><p>Organize sua rotina com este kit contendo 10 marmitas de 800ml cada, ideais para suas refeições do dia a dia! Com travas laterais duplas e corpo transparente, elas oferecem praticidade, segurança e visualização fácil dos alimentos.</p><p><br></p><p>Perfeitas para:</p><p>️Levar marmitas para o trabalho ou estudos</p><p>️Organizar alimentos na geladeira ou no armário</p><p>️Armazenar porções no congelador</p><p>️Aquecer direto no micro-ondas (sem tampa)</p><p><br></p><p>Características:</p><p><br></p><p>Capacidade: 750ml</p><p>Material resistente e livre de BPA</p><p>Travas laterais seguras que evitam vazamentos</p><p>Pode ir ao freezer e ao micro-ondas</p><p>Fácil de empilhar e limpar</p><p><br></p><p>Garanta já o seu kit e facilite seu dia a dia com mais organização e praticidade!</p>', 18.668, 35.9, 48, 'https://cf.shopee.com.br/file/sg-11134201-821ez-mgq7x2bpxibxd7', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.47961204644975686.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7590792970313767.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7617709020121965.webp}', NULL, 'Shopee', 'https://s.shopee.com.br/5L7R2vMloF', 4.1, 0, 3, true, NULL, '2026-03-24 22:01:11.239937+00', '2026-03-24 22:22:33.634142+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 48.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 10, 14524, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('41e3e392-9d32-42a4-9afc-12a4bfcfda9d', 'Máquina de Café Expresso 1,6L Cafeteira Inox Premium 20 Bar', NULL, 699.99, 699.99, NULL, 'https://cf.shopee.com.br/file/br-11134207-81z1k-mgi9czkdqgp101', '{}', NULL, 'FB STORE GROUP', 'https://s.shopee.com.br/9pZrdwfbFS', 5, 0, 0, true, NULL, '2026-03-25 16:39:57.94632+00', '2026-03-25 16:41:05.051345+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 0.0, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '863befde-b087-4dee-bc39-36e519b18a48', NULL, 10, 3, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('1177c463-9ddd-4d01-ba58-070d95037d8b', 'Electrolux Kit 12 Potes Herméticos de Plástico Retangulares, Multiuso, Vedação Silicone, BPA Free, Porta Mantimentos', 'Feitos com material de alta qualidade e livres de BPA.
Formatos inteligentes com tamanhos funcionais e empilháveis que facilitam a organização na sua cozinha.
Conta com tampa de fácil abertura e registro de data para controle de armazenamento.
Vedação hermética com anel de silicone, possuem selagem perfeita que ajuda a preservar e conservar os alimentos e nutrientes por mais tempo.', 97.9, 129.9, NULL, 'https://m.media-amazon.com/images/I/51uccv-jBiL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/51uccv-jBiL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/517N5X5p4NL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61mDXbMLe4L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/51t1RYU3t9L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/51BSUCQnNBL._AC_SL1000_.jpg}', NULL, 'Electrolux', 'https://amzn.to/4dKsFpf', 5, 0, 2, true, NULL, '2026-03-25 22:23:08.875515+00', '2026-03-26 12:12:56.976048+00', 'ac573dc8-afa4-4add-934e-b94ffc431780', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 24.6, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', 'B09XJL4B9H', 8, 10000, '[{"name": "Marca", "value": "Electrolux"}, {"name": "Cor", "value": "Cinza"}, {"name": "Material", "value": "Plástico Polipropileno"}, {"name": "Característica do material", "value": "Pode ser lavado na máquina de lavar louça, Seguro para micro-ondas"}, {"name": "Dimensões do produto", "value": "27,1C x 18,8L x 20,5A centímetros"}]', NULL, '{"prime": true, "shipping_details": "Entrega GRÁTIS: Amanhã, 26 de Março Amanhã, 26 de Março Entrega GRÁTIS: Sábado, 28 de Março Sábado, 28 de Março"}');
INSERT INTO public.products VALUES ('48810ae3-ce2a-4f66-b962-116d4a94a95e', 'Micro-ondas 20L Branco MasterCook Midea 110V', 'O Micro-ondas 20L MasterCook Midea chegou para transformar sua experiência na cozinha! Descubra a praticidade e inovação da linha MasterCook Midea e leve mais tecnologia para o seu dia a dia!
Receitas pré-programadas. Tecla Ligar/+30 segundos. Praticidade no seu dia a dia: Arroz, Brigadeiro, Pipoca
Função MasterCook - Botão com 6 funções (Derreter, Vapor, Cozinhar, Fermentar, Desidratar e Assar)
Função Limpar: ameniza os odores do seu aparelho. Função Silêncio: Utilizada para silenciar todos os avisos sonoros do micro-ondas.
Função Manter Aqueceido: seu prato pronto com mais praticidade. Função Baby care: Receita pré-programada para aquecer leite e papinha. Baixo consumo de energia- classificação A', 499, 569, 12, 'https://m.media-amazon.com/images/I/71Kvt--GqNL._AC_SL1500_.jpg', '{https://m.media-amazon.com/images/I/71Kvt--GqNL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/81F3q-tJX7L._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71g46HF9cNL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71KNu0oUuRL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/715-LBb9NdL._AC_SL1500_.jpg}', NULL, 'Midea', 'https://amzn.to/4syZrOD', 5, 0, 2, true, NULL, '2026-03-26 00:17:44.582132+00', '2026-03-26 12:11:52.644288+00', 'ff2c9e35-9f68-4884-aab7-e2c9bd98a90f', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 12.3, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '1cf6748a-3b9d-4d59-8946-dedaad54eea3', 'B0FGZ6FCGY', 8, 1000, '[{"name": "Marca", "value": "Midea"}, {"name": "Dimensões do produto", "value": "33,8P x 43,9L x 25,8A centímetros"}, {"name": "Cor", "value": "Branco"}, {"name": "Capacidade", "value": "20 Litros"}, {"name": "Características especiais", "value": "* Função MasterCook, * Receitas pré-programadas, * Função Manter Aqueceido, * Tecla Ligar/+30 segundos, * Menu Descongelar, * Baixo consumo de energia- classificação A, * Função Limpar, *Função Silêncio, * Função Baby care * Função MasterCook, * Receitas pré-programadas, * Função Manter Aqueceido, * Tecla Ligar/+30 segundos, * Menu Descongelar, * Baixo consumo de energia- classificação A, * Função Limpar, *Função Silêncio, * Função Baby care* Função MasterCook, * Receitas pré-programadas, * Função Manter Aqueceido, * Tecla Ligar/+30 segundos, * Menu Descongelar, * Baixo consumo de energia- classificação A, * Função Limpar, *Função Silêncio, * Função Baby care Ver mais"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sábado, 28 de Março Sábado, 28 de Março"}');
INSERT INTO public.products VALUES ('0813c095-39ff-46cc-a5f7-756c8c75f2d6', 'Faqueiro Tramontina Búzios Em Aço Inox Com Detalhe 24 Peças', '<p>Conjunto de Talheres 24 Peças Inox Búzios Tramontina</p><p><br></p><p>Encante amigos e familiares com o Faqueiro Tramontina Búzios em Aço Inox com Detalhe 24 Peças!</p><p><br></p><p>Produzido totalmente em aço inox, o faqueiro é resistente e durável, proporcionando uma composição mais especial para sua mesa. As peças possuem acabamento de qualidade, agregando charme às refeições.</p><p><br></p><p>As peças são fáceis de limpar e podem ser lavadas na máquina de lavar louças.</p><p><br></p><p>- Talheres produzidos em aço inox que mantêm a beleza, higiene e durabilidade.</p><p>- Lâminas das facas com maior durabilidade do fio devido ao tratamento térmico.</p><p>- Garfos e colheres com maior resistência devido à espessura do aço e estampagem das lâminas.</p><p>- Adequados para máquina de lavar louças.</p><p><br></p><p>Kit composto por:</p><p>- 06 Colher de Mesa.</p><p>- 06 Colher de Chá.</p><p>- 06 Faca para Churrasco.</p><p>- 06 Garfo de Mesa.</p><p><br></p><p>Certificação NSF - Produtos da Linha Búzios certificados pela National Sanitation Foundation (NSF), organização reconhecida em segurança alimentar e práticas de higiene.</p>', 33.3183, 70.89, 53, 'https://cf.shopee.com.br/file/sg-11134201-7rav5-mau2af5mj0b49f', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.043083503407627344.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.7379721631452556.webp}', 'Mais Vendidos', 'ATOZ DISTRIBUIDORA', 'https://s.shopee.com.br/4VYIC7Mkii', 4.9, 0, 4, true, NULL, '2026-03-23 18:02:39.092911+00', '2026-03-24 22:22:32.197804+00', '1a071b94-6208-4fc3-bfa5-2fc6be200de4', '0993958d-8938-48aa-b0d8-93f92a912f96', '5a54bf84-4707-4f0f-a23c-689469fdbbb7', NULL, 53.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4892e78b-d2cc-43b8-8a17-605b03f1d4a3', NULL, 11, 916, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('ddb4a64b-3797-4277-9cf1-2322ca0a7f2e', 'Kit Ovo de Páscoa Infantil Barbie Minnie Stitch Princesas Aranha Naruto Hulk Sonic Presente Perfeito', '<p>Kit Pascoa C/ Ovo + Mochila pequena + copo + Bolinha - Tema Infantil - Wandinha - Princesas -  Aranha - Naruto - Hulk - Sonic</p><p><br></p><p>Itens Inclusos </p><p><br></p><p>Pricesas / Frozen / Barbie / Wandinha / Minnie / Stitch Rosa + Maquiagem</p><p>1 -Ovo - 80Gr</p><p>1 - Palitos Crocante</p><p>1 - Mochila</p><p>1 - Copo</p><p>1 - Bolinha Supresa</p><p>1 - Kit Maquiagem</p><p>1 - Tiara de Orelhinha c/ Glitter</p><p>1 - Coração com Colarzinho Infantil c/ Pingente</p><p><br></p><p>---------------------------------------------------------------------------//------------------------------------------------------------------------</p><p>Hulk / Homem Aranha / Sonic / Naruto / Stitch / Stitch Rosa + Boneco Angel / Super Mario</p><p><br></p><p>1 -Ovo - 80Gr</p><p>1 - Palitos Crocante</p><p>1 - Mochila</p><p>1 - Copo</p><p>1 - Bolinha Supresa</p><p>1 - Brinquedo / Boneco </p><p><br></p><p>----------------------------------------------------------------------//------------------------------------------------------------------------------</p><p><br></p><p>Patrulha Canina Rosa+ Kit C/ Maquiagem </p><p><br></p><p>1 -Ovo - 80Gr</p><p>1 - Palitos Crocante</p><p>1 - Mochila</p><p>1 - Copo </p><p>1 - Kit Maquiagem</p><p>1 - Tiara de Orelhinha c/ Glitter</p><p>1 - Coração com Colarzinho Infantil c/ Pingente.</p><p><br></p><p>----------------------------------------------------------------------//------------------------------------------------------------------------------</p><p><br></p><p>(Patrulha Canina Mochila Azul + Copo + Bola Surpresa) </p><p><br></p><p>1 -Ovo - 80Gr</p><p>1 - Palitos Crocante</p><p>1 - Mochila</p><p>1 - Copo </p><p>1 - Bola Surpresa</p><p><br></p><p><br></p><p>*Kit acompanha todos os itens, conforme a foto de cada variação.</p><p>*O biscoito será enviado conforme disponíbilidade, podendo alternar em embalagem e sabor, envio padrão para menino e menina (chocolate / brigadeiro).</p><p><br></p><p>ISOPOR TÉRMICO: Garante a proteção mantem a temperatura ideal e integridade do seu ovo de Páscoa, preservando o sabor e a textura do chocolate, evitando quebras e danos durante o transporte.</p>', 37.62, 62.7, 24, 'https://cf.shopee.com.br/file/br-11134207-81zuo-ml3q2c2o4rgh59', '{https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.14232249254638674.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.4921344949876696.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.12344100980506434.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.07967809507626189.webp,https://smfndfyuscgfjedeqysu.supabase.co/storage/v1/object/public/product-images/0.31401498497928426.webp}', NULL, 'ENS MIX ', 'https://s.shopee.com.br/9ztFvt4jKR', 4.8, 0, 0, true, NULL, '2026-03-24 11:55:32.530478+00', '2026-03-24 22:22:32.6716+00', NULL, NULL, '5a54bf84-4707-4f0f-a23c-689469fdbbb7', 'br-11110105-6v65f-ml3q4nd5tn9fed.16000081771947901', 40.0, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'a0822333-17b8-40d1-acbb-c0401eb81fcf', NULL, 3, 269, '[]', NULL, '{}');
INSERT INTO public.products VALUES ('c0fc85ce-20f0-4ca2-87fc-035992a27bd3', 'Creatina Pura 1kg Dark Lab Monohidratada 100% de Pureza, Sem Sabor', 'FORÇA MÁXIMA: Creatina monohidratada com 100% de pureza que aumenta força, resistência e explosão muscular para treinos de alta intensidade
QUALIDADE SUPERIOR: Matéria-prima de qualidade com variação mínima, garantindo máxima pureza e absorção rápida
EVOLUÇÃO CONTÍNUA: Desenvolvida para atletas e praticantes de musculação que buscam massa magra e recuperação acelerada
MODO DE USO: Dissolva 3g (1 dosador raso) em 150ml de água, consuma 30 minutos antes do treino para energia e disposição máxima
DOMINE O TREINO: Dark Lab desde 2018 desenvolvendo fórmulas exclusivas com matérias-primas rigorosamente selecionadas para máxima qualidade e resultados reais', 69.9, 99.9, 30, 'https://m.media-amazon.com/images/I/71rzVRssGZL._AC_SL1500_.jpg', '{https://m.media-amazon.com/images/I/71rzVRssGZL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71HcBLVVYbL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71bNxfsDUPL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71T5-sIy9+L._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/719oCMl26eL._AC_SL1500_.jpg}', NULL, 'Dark Lab', 'https://amzn.to/4c1zTUu', 5, 0, 8, true, NULL, '2026-03-24 05:23:00.692898+00', '2026-03-26 16:30:31.344312+00', 'cdff3214-2d21-4fbe-afc3-cade5080b0f0', 'de5d95db-6213-402f-84ef-2c88736e1ab1', '31640105-56f9-43ab-8204-465c8717d731', NULL, 30.0, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'fd868bd5-d65d-4c62-8d3f-68597eef93e6', 'B0CDNJ3S3D', 13, 10000, '[{"name": "Marca", "value": "Dark Lab"}, {"name": "Sabor", "value": "Sem sabor"}, {"name": "Tipo de suplemento primário", "value": "Creatina"}, {"name": "Contagem de unidades", "value": "1.0 unidade"}, {"name": "Forma do produto", "value": "Pó"}, {"name": "Peso do produto", "value": "2,2 Libras"}, {"name": "Dimensões do item C x L x A", "value": "24 x 11 x 40 centímetros"}, {"name": "Faixa etária (descrição)", "value": "Adulto"}, {"name": "Número de itens", "value": "1"}, {"name": "Cor", "value": "N/a"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Sexta-feira, 27 de Março Sexta-feira, 27 de Março Entrega GRÁTIS: Sexta-feira, 27 de Março Sexta-feira, 27 de Março"}');
INSERT INTO public.products VALUES ('2b2649bf-137c-4614-b2ed-9e7879872492', 'JBL, Fone de Ouvido On ear, Headphone, Tune 520BT, Sem Fio - Preto', 'PODEROSO PURE BASS. O JBL Tune 520BT apresenta o renomado som JBL Pure Bass, o mesmo que toca nos locais mais famosos em todo o mundo.
TECNOLOGIA BLUETOOTH. Transmita sem fio som de alta qualidade de seu smartphone sem cabos bagunçados com a ajuda da mais recente tecnologia Bluetooth.
PERSONALIZE SUA MÚSICA. Baixe o aplicativo gratuito JBL Headphones para personalizar o som de acordo com o seu gosto com o EQ. Os comandos de voz em seu idioma guiam você pelos recursos do Tune 520BT.
ATÉ 57 HORAS DE BATERIA. Ouça suas músicas preferidas sem fio por até 57 horas, e recarregue a bateria completa com 2 horas. Você pode obter 3 horas de música adicionais com uma carga rápida de 5 minutos.
LEVE E CONFORTÁVEL. O material leve e compacto proporcionam um uso confortável no seu dia a dia, com seu design dobrável é possível levar seu fone para qualquer lugar, dentro de uma mala de viagem ou uma mochila.', 179.1, 299, 40, 'https://m.media-amazon.com/images/I/51olNZRjn+L._AC_SL1500_.jpg', '{https://m.media-amazon.com/images/I/51olNZRjn+L._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/61sEBNIts8L._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71IHCVFb1vL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/61IEx-7XC3L._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/615mvQ5fvhL._AC_SL1500_.jpg}', NULL, 'JBL', 'https://amzn.to/3Npu0r2', 5, 0, 2, true, NULL, '2026-03-26 15:48:53.711203+00', '2026-03-26 16:10:03.048248+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 40.1, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', 'B0C3V5X3QT', 8, NULL, '[{"name": "Marca", "value": "JBL"}, {"name": "Cor", "value": "Preto"}, {"name": "Colocação na orelha", "value": "Extra-auriculares"}, {"name": "Fator de forma dos fones de ouvido", "value": "Extra-auriculares"}, {"name": "Impedância", "value": "32 Ohms"}]', NULL, '{"prime": false, "shipping_details": "Consultar frete"}');
INSERT INTO public.products VALUES ('3dbbbda2-0da3-4eb5-8452-928abf2a902d', 'Kit Tratamento Capilar L''Oréal Paris Elseve Glycolic Gloss, Combate Porosidade, 5 Produtos para Brilho e Alinhamento', 'Oferece um tratamento de 5 passos que combate a porosidade dos fios e sela as cutículas, revelando um cabelo visivelmente saudável e alinhado.
Fórmula com pH ácido e enriquecida com Ácido Glicólico preenche as falhas da fibra capilar e lamina a superfície para refletir a luz intensamente, garantindo um brilho único.
Cabelo com 3X mais gloss, com um brilho espelhado que resiste por até 6 lavagens, mantendo a maciez e o alinhamento dos fios por muito mais tempo.
O sérum finalizador com filtro UV protege contra agressões futuras, controla a oleosidade e prolonga o efeito gloss por até 72 horas, sem pesar nos fios.
Tratamento completo que limpa, condiciona, trata, acidifica e finaliza para a máxima performance de brilho e saúde capilar em um único e prático kit para sua rotina.', 99.9, 185.29, 46, 'https://m.media-amazon.com/images/I/81l32aDwFxL._AC_SL1500_.jpg', '{https://m.media-amazon.com/images/I/81l32aDwFxL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/71b8NRn8DWL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/814L8CEUTaL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/81qWbLTZdPL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/81HB2ufGcJL._AC_SL1500_.jpg}', 'Oferta', 'ELSEVE', 'https://amzn.to/4bNuGP4', 5, 0, 3, true, NULL, '2026-03-26 14:23:37.937102+00', '2026-03-26 17:03:32.56576+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 46.1, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '95a00be7-7f36-4590-a2d9-f78cd0a12689', 'B0CZY1N1JY', 13, 4000, '[{"name": "Marca", "value": "ELSEVE"}, {"name": "Tipo de cabelo", "value": "Todos os tipos de cabelo"}, {"name": "Vantagens do produto", "value": "Benefícios: - Promove uma limpeza profunda dos fios. - Combate a porosidade, trazendo mais brilho gloss para o cabelo. - Sela intensamente os fios, preenchendo as falhas da fibra capilar. - Na superfície, lamina a cutícula, alinhando-a para refletir a luz. Benefícios: - Promove uma limpeza profunda dos fios. - Combate a porosidade, trazendo mais brilho gloss para o cabelo. - Sela intensamente os fios, preenchendo as falhas da fibra capilar. - Na superfície, lamina a cutícula, alinhando-a para refletir a luz.Benefícios: - Promove uma limpeza profunda dos fios. - Combate a porosidade, trazendo mais brilho gloss para o cabelo. - Sela intensamente os fios, preenchendo as falhas da fibra capilar. - Na superfície, lamina a cutícula, alinhando-a para refletir a luz. Ver mais"}, {"name": "Forma do produto", "value": "Sérum"}, {"name": "Aroma", "value": "Morango"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Domingo, 29 de Março Domingo, 29 de Março Entrega GRÁTIS: Domingo, 29 de Março Domingo, 29 de Março"}');
INSERT INTO public.products VALUES ('8e10d48e-849f-46c2-9457-fb7369e28706', 'Echo Dot (Geração mais recente) | Smart speaker com Alexa, som vibrante e potente, Wi-Fi e Bluetooth | Cor Branca', 'SOM VIBRANTE E POTENTE - Experimente um áudio aprimorado — vocais mais nítidos, graves mais potentes — para uma experiência Echo Dot ainda mais imersiva.
SUAS MÚSICAS E CONTEÚDOS FAVORITOS - Reproduza músicas e podcasts do Amazon Music, Apple Music, Spotify, entre outros, ou por Bluetooth em todos os ambientes da sua casa.
SEMPRE DISPONÍVEL PARA AJUDAR - Pergunte a previsão do tempo para Alexa, defina timers com sua voz, obtenha respostas e ouça piadas. Precisa de mais uns minutinhos de sono pela manhã? É só tocar no seu Echo Dot para adiar o alarme.
MAIS CONFORTO EM CASA - Controle dispositivos de casa inteligente compatíveis por voz ou com rotinas ativadas por sensores de temperatura internos. Crie rotinas para ligar o ar condicionado se a temperatura interna estiver mais quente que o ideal.
DESENVOLVIDO PARA PROTEGER A SUA PRIVACIDADE - A Amazon não vende informações pessoais de clientes. O Echo Dot foi construído com várias camadas de controles de privacidade, incluindo o botão de desligar o microfone.
APROVEITE AO MÁXIMO O PAREAMENTO DE DISPOSITIVOS - Escute música na casa toda usando os dispositivos Echo compatíveis em cômodos diferentes ou crie um sistema de home theater com o Fire TV.', 398.99, 459, NULL, 'https://m.media-amazon.com/images/I/61aCuWauwBL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/61aCuWauwBL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/71YVBa7zc5L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/714sfYxbcaL._AC_SL1500_.jpg,https://m.media-amazon.com/images/I/51EkhvTiC+L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61HdGRY5wqL._AC_SL1000_.jpg}', NULL, 'Amazon', 'https://amzn.to/4bPQtFS', 4.8, 0, 1, true, NULL, '2026-03-26 15:51:33.054562+00', '2026-03-26 15:59:04.712769+00', 'ef395dcf-cccc-4966-938e-0aa7d16f6d0f', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 13.1, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '3ef27b40-a2db-4664-abe6-7a1cccd8e9a3', 'B09B8XVSDP', 9.5, 1000, NULL, NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Amanhã, 27 de Março Amanhã, 27 de Março"}');
INSERT INTO public.products VALUES ('854666ec-2a9c-469a-abf2-90da03304e86', 'Smartwatch Samsung Galaxy Fit3 Display 1.6" Grafite', 'Para começar a usar o Galaxy Fit3, uma conta Samsung deve estar cadastrada em seu celular. Seus dados de saúde no seu Galaxy Fit3 serão transferidos com segurança e armazenados na Samsung Cloud conectada à sua conta, para que você possa acessar e gerenciar totalmente seus dados.
Quando a bateria estiver completamente descarregada, o Fit não ligará. Carregue totalmente o bateria antes de ligar o Fit.
A tela sensível ao toque pode funcionar mal em condições úmidas ou quando exposta à água.', 299, 599, NULL, 'https://m.media-amazon.com/images/I/51bjAlTBzZL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/51bjAlTBzZL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/51PDb6meDaL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61iDPAYyN8L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/618XpoF1MBL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61FzO3l2yeL._AC_SL1000_.jpg}', NULL, 'Samsung', 'https://amzn.to/4tcXEyN', 5, 0, 0, true, NULL, '2026-03-26 22:22:22.381254+00', '2026-03-26 22:23:03.819605+00', '73fc119a-b8cb-4e2a-b3e2-c42abc9ce67c', NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 50.1, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '4b889f34-2be4-4625-ba50-2f84028d3673', 'B0CVCLGV1W', NULL, 3000, '[{"name": "Características especiais", "value": "Leve"}, {"name": "Capacidade da bateria", "value": "3000 Milliamp Hours"}, {"name": "Tecnologia de conectividade", "value": "Bluetooth, Wi-Fi"}, {"name": "Padrão de comunicação sem fio", "value": "Bluetooth"}, {"name": "Composição das células da bateria", "value": "Íon-lítio"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Amanhã, 27 de Março. Se pedir dentro de 4 hrs 7 mins Amanhã, 27 de Março4 hrs 7 mins Entrega GRÁTIS: Segunda-feira, 30 de Março. Se pedir dentro de 9 hrs 52 mins Segunda-feira, 30 de Março9 hrs 52 mins"}');
INSERT INTO public.products VALUES ('177c4305-2669-48c3-b11f-37943399a858', 'Kit de Bolas Sensoriais para Bebê – Texturas Educativas, Estímulo Motor e Cores Suaves – Silicone Macio Atóxico – Aprendizado e Diversão a Partir de 3 Meses', 'DESENVOLVIMENTO SENSORIAL – Bolas com texturas únicas que estimulam tato, visão e coordenação motora do bebê desde os primeiros meses.
MATERIAL SEGURO E MACIO – Produzidas em silicone atóxico, livre de BPA, resistente e suave para apertar e morder durante a dentição.
FUNCIONALIDADE EDUCATIVA – Formatos e relevos ajudam no aprendizado, fortalecem a preensão e despertam curiosidade com brincadeiras simples.
USO VERSÁTIL – Ideal para brincar, segurar, apertar, morder, rolar, explorar sensações e usar em atividades de terapia ocupacional infantil.
CONFIANÇA E QUALIDADE – Produto testado, seguro para bebês e com garantia de satisfação. Caso não goste, oferecemos troca rápida e sem burocracia.', 57.62, 67.35, NULL, 'https://m.media-amazon.com/images/I/61Ea2l952vL._AC_SL1080_.jpg', '{https://m.media-amazon.com/images/I/61Ea2l952vL._AC_SL1080_.jpg,https://m.media-amazon.com/images/I/510g8Nqq6wL._AC_SL1080_.jpg,https://m.media-amazon.com/images/I/61my47fpsHL._AC_SL1080_.jpg,https://m.media-amazon.com/images/I/512nUFOUY-L._AC_SL1080_.jpg,https://m.media-amazon.com/images/I/51XeuyxQz5L._AC_SL1080_.jpg}', NULL, 'Mercado Livre', 'https://amzn.to/4bJOSTf', 5, 0, 0, true, NULL, '2026-03-26 22:49:20.328942+00', '2026-03-26 22:50:13.900062+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 14.4, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'd1baff6d-2ffd-4dba-be65-17296065b247', 'B0G23Q2WK3', 8, 300, '[{"name": "Marca", "value": "Genérico"}, {"name": "Material", "value": "Plástico"}, {"name": "Cor", "value": "Multicores"}, {"name": "Faixa etária (descrição)", "value": "Bebê"}, {"name": "Esporte", "value": "Nao aplicavel"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Domingo, 29 de Março Domingo, 29 de Março"}');
INSERT INTO public.products VALUES ('a9f0ec91-fb56-44f0-a187-1d8f83ef165a', 'Sparta Maleta de ferramentas kit com 129 peças', 'Kit completo com 129 peças: Inclui chaves, soquetes, alicates, chaves de fenda e muito mais, oferecendo um kit de ferramentas completo para reparos no dia a dia.
Maleta organizadora prática: O Sparta kit de ferramentas com maleta mantém cada ferramenta no lugar, facilitando transporte, organização e armazenamento.
Ferramentas manuais versáteis: Ideal para consertos domésticos, manutenção automotiva, pequenos trabalhos em oficinas e projetos de bricolagem.
Construção durável e confiável: Todas as ferramentas são fabricadas em materiais resistentes, garantindo longa vida útil e desempenho consistente.
Praticidade em um único kit: Perfeito para quem procura um kit de ferramentas completa da Sparta, unindo qualidade, variedade e conveniência em uma só maleta.', 93.1, 133.51, NULL, 'https://m.media-amazon.com/images/I/61ZmjmMLsRL._AC_SL1000_.jpg', '{https://m.media-amazon.com/images/I/61ZmjmMLsRL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61lP59FsfYL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/51leWV4hz+L._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/61yxrSlz7kL._AC_SL1000_.jpg,https://m.media-amazon.com/images/I/610DbcuOTrL._AC_SL1000_.jpg}', NULL, 'SPARTA', 'https://amzn.to/4uUufuW', 4.7, 0, 2, true, NULL, '2026-03-26 22:18:11.470686+00', '2026-03-26 23:00:40.030579+00', NULL, NULL, '31640105-56f9-43ab-8204-465c8717d731', NULL, 30.3, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '863befde-b087-4dee-bc39-36e519b18a48', 'B076N2S8FV', 8, 2000, '[{"name": "Marca", "value": "SPARTA"}, {"name": "Material", "value": "Liga de aço, Plástico"}, {"name": "Cor", "value": "preto"}, {"name": "Dimensões do produto", "value": "25C x 3,5L x 31A centímetros"}, {"name": "Nível de resistência à água", "value": "Não resistente à água"}]', NULL, '{"prime": false, "shipping_details": "Entrega GRÁTIS: Amanhã, 27 de Março Amanhã, 27 de Março"}');


--
-- TOC entry 4812 (class 0 OID 17503)
-- Dependencies: 384
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.profiles VALUES ('b7e0081a-852f-46ab-b0f3-1247c18b2397', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'Giuliano Moretti', NULL, true, '2026-03-11 03:11:05.173222+00', '2026-03-11 03:25:19.240478+00', false, false);
INSERT INTO public.profiles VALUES ('ef98ce97-1083-46b9-b819-669565f1b66f', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'Amanda Cristine', NULL, true, '2026-03-16 20:09:55.9155+00', '2026-03-16 20:12:26.132363+00', false, false);
INSERT INTO public.profiles VALUES ('cb92d805-14fb-40c4-b3ec-e54509347a7e', '2374d4c0-d9a8-455f-925d-f42f42f3522d', 'Giuliano Moretti', NULL, true, '2026-03-15 18:38:51.97971+00', '2026-03-26 19:48:58.462058+00', true, true);


--
-- TOC entry 4817 (class 0 OID 17573)
-- Dependencies: 389
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reports VALUES ('eafdd758-e26c-4c60-b521-04ef42ff7418', '60467af5-058e-4e64-a766-f8d0889d0acb', 'giulianomsg@gmail.com', 'Oferta Expirada', 'resolved', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 02:48:01.868496+00');


--
-- TOC entry 4816 (class 0 OID 17557)
-- Dependencies: 388
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4842 (class 0 OID 27214)
-- Dependencies: 415
-- Data for Name: search_cache; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4835 (class 0 OID 25968)
-- Dependencies: 408
-- Data for Name: shopee_product_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shopee_product_mappings VALUES ('3df4038d-fd28-481f-bae1-37b905479a5b', '5ca3995f-eac6-4363-93fa-42b0c96761cf', '20099832859', '1351433975', '', 0.04, 'https://cf.shopee.com.br/file/sg-11134201-825zo-mjh92aoo20p09a', 'https://shopee.com.br/product/1351433975/20099832859', 'https://s.shopee.com.br/4VYIVJGoOb', '2026-03-24 22:22:29.311+00', 'active', '2026-03-23 22:42:11.264204+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [], "appNewRate": "0.04", "commission": "69.96", "webNewRate": "0.04", "appExistRate": "0.04", "webExistRate": "0.04", "productCatIds": [100013, 100073, 0], "priceDiscountRate": 42, "sellerCommissionRate": "0.01", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('2bdbd992-04ad-429d-b928-2fca43aa6e0c', '9016cde9-ce2b-4eef-9b4a-dfd1bd88d5aa', '23999329655', '833454980', '', 0.03, 'https://cf.shopee.com.br/file/sg-11134201-8261e-mkiyummn7v2c20', 'https://shopee.com.br/product/833454980/23999329655', 'https://s.shopee.com.br/7VBuxEXbHN', '2026-03-24 22:22:30.322+00', 'active', '2026-03-24 11:54:41.962587+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [], "appNewRate": "0.03", "commission": "0.5997", "webNewRate": "0.03", "appExistRate": "0.03", "webExistRate": "0.03", "productCatIds": [100629, 100646, 100786], "priceDiscountRate": 0, "sellerCommissionRate": "0", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('2639f275-a4fa-4f90-b8cc-7cc6c4f300e5', '8c9da536-3571-4884-adf2-53979297d96a', '58256122039', '1330516719', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-820lk-mld1czrwwvlz0e', 'https://shopee.com.br/product/1330516719/58256122039', 'https://s.shopee.com.br/6KzxZ9IglZ', '2026-03-24 22:22:30.827+00', 'active', '2026-03-24 11:55:16.142228+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [], "appNewRate": "0.03", "commission": "0.9894", "webNewRate": "0.03", "appExistRate": "0.03", "webExistRate": "0.03", "productCatIds": [100629, 100646, 100786], "priceDiscountRate": 0, "sellerCommissionRate": "0", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('a77aa47d-7f86-4338-9f0f-d95e20f6faf8', '28d1f05e-c067-4725-a756-54448e085c8d', '20798548218', '900960477', '', 0.53, 'https://cf.shopee.com.br/file/br-11134207-7qukw-lh9n45zmoho5f7', 'https://shopee.com.br/product/900960477/20798548218', 'https://s.shopee.com.br/3LMKVvH6SC', '2026-03-24 22:22:31.838+00', 'active', '2026-03-23 13:40:38.41194+00', '2026-03-14 12:40:00+00', '2999-12-31 15:59:59+00', '{"shopType": [2], "appNewRate": "0.53", "commission": "6.307", "webNewRate": "0.53", "appExistRate": "0.53", "webExistRate": "0.53", "productCatIds": [100636, 100718, 101243], "priceDiscountRate": 60, "sellerCommissionRate": "0.5", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('2d432182-add5-45cd-a33b-a8f17353ed91', '0813c095-39ff-46cc-a5f7-756c8c75f2d6', '18798270826', '1404215442', '', 0.11, 'https://cf.shopee.com.br/file/sg-11134201-7rav5-mau2af5mj0b49f', 'https://shopee.com.br/product/1404215442/18798270826', 'https://s.shopee.com.br/4VYIC7Mkii', '2026-03-24 22:22:32.313+00', 'active', '2026-03-23 18:02:39.44353+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [1], "appNewRate": "0.11", "commission": "7.7979", "webNewRate": "0.11", "appExistRate": "0.11", "webExistRate": "0.11", "productCatIds": [100636, 100718, 101244], "priceDiscountRate": 53, "sellerCommissionRate": "0.08", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('3122e513-ee30-4b00-91a4-f46f828f605d', 'ddb4a64b-3797-4277-9cf1-2322ca0a7f2e', '23997332426', '274429594', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-81zuo-ml3q2c2o4rgh59', 'https://shopee.com.br/product/274429594/23997332426', 'https://s.shopee.com.br/9ztFvt4jKR', '2026-03-24 22:22:32.781+00', 'active', '2026-03-24 11:55:33.410277+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [2], "appNewRate": "0.03", "commission": "1.701", "webNewRate": "0.03", "appExistRate": "0.03", "webExistRate": "0.03", "productCatIds": [100629, 100646, 100786], "priceDiscountRate": 40, "sellerCommissionRate": "0", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('35385e36-165b-49da-b5be-6c93f83c4440', '8d949db7-5014-46e5-8398-24d545ad995b', '23494386892', '346079402', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-81ztc-mjaae4ds39qafc', 'https://shopee.com.br/product/346079402/23494386892', 'https://s.shopee.com.br/2LTpD6TQ7O', '2026-03-24 22:22:33.285+00', 'active', '2026-03-24 18:03:40.448593+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [], "appNewRate": "0.03", "commission": "0.5097", "webNewRate": "0.03", "appExistRate": "0.03", "webExistRate": "0.03", "productCatIds": [100637, 100727, 101311], "priceDiscountRate": 58, "sellerCommissionRate": "0", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('e972b1a1-ad88-4b11-be5c-9fa8e46b4b86', 'bb49bd4a-ab48-4bdf-a702-8c108cd3ab3e', '22199186045', '1499852820', '', 0.1, 'https://cf.shopee.com.br/file/sg-11134201-821ez-mgq7x2bpxibxd7', 'https://shopee.com.br/product/1499852820/22199186045', 'https://s.shopee.com.br/5L7R2vMloF', '2026-03-24 22:22:33.765+00', 'active', '2026-03-24 22:01:11.553993+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [], "appNewRate": "0.1", "commission": "2.19", "webNewRate": "0.1", "appExistRate": "0.1", "webExistRate": "0.1", "productCatIds": [100636, 100717, 101220], "priceDiscountRate": 48, "sellerCommissionRate": "0.07", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('5a254587-3403-4229-84f6-411503f0127b', 'cbe4fef6-d959-449f-bb05-07ab8a84d026', '22693482091', '415175805', '', 0.11, 'https://cf.shopee.com.br/file/sg-11134201-7rdx1-m1egwx31u1x61f', 'https://shopee.com.br/product/415175805/22693482091', 'https://s.shopee.com.br/LilE9K8GI', '2026-03-25 00:04:24.932094+00', 'active', '2026-03-25 00:04:24.932094+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [2], "appNewRate": "0.11", "commission": "3.19", "webNewRate": "0.11", "appExistRate": "0.11", "webExistRate": "0.11", "productCatIds": [100636, 100717, 101226], "priceDiscountRate": 71, "sellerCommissionRate": "0.08", "shopeeCommissionRate": "0.03"}');
INSERT INTO public.shopee_product_mappings VALUES ('59c6a0a3-9088-436a-a4d9-95e85ac08556', 'fdcf0f14-b63d-42e0-ae79-ac2552282bf6', '26980788215', '1350045638', '', 0.11, 'https://cf.shopee.com.br/file/br-11134207-81ztc-mj2ddyi3zfgi6a', 'https://shopee.com.br/product/1350045638/26980788215', 'https://s.shopee.com.br/1gE9fpfXee', '2026-03-25 12:58:49.612343+00', 'active', '2026-03-25 12:58:49.612343+00', '2026-03-25 03:00:00+00', '2026-03-26 02:59:59+00', '{"shopType": [2], "appNewRate": "0.11", "commission": "4.3978", "webNewRate": "0.11", "appExistRate": "0.11", "webExistRate": "0.11", "productCatIds": [100636, 100718, 101241], "priceDiscountRate": 50, "sellerCommissionRate": "0.05", "shopeeCommissionRate": "0.06"}');
INSERT INTO public.shopee_product_mappings VALUES ('5edec2c5-afd0-4cd8-962b-0e8a2b8cf7a3', '41e3e392-9d32-42a4-9afc-12a4bfcfda9d', '22399156177', '455761217', '', 0.1, 'https://cf.shopee.com.br/file/br-11134207-81z1k-mgi9czkdqgp101', 'https://shopee.com.br/product/455761217/22399156177', 'https://s.shopee.com.br/9pZrdwfbFS', '2026-03-25 16:39:58.200087+00', 'active', '2026-03-25 16:39:58.200087+00', '2026-03-25 03:00:00+00', '2026-03-26 02:59:59+00', '{"shopType": [2], "appNewRate": "0.1", "commission": "69.999", "webNewRate": "0.1", "appExistRate": "0.1", "webExistRate": "0.1", "productCatIds": [100010, 100041, 100194], "priceDiscountRate": 15, "sellerCommissionRate": "0.04", "shopeeCommissionRate": "0.06"}');
INSERT INTO public.shopee_product_mappings VALUES ('b5417e90-bef4-48cd-b108-05bb25bfa121', '6e60439d-bb86-4de1-a6a3-a450669e31da', '20798265196', '1264013824', '', 0.36, 'https://cf.shopee.com.br/file/sg-11134201-7ra11-mba5kx8345u8b8', 'https://shopee.com.br/product/1264013824/20798265196', 'https://s.shopee.com.br/10yT98Z5BL', '2026-03-25 16:59:26.365513+00', 'active', '2026-03-25 16:59:26.365513+00', '2026-03-25 03:00:00+00', '2026-03-26 02:59:59+00', '{"shopType": [2], "appNewRate": "0.36", "commission": "21.5892", "webNewRate": "0.36", "appExistRate": "0.36", "webExistRate": "0.36", "productCatIds": [100001, 100018, 100121], "priceDiscountRate": 22, "sellerCommissionRate": "0.3", "shopeeCommissionRate": "0.06"}');
INSERT INTO public.shopee_product_mappings VALUES ('45d5a5e9-4920-4be9-8094-4d0a842b2b15', '0722cf53-1ac7-4c08-9cfb-8c677201c8ba', '23693742512', '1399886990', '', 0.03, 'https://cf.shopee.com.br/file/br-11134207-7r98o-m6ssruqg9dtc5a', 'https://shopee.com.br/product/1399886990/23693742512', 'https://s.shopee.com.br/7VByrR3aca', '2026-03-26 22:41:54.282192+00', 'active', '2026-03-26 22:41:54.282192+00', '2025-12-01 03:00:00+00', '2999-12-31 15:59:59+00', '{"shopType": [], "appNewRate": "0.03", "commission": "53.3997", "webNewRate": "0.03", "appExistRate": "0.03", "webExistRate": "0.03", "productCatIds": [100013, 100073, 0], "priceDiscountRate": 0, "sellerCommissionRate": "0", "shopeeCommissionRate": "0.03"}');


--
-- TOC entry 4836 (class 0 OID 25986)
-- Dependencies: 409
-- Data for Name: shopee_sync_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.shopee_sync_logs VALUES ('370ce73f-5c53-4e1e-972f-07b359aa654f', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:22:52.227811+00', '2026-03-21 20:22:53.918+00');
INSERT INTO public.shopee_sync_logs VALUES ('ec843577-005a-4ada-b439-91630347a3ff', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:35:17.558954+00', '2026-03-21 20:35:19.486+00');
INSERT INTO public.shopee_sync_logs VALUES ('97fbb552-086d-4918-9e1b-825e3b1a10a1', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:46:43.224901+00', '2026-03-21 20:46:43.105+00');
INSERT INTO public.shopee_sync_logs VALUES ('17169d30-876f-473f-8d79-069bcb06e11a', 'batch_sync', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:47:39.263396+00', '2026-03-21 20:47:41.219+00');
INSERT INTO public.shopee_sync_logs VALUES ('b0ce2e31-45f0-4d55-8868-b712a5a62a37', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 21:27:47.023185+00', '2026-03-21 21:27:46.903+00');
INSERT INTO public.shopee_sync_logs VALUES ('c613f4af-2932-42fa-b7c4-a691d170abc4', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 13:40:38.67976+00', '2026-03-23 13:40:38.541+00');
INSERT INTO public.shopee_sync_logs VALUES ('a6c6b455-10cf-4bd4-996e-7d67d00cbb1b', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 18:02:39.704748+00', '2026-03-23 18:02:39.575+00');
INSERT INTO public.shopee_sync_logs VALUES ('bd80f118-d5c6-482e-9858-852edd0c9516', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:42:11.444011+00', '2026-03-23 22:42:11.343+00');
INSERT INTO public.shopee_sync_logs VALUES ('2a3be8be-8fd4-471d-94ed-ab5d554b8524', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 11:51:24.240871+00', '2026-03-24 11:51:24.095+00');
INSERT INTO public.shopee_sync_logs VALUES ('10def2c1-b692-470e-8d7a-292a0738e8e4', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 11:54:42.218761+00', '2026-03-24 11:54:42.088+00');
INSERT INTO public.shopee_sync_logs VALUES ('ef0feabb-ff26-44a1-bbbb-a1856cded5f1', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 11:55:16.422374+00', '2026-03-24 11:55:16.269+00');
INSERT INTO public.shopee_sync_logs VALUES ('ef59fcab-13a1-43b7-9c52-6253b456121a', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:11:16.86732+00', '2026-03-21 19:11:16.729+00');
INSERT INTO public.shopee_sync_logs VALUES ('97c67fbe-74ba-459c-8844-4473638b6c8c', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:11:46.996389+00', '2026-03-21 19:11:48.11+00');
INSERT INTO public.shopee_sync_logs VALUES ('077b472e-748d-463e-b2d5-37eb9c508ca8', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:31:22.807529+00', '2026-03-21 19:31:24.649+00');
INSERT INTO public.shopee_sync_logs VALUES ('e86daf78-4f5d-4317-8405-a68e58971395', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:32:50.034327+00', '2026-03-21 19:32:51.217+00');
INSERT INTO public.shopee_sync_logs VALUES ('34afefe1-2907-4b54-b6a0-de4a654e6066', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:33:57.796871+00', '2026-03-21 19:33:57.675+00');
INSERT INTO public.shopee_sync_logs VALUES ('92f9ae1f-9048-4a7a-b206-d3b748db2d8b', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:34:42.383385+00', '2026-03-21 19:34:43.532+00');
INSERT INTO public.shopee_sync_logs VALUES ('38df8aec-8098-43ce-a950-0230a34bbb91', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:47:04.487997+00', '2026-03-21 19:47:05.603+00');
INSERT INTO public.shopee_sync_logs VALUES ('519c6573-f9db-42e5-960c-bc2edb46b409', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:47:32.197663+00', '2026-03-21 19:47:32.072+00');
INSERT INTO public.shopee_sync_logs VALUES ('c2899586-d4ab-46c8-b0bb-bd467108c785', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 19:48:37.772698+00', '2026-03-21 19:48:38.909+00');
INSERT INTO public.shopee_sync_logs VALUES ('e7759329-785b-4281-aef5-97c43c9540f9', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:01:52.79235+00', '2026-03-21 20:01:53.958+00');
INSERT INTO public.shopee_sync_logs VALUES ('372c8e0f-150a-43f0-85fa-c3e2bb0c107e', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:08:55.868957+00', '2026-03-21 20:08:57.055+00');
INSERT INTO public.shopee_sync_logs VALUES ('eb091570-35de-4a9d-b06b-b44aaac89f45', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:09:31.398124+00', '2026-03-21 20:09:32.507+00');
INSERT INTO public.shopee_sync_logs VALUES ('f7f998e0-cfaa-4b01-b994-d12e7014ac4c', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:12:33.32766+00', '2026-03-21 20:12:34.498+00');
INSERT INTO public.shopee_sync_logs VALUES ('eb3accfc-5eb9-43f5-a12b-ceaf089e5217', 'batch_sync', 'success', 1, 0, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:15:30.888882+00', '2026-03-21 20:15:32.083+00');
INSERT INTO public.shopee_sync_logs VALUES ('351ec0b3-0e6c-40e5-b69e-5edb33f84677', 'batch_sync', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 20:17:47.330356+00', '2026-03-21 20:17:49.276+00');
INSERT INTO public.shopee_sync_logs VALUES ('a5195df5-5565-4f4c-93ed-0c0305663053', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 11:55:33.64238+00', '2026-03-24 11:55:33.515+00');
INSERT INTO public.shopee_sync_logs VALUES ('12aaeb61-665d-46f5-a9a4-74433017b3ad', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 18:03:03.694728+00', '2026-03-24 18:03:03.559+00');
INSERT INTO public.shopee_sync_logs VALUES ('cab12b25-1d26-4e03-9bf7-a38ceaeed908', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 18:03:41.197112+00', '2026-03-24 18:03:40.573+00');
INSERT INTO public.shopee_sync_logs VALUES ('728d29f6-fd4b-47d7-a256-19ca418fd251', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 22:01:11.808285+00', '2026-03-24 22:01:11.666+00');
INSERT INTO public.shopee_sync_logs VALUES ('e0f494f3-5bfa-4f7f-b69e-2b9124e066fc', 'batch_sync', 'success', 9, 9, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 22:22:27.241811+00', '2026-03-24 22:22:33.997+00');
INSERT INTO public.shopee_sync_logs VALUES ('b5afb014-bc56-48fc-ad92-9d75a18c8221', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:04:25.222895+00', '2026-03-25 00:04:25.057+00');
INSERT INTO public.shopee_sync_logs VALUES ('1eccb6f2-0c23-4b99-bfcb-5b5322b3735e', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 11:14:11.455903+00', '2026-03-25 11:14:11.31+00');
INSERT INTO public.shopee_sync_logs VALUES ('6647df13-4896-4ac0-9545-244ecbafca73', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 12:58:49.864658+00', '2026-03-25 12:58:49.72+00');
INSERT INTO public.shopee_sync_logs VALUES ('f09bccf7-b4da-4016-b143-7f7dde9af769', 'import', 'success', 1, 1, 0, NULL, 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 16:13:29.48601+00', '2026-03-25 16:13:29.349+00');
INSERT INTO public.shopee_sync_logs VALUES ('f0412514-90f2-490f-adfc-ad7733d59aaa', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-25 16:39:58.438081+00', '2026-03-25 16:39:58.308+00');
INSERT INTO public.shopee_sync_logs VALUES ('28e7155b-5edf-49c7-8846-e32b1190886a', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-25 16:59:26.587267+00', '2026-03-25 16:59:26.47+00');
INSERT INTO public.shopee_sync_logs VALUES ('a9e6e882-1e36-43f4-8066-c07e90f215ec', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-26 22:32:35.280016+00', '2026-03-26 22:32:35.1+00');
INSERT INTO public.shopee_sync_logs VALUES ('df57aa2d-b7f9-4aa0-b484-5fa4e4efb8d1', 'import', 'success', 1, 1, 0, NULL, '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-26 22:41:54.564902+00', '2026-03-26 22:41:54.407+00');


--
-- TOC entry 4823 (class 0 OID 22202)
-- Dependencies: 396
-- Data for Name: special_page_products; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 4822 (class 0 OID 22188)
-- Dependencies: 395
-- Data for Name: special_pages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.special_pages VALUES ('5a8f37c3-a33e-4cd3-8821-78e4c6d56d52', 'Semana do Consumidor', 'consumidor', 'até 70% de desconto em vários sites', true, '2026-03-16 03:23:48.332605+00');
INSERT INTO public.special_pages VALUES ('c99dd6b1-8059-4b02-b4e1-720aac17197a', 'Especial de Páscoa', 'especial/pascoa', NULL, true, '2026-03-24 11:48:45.201732+00');


--
-- TOC entry 4813 (class 0 OID 17516)
-- Dependencies: 385
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_roles VALUES ('fef04994-7b82-4b30-ac35-b4975b6f52e2', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', 'admin');
INSERT INTO public.user_roles VALUES ('4359e1c4-e418-4b54-ad2d-2bfc32ff2bee', '2374d4c0-d9a8-455f-925d-f42f42f3522d', 'viewer');
INSERT INTO public.user_roles VALUES ('2f58229a-0be1-4751-9761-bf69ba943081', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', 'admin');


--
-- TOC entry 4824 (class 0 OID 22222)
-- Dependencies: 397
-- Data for Name: whatsapp_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.whatsapp_groups VALUES ('09713824-9960-43e5-a735-c0f62a661376', 'https://chat.whatsapp.com/GrfcPK6RHrl8GFeKhiEGkf', true, '2026-03-15 21:01:00.100735+00', 'Casa e Utilidades');
INSERT INTO public.whatsapp_groups VALUES ('674a19a5-17be-4c9c-9190-f2ee425c311d', 'https://chat.whatsapp.com/C90p6nXyhVzA8Fdt6DgiBW?mode=gi_t', true, '2026-03-16 00:45:19.873402+00', 'Eletrônicos');
INSERT INTO public.whatsapp_groups VALUES ('00f171ac-bac2-4150-9f2b-f6ee2cc2747e', 'https://chat.whatsapp.com/LHSciVHn9LfJXatzJjSWP2?mode=gi_t', true, '2026-03-24 05:31:07.075392+00', 'Mamães e Bebês');


--
-- TOC entry 4825 (class 0 OID 22234)
-- Dependencies: 398
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.wishlists VALUES ('bedddd52-12e8-4e26-8123-5bcc3fb373db', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '8e10d48e-849f-46c2-9457-fb7369e28706', '2026-03-26 19:42:24.217794+00');
INSERT INTO public.wishlists VALUES ('9b7bd2dd-4a5d-46ca-9d07-813c871e22f0', '2374d4c0-d9a8-455f-925d-f42f42f3522d', '8e10d48e-849f-46c2-9457-fb7369e28706', '2026-03-26 19:48:04.375307+00');


--
-- TOC entry 4844 (class 0 OID 29617)
-- Dependencies: 417
-- Data for Name: messages_2026_03_23; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4845 (class 0 OID 29629)
-- Dependencies: 418
-- Data for Name: messages_2026_03_24; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4846 (class 0 OID 29641)
-- Dependencies: 419
-- Data for Name: messages_2026_03_25; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4847 (class 0 OID 29653)
-- Dependencies: 420
-- Data for Name: messages_2026_03_26; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4848 (class 0 OID 29665)
-- Dependencies: 421
-- Data for Name: messages_2026_03_27; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4850 (class 0 OID 30848)
-- Dependencies: 423
-- Data for Name: messages_2026_03_28; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4851 (class 0 OID 31994)
-- Dependencies: 424
-- Data for Name: messages_2026_03_29; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4852 (class 0 OID 33147)
-- Dependencies: 425
-- Data for Name: messages_2026_03_30; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4801 (class 0 OID 17120)
-- Dependencies: 369
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
-- TOC entry 4803 (class 0 OID 17143)
-- Dependencies: 372
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--



--
-- TOC entry 4805 (class 0 OID 17167)
-- Dependencies: 374
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

INSERT INTO storage.buckets VALUES ('banners', 'banners', NULL, '2026-03-11 03:18:33.26887+00', '2026-03-11 03:18:33.26887+00', true, false, NULL, NULL, NULL, 'STANDARD');
INSERT INTO storage.buckets VALUES ('product-images', 'product-images', NULL, '2026-03-11 03:18:04.935894+00', '2026-03-11 03:18:04.935894+00', true, false, NULL, NULL, NULL, 'STANDARD');


--
-- TOC entry 4809 (class 0 OID 17286)
-- Dependencies: 378
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4810 (class 0 OID 17299)
-- Dependencies: 379
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4804 (class 0 OID 17159)
-- Dependencies: 373
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
-- TOC entry 4806 (class 0 OID 17177)
-- Dependencies: 375
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
INSERT INTO storage.objects VALUES ('576ad622-605a-4672-8f4c-3dc39b15867e', 'product-images', '0.17310964950050756.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 17:36:23.270718+00', '2026-03-25 17:36:23.270718+00', '2026-03-25 17:36:23.270718+00', '{"eTag": "\"3d22b15194de184cffb79c2436097aac\"", "size": 23750, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T17:36:24.000Z", "contentLength": 23750, "httpStatusCode": 200}', DEFAULT, 'fe3759b1-50d0-4d46-a75b-993239faa1c0', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
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
INSERT INTO storage.objects VALUES ('154c474a-aff6-4d66-b9f9-ff53415b2c35', 'product-images', '0.5859488048640895.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 17:36:23.402959+00', '2026-03-25 17:36:23.402959+00', '2026-03-25 17:36:23.402959+00', '{"eTag": "\"59fc0dc533f7fc3c7f31d1b240734629\"", "size": 64262, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T17:36:24.000Z", "contentLength": 64262, "httpStatusCode": 200}', DEFAULT, '233ca7f5-2255-4dce-bd1c-072dcef10c93', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
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
INSERT INTO storage.objects VALUES ('45e529c5-e184-4617-8090-17a15ec999c4', 'product-images', '1774477061250-9twfpfd2rea.jpeg', NULL, '2026-03-25 22:17:42.170322+00', '2026-03-25 22:17:42.170322+00', '2026-03-25 22:17:42.170322+00', '{"eTag": "\"bd01fbe33c15a6a6ec4610e732ebdb41\"", "size": 38098, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T22:17:43.000Z", "contentLength": 38098, "httpStatusCode": 200}', DEFAULT, '62e378b6-5464-402b-baeb-beabf9096017', NULL, '{}');
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
INSERT INTO storage.objects VALUES ('88e1d129-fda4-4226-a112-4b17250f2607', 'product-images', '1774291286536-wqh8aice5m.jpeg', NULL, '2026-03-23 18:41:27.69963+00', '2026-03-23 18:41:27.69963+00', '2026-03-23 18:41:27.69963+00', '{"eTag": "\"8f356ec074f3d8bc20f53c213cea07f0\"", "size": 104883, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T18:41:28.000Z", "contentLength": 104883, "httpStatusCode": 200}', DEFAULT, '70426f38-edc7-402e-9e98-02449b577b29', NULL, '{}');
INSERT INTO storage.objects VALUES ('7590e985-982d-486b-a03a-45e6e0a8405c', 'product-images', '0.3951931865428787.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 18:42:30.466932+00', '2026-03-23 18:42:30.466932+00', '2026-03-23 18:42:30.466932+00', '{"eTag": "\"033fb73077e31c49ab66ece1d59a3625\"", "size": 41313, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T18:42:31.000Z", "contentLength": 41313, "httpStatusCode": 200}', DEFAULT, '7386eeec-c0ae-4575-95d1-e1259b874692', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('49cea1fe-e409-4641-9562-dfec4070aa49', 'product-images', '0.2583498149717929.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:58:32.127907+00', '2026-03-19 17:58:32.127907+00', '2026-03-19 17:58:32.127907+00', '{"eTag": "\"387bbfb3bcb58846617037451813d56b\"", "size": 101313, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:58:33.000Z", "contentLength": 101313, "httpStatusCode": 200}', DEFAULT, '029ff0d5-dbf9-4cc4-ae52-f2ca3fcd5c7d', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a6382276-35de-4329-bb82-f41e6682e6d8', 'product-images', '0.2582148944815016.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:35.919239+00', '2026-03-16 20:32:35.919239+00', '2026-03-16 20:32:35.919239+00', '{"eTag": "\"6d769eba4bdc4d1805057ea92330931f\"", "size": 20040, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 20040, "httpStatusCode": 200}', DEFAULT, 'ae28849c-865b-4a66-94bd-51485b4b4945', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('931b80a3-555c-40df-b106-4844ab6c0f14', 'product-images', 'platform-1774059464441.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-21 02:18:22.025335+00', '2026-03-21 02:18:22.025335+00', '2026-03-21 02:18:22.025335+00', '{"eTag": "\"5ceddd19cf5b94d4d570f708ca23667a\"", "size": 24536, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-21T02:18:22.000Z", "contentLength": 24536, "httpStatusCode": 200}', DEFAULT, '2d69ec66-44f2-4cd9-850a-9fba4269e2e7', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('b37e05ef-c522-490b-8301-2e87aac20872', 'product-images', '0.46384725213935984.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:35.958356+00', '2026-03-16 20:32:35.958356+00', '2026-03-16 20:32:35.958356+00', '{"eTag": "\"eabf879e3337f1d11aae7db4c927a0b8\"", "size": 103954, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 103954, "httpStatusCode": 200}', DEFAULT, 'b2c1f70b-8082-4803-83e2-b65862817c8c', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f51aa2b5-7f2f-4ff6-b69e-b2d160e26af0', 'product-images', '0.32225771434351835.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:36.024796+00', '2026-03-16 20:32:36.024796+00', '2026-03-16 20:32:36.024796+00', '{"eTag": "\"4ca953e46b294bb6768d3c13e721854a\"", "size": 56040, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 56040, "httpStatusCode": 200}', DEFAULT, '76724ca1-81d7-4fcb-98ba-a0f1cc13557a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('305f7811-1173-498a-b967-fa6d01094520', 'product-images', '0.6514552209362939.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:36.084883+00', '2026-03-16 20:32:36.084883+00', '2026-03-16 20:32:36.084883+00', '{"eTag": "\"8082ce6f9625f706cfb1f5e60de259d8\"", "size": 47978, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:36.000Z", "contentLength": 47978, "httpStatusCode": 200}', DEFAULT, 'c16b76f9-0db1-44f3-a69d-5aefd16ac681', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('c0f85aee-fc10-4e70-aa67-cbc4ab955d9f', 'product-images', '0.7180593746971142.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 20:32:36.116735+00', '2026-03-16 20:32:36.116735+00', '2026-03-16 20:32:36.116735+00', '{"eTag": "\"9104921f97e4393312b6ee9ad99d47c8\"", "size": 84534, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T20:32:37.000Z", "contentLength": 84534, "httpStatusCode": 200}', DEFAULT, '30656878-1cbd-46f2-b829-590276827ae6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('42c256c3-853f-4ea8-b13b-a9cc4ff8d981', 'product-images', '1773704979886-lxnvgggtgc.jpeg', NULL, '2026-03-16 23:49:40.49449+00', '2026-03-16 23:49:40.49449+00', '2026-03-16 23:49:40.49449+00', '{"eTag": "\"4772f5c23aca370cf6aac3b77dcb8faf\"", "size": 29193, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:49:41.000Z", "contentLength": 29193, "httpStatusCode": 200}', DEFAULT, '5de952ba-cddc-4c8c-8e54-6eb1db854835', NULL, '{}');
INSERT INTO storage.objects VALUES ('b244dc92-e044-4ef9-bf8b-69fc3f752506', 'product-images', '0.10322008556880014.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 18:42:30.446794+00', '2026-03-23 18:42:30.446794+00', '2026-03-23 18:42:30.446794+00', '{"eTag": "\"7bb82140f0646cc7286ecd5399170933\"", "size": 58433, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T18:42:31.000Z", "contentLength": 58433, "httpStatusCode": 200}', DEFAULT, 'bddfd00e-39e2-4f22-b1b0-5c5fe5ebd619', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('733a6e42-060d-4638-a501-8ee25197cf37', 'product-images', '0.45270689894587335.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.176596+00', '2026-03-16 23:51:27.176596+00', '2026-03-16 23:51:27.176596+00', '{"eTag": "\"d23c8216bc8d72fae028d6a911dc8df6\"", "size": 4500, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 4500, "httpStatusCode": 200}', DEFAULT, '341c5ec7-95cb-41aa-96a4-c13cb0a5bc49', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('fd66e9a3-19a7-4024-8dde-1a9bbbc84904', 'product-images', '1774304870268-zsvtjej1q8.jpeg', NULL, '2026-03-23 22:27:51.477063+00', '2026-03-23 22:27:51.477063+00', '2026-03-23 22:27:51.477063+00', '{"eTag": "\"f68674550b0a2d135bd44428c2ccb2b4\"", "size": 162703, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:27:52.000Z", "contentLength": 162703, "httpStatusCode": 200}', DEFAULT, 'c5def275-c14d-4fc0-a8a7-42efce23e2d9', NULL, '{}');
INSERT INTO storage.objects VALUES ('1a42cb85-c6ea-4e35-9ee4-992a5ed8740c', 'product-images', '0.6152228301389535.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.650736+00', '2026-03-16 23:51:27.650736+00', '2026-03-16 23:51:27.650736+00', '{"eTag": "\"477af41260e53b8119cb33a58bd08194\"", "size": 23142, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 23142, "httpStatusCode": 200}', DEFAULT, 'aeb1f8e6-0a9c-434e-b8e3-33de0e934d0a', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('4a73908b-4ec9-4d65-b71d-9099928b5d39', 'product-images', '0.7851943107190276.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.831222+00', '2026-03-16 23:51:27.831222+00', '2026-03-16 23:51:27.831222+00', '{"eTag": "\"4772f5c23aca370cf6aac3b77dcb8faf\"", "size": 29193, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 29193, "httpStatusCode": 200}', DEFAULT, '25208f94-de23-4b7b-8dd0-6914c9f07bc8', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('edfcbb60-d279-44c4-9aea-a470d4e43566', 'product-images', '0.7325696870480343.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-16 23:51:27.896102+00', '2026-03-16 23:51:27.896102+00', '2026-03-16 23:51:27.896102+00', '{"eTag": "\"c6cc22ef80ef25ad1f36ac7539c0a697\"", "size": 44994, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-16T23:51:28.000Z", "contentLength": 44994, "httpStatusCode": 200}', DEFAULT, '24219d3b-8fc1-484a-b0f1-a77ebb84bcd6', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('5e264012-c96b-4e8d-802b-4717682277b9', 'product-images', '1773705627889-398zgsclkma.png', NULL, '2026-03-17 00:00:28.496723+00', '2026-03-17 00:00:28.496723+00', '2026-03-17 00:00:28.496723+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:00:29.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, 'c8c11879-6a37-4c2b-89c1-96e12df0c5a6', NULL, '{}');
INSERT INTO storage.objects VALUES ('0acd267d-2f9b-4d73-aed8-739550fece23', 'product-images', '0.8038771897070267.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:02:16.559807+00', '2026-03-17 00:02:16.559807+00', '2026-03-17 00:02:16.559807+00', '{"eTag": "\"42f0c5e00a50d5a20a1e178796243a63\"", "size": 30761, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:02:17.000Z", "contentLength": 30761, "httpStatusCode": 200}', DEFAULT, 'a32dedcf-3d5f-41bc-bbdf-360a98a86958', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('034f3cf4-df4d-4805-b127-e5bd0681261c', 'product-images', '1773943788237-4murq1r78h7.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:23.99649+00', '2026-03-19 18:10:23.99649+00', '2026-03-19 18:10:23.99649+00', '{"eTag": "\"81470b88250eb1c232ce4dbe41ae2fe1\"", "size": 43532, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:24.000Z", "contentLength": 43532, "httpStatusCode": 200}', DEFAULT, 'e4c8883b-cd49-4be4-8f0f-246c25144057', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('8f6c37ac-282b-4da2-a9f9-043832d11e51', 'product-images', '1773706011992-sbubl28shd.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-17 00:06:53.072606+00', '2026-03-17 00:06:53.072606+00', '2026-03-17 00:06:53.072606+00', '{"eTag": "\"f687c0b98b5d3e41318c07e95d6b460d\"", "size": 56094, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-17T00:06:54.000Z", "contentLength": 56094, "httpStatusCode": 200}', DEFAULT, 'e99702f3-17bd-4887-9ca4-c68fd2380878', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f48dba6e-60a1-4008-9c24-395872314b8a', 'product-images', '0.21817486504630257.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:35.566783+00', '2026-03-19 18:10:35.566783+00', '2026-03-19 18:10:35.566783+00', '{"eTag": "\"bd8aec652a95b460271a6d989354b84b\"", "size": 44811, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:36.000Z", "contentLength": 44811, "httpStatusCode": 200}', DEFAULT, 'c12fc63e-cfdf-4de1-975e-71340e914398', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('3a44300f-f7b6-48a1-aca3-0d58b74d1fc5', 'product-images', '0.9405172446405612.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 18:10:36.194638+00', '2026-03-19 18:10:36.194638+00', '2026-03-19 18:10:36.194638+00', '{"eTag": "\"8b4e865a2c1de5d146dd60c4d61f5616\"", "size": 43261, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T18:10:37.000Z", "contentLength": 43261, "httpStatusCode": 200}', DEFAULT, '77476bac-c17d-4611-9ad6-98fd87a42395', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a71de758-00bd-42e9-984e-9de51755c6e7', 'product-images', '0.12205278632137817.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 13:51:16.426555+00', '2026-03-23 13:51:16.426555+00', '2026-03-23 13:51:16.426555+00', '{"eTag": "\"bd86c3f9acdd154085d43d5e7848a1af\"", "size": 96204, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T13:51:17.000Z", "contentLength": 96204, "httpStatusCode": 200}', DEFAULT, 'a4bd5441-6bc1-492a-b6ca-0c04486abfee', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('78e52641-39f2-4636-9896-69c848615c4d', 'product-images', '1774304376106-jq5z6u3wwx.jpeg', NULL, '2026-03-23 22:19:36.688747+00', '2026-03-23 22:19:36.688747+00', '2026-03-23 22:19:36.688747+00', '{"eTag": "\"e8fe35c3fe879a4c94847a49fdace23c\"", "size": 49984, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:19:37.000Z", "contentLength": 49984, "httpStatusCode": 200}', DEFAULT, 'cf656fc0-3cae-4104-bed9-b0cbd778691a', NULL, '{}');
INSERT INTO storage.objects VALUES ('b36513b0-6811-4632-9df2-a2797f3e9d40', 'product-images', '0.1906356219702663.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:28:47.063708+00', '2026-03-23 22:28:47.063708+00', '2026-03-23 22:28:47.063708+00', '{"eTag": "\"a0731b2affb12933a90f8578770967a6\"", "size": 4166, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:28:48.000Z", "contentLength": 4166, "httpStatusCode": 200}', DEFAULT, '10d0bc87-88bb-4422-9bbb-89e89dcf154e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('dd043741-1dde-40bb-8078-a87c46d69a30', 'product-images', '0.4565933991985949.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:28:47.070374+00', '2026-03-23 22:28:47.070374+00', '2026-03-23 22:28:47.070374+00', '{"eTag": "\"c691864a55e57ce787df74266beda58f\"", "size": 3066, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:28:48.000Z", "contentLength": 3066, "httpStatusCode": 200}', DEFAULT, 'cb5e199a-86de-4d19-9a3a-f4664ceb1329', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('1d4bfde8-9f69-4142-9e15-6564e6e4f59c', 'product-images', '0.7003721364175077.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:44:22.937089+00', '2026-03-23 22:44:22.937089+00', '2026-03-23 22:44:22.937089+00', '{"eTag": "\"21c7b68417ce7fef8caea9c837b6f4f2\"", "size": 38452, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:44:23.000Z", "contentLength": 38452, "httpStatusCode": 200}', DEFAULT, 'acbec2a4-7307-4bd6-bebd-3f4dc7055dc1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('e5a2b843-72de-4406-b15a-e6dcdd4d4420', 'product-images', '0.7335373658557995.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:44:22.941261+00', '2026-03-23 22:44:22.941261+00', '2026-03-23 22:44:22.941261+00', '{"eTag": "\"7d953020d8e5c57036ec17d4989995c6\"", "size": 9234, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:44:23.000Z", "contentLength": 9234, "httpStatusCode": 200}', DEFAULT, '2a05010c-7252-46cb-a846-ce23a185717f', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a8fd478e-aeba-4b07-8f3c-676a6bbf7791', 'product-images', '0.2772577975895163.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:44:22.949565+00', '2026-03-23 22:44:22.949565+00', '2026-03-23 22:44:22.949565+00', '{"eTag": "\"85ba031424f361a6b8ad44c817c34a49\"", "size": 26366, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:44:23.000Z", "contentLength": 26366, "httpStatusCode": 200}', DEFAULT, '9340bb24-3149-4b0e-bd7c-9157497210f7', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
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
INSERT INTO storage.objects VALUES ('72f9fb03-2641-4237-9e99-a38f2478f09b', 'product-images', '0.043083503407627344.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 18:04:26.557219+00', '2026-03-23 18:04:26.557219+00', '2026-03-23 18:04:26.557219+00', '{"eTag": "\"386b18b44b439cb35479fe44db529c8d\"", "size": 27424, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T18:04:27.000Z", "contentLength": 27424, "httpStatusCode": 200}', DEFAULT, '1629ac86-34de-4d75-aa53-74d1619bbbf1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
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
INSERT INTO storage.objects VALUES ('b0e15c7f-086e-4202-bd7c-6b0fbeb85aad', 'product-images', '0.7379721631452556.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 18:04:27.34912+00', '2026-03-23 18:04:27.34912+00', '2026-03-23 18:04:27.34912+00', '{"eTag": "\"6c8075c0e43f1a5943f3942870111650\"", "size": 30058, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T18:04:28.000Z", "contentLength": 30058, "httpStatusCode": 200}', DEFAULT, 'de9d6688-2312-4a05-a879-ad13e12f55c0', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('637ab178-e049-47cb-b502-a7f42a09587c', 'product-images', '1773871091852-j3bc1wjoy2.jpg', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-18 21:58:13.278578+00', '2026-03-18 21:58:13.278578+00', '2026-03-18 21:58:13.278578+00', '{"eTag": "\"cd9bffa66c3110fa0a19fc7ffed11b35\"", "size": 9765, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-18T21:58:14.000Z", "contentLength": 9765, "httpStatusCode": 200}', DEFAULT, 'c8ed5255-b56b-4089-a489-180bb15d8d30', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('8020f021-dafd-4a04-9177-bf27857268fb', 'product-images', '1773940158275-g1jaouktroq.png', NULL, '2026-03-19 17:09:19.0225+00', '2026-03-19 17:09:19.0225+00', '2026-03-19 17:09:19.0225+00', '{"eTag": "\"2b6a84968cc02ffc5b2c6b844d63ab11\"", "size": 65327, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:09:19.000Z", "contentLength": 65327, "httpStatusCode": 200}', DEFAULT, '3453b559-c552-423d-bb07-f1f31dd51475', NULL, '{}');
INSERT INTO storage.objects VALUES ('2d883e69-62d7-4fa0-92c1-fe0b5daca16d', 'product-images', '0.3075905899564977.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:20:51.557127+00', '2026-03-23 22:20:51.557127+00', '2026-03-23 22:20:51.557127+00', '{"eTag": "\"4e4146ac7c18806354157ce296e978e1\"", "size": 2484, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:20:52.000Z", "contentLength": 2484, "httpStatusCode": 200}', DEFAULT, '6202eaa1-35bc-46d7-bb56-b238920253dc', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f3a459fc-1b82-4c38-ab1d-7eabf6891a19', 'product-images', '1773940742930-umfdm90qvzg.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:38.895802+00', '2026-03-19 17:19:38.895802+00', '2026-03-19 17:19:38.895802+00', '{"eTag": "\"f34ad374dc2afcc86c9846955fc1ba15\"", "size": 192287, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:39.000Z", "contentLength": 192287, "httpStatusCode": 200}', DEFAULT, 'c0a79f59-a5ca-4cc3-9326-1aaebfde8aab', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('30454c34-62f9-4902-8a11-2d96ee9c6e64', 'product-images', '0.9945551052975483.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-23 22:20:51.593073+00', '2026-03-23 22:20:51.593073+00', '2026-03-23 22:20:51.593073+00', '{"eTag": "\"3f6b9d57167e6f091aea12ada8f41d58\"", "size": 1774, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T22:20:52.000Z", "contentLength": 1774, "httpStatusCode": 200}', DEFAULT, '8a5ddbc5-657f-4ac8-9c02-2390fbdef835', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('16c36244-3cda-4b76-9155-35bdd6a568df', 'product-images', '0.9522582495040556.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:53.391124+00', '2026-03-19 17:19:53.391124+00', '2026-03-19 17:19:53.391124+00', '{"eTag": "\"c81eada9017793ddb1dc6348bdd2f0be\"", "size": 107941, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:54.000Z", "contentLength": 107941, "httpStatusCode": 200}', DEFAULT, 'e02ed8e7-2ea4-48a4-b59a-87eb0a99404f', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('f321c939-c632-4e96-963b-a03e373c72a3', 'product-images', '0.9272181640919159.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:53.49671+00', '2026-03-19 17:19:53.49671+00', '2026-03-19 17:19:53.49671+00', '{"eTag": "\"191d64027241b5ee290241d444774a24\"", "size": 135714, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:54.000Z", "contentLength": 135714, "httpStatusCode": 200}', DEFAULT, '10c6fb2b-ad03-4c45-8d37-746f831785c8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('a932791f-183c-4997-ab6b-89fdc7059064', 'product-images', '0.17836842891537785.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-19 17:19:53.664773+00', '2026-03-19 17:19:53.664773+00', '2026-03-19 17:19:53.664773+00', '{"eTag": "\"6f25d7d8035db9c96700d08f5efdab57\"", "size": 248235, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T17:19:54.000Z", "contentLength": 248235, "httpStatusCode": 200}', DEFAULT, '80342e44-bf3f-4d8c-a608-f219eb4bee59', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('1efd2ebc-7b51-460b-93e9-29046f9115a0', 'product-images', 'platform-1774325271423.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:08:33.160407+00', '2026-03-24 04:08:33.160407+00', '2026-03-24 04:08:33.160407+00', '{"eTag": "\"5ada619426cf029781fadb4343a10828\"", "size": 8649, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:08:34.000Z", "contentLength": 8649, "httpStatusCode": 200}', DEFAULT, '816bb23b-4b51-4cb3-abc4-1dbd8289b4ee', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('36683f25-99db-4178-8d8f-9cc88294950c', 'product-images', 'platform-1774325396039.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:10:38.214623+00', '2026-03-24 04:10:38.214623+00', '2026-03-24 04:10:38.214623+00', '{"eTag": "\"e8e98a89ba41a2a75c9073e26a0ce299\"", "size": 6902, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:10:39.000Z", "contentLength": 6902, "httpStatusCode": 200}', DEFAULT, '0cae2ba8-ecd9-498e-abf3-19a525732633', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('87a5c9f7-814b-46aa-a3cd-bbdd17dff72d', 'banners', '1774326412096-scg5ksmbce.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:27:34.22845+00', '2026-03-24 04:27:34.22845+00', '2026-03-24 04:27:34.22845+00', '{"eTag": "\"467a1fa21aea3a1db322de8275328f2f\"", "size": 58626, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:27:35.000Z", "contentLength": 58626, "httpStatusCode": 200}', DEFAULT, 'db757b47-152d-4b15-bb14-148db813bfd9', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('7c24fdc2-60a3-47de-a612-72e5ad1d96d3', 'banners', '1774326517123-kvf9a70k6dl.jpg', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:29:18.933656+00', '2026-03-24 04:29:18.933656+00', '2026-03-24 04:29:18.933656+00', '{"eTag": "\"840dec3be61d1204532f4b23a91059bd\"", "size": 149746, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:29:19.000Z", "contentLength": 149746, "httpStatusCode": 200}', DEFAULT, 'dfe8e914-0c70-4369-bd8b-12b1a5d76663', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('c0194b19-e83e-43b2-b66f-3316710277cd', 'banners', '1774326549802-aafysfcamnc.png', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:29:53.181925+00', '2026-03-24 04:29:53.181925+00', '2026-03-24 04:29:53.181925+00', '{"eTag": "\"7673156aaa050596579fec60d62e7ee3\"", "size": 1549099, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:29:54.000Z", "contentLength": 1549099, "httpStatusCode": 200}', DEFAULT, 'bb3f4577-50ed-417f-92f1-1934b0ddafc8', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('2b9881de-3840-4de4-a112-d7388ab39f26', 'banners', '1774326570234-0ls9cs8l522g.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:30:11.740188+00', '2026-03-24 04:30:11.740188+00', '2026-03-24 04:30:11.740188+00', '{"eTag": "\"9ea51dba037e24f4860fb1ec77ee93cb\"", "size": 63736, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:30:12.000Z", "contentLength": 63736, "httpStatusCode": 200}', DEFAULT, 'ee05f1a9-1658-47d0-9621-4b9337cd74b6', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('17a4fd35-95f1-4519-98ae-4d10032e45ec', 'banners', '1774326600268-mo9yzm1bzf8.webp', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '2026-03-24 04:30:41.785522+00', '2026-03-24 04:30:41.785522+00', '2026-03-24 04:30:41.785522+00', '{"eTag": "\"18c645536b420bc35af2e621a906e71e\"", "size": 49928, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T04:30:42.000Z", "contentLength": 49928, "httpStatusCode": 200}', DEFAULT, '82b17954-c101-4185-a783-5f84ffc78237', '18826abb-41b4-49d6-a62d-1ec9b3a0ddb6', '{}');
INSERT INTO storage.objects VALUES ('2d5b55cd-d676-4bd9-b658-f791cbdc111f', 'product-images', '0.4921344949876696.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:39:37.907205+00', '2026-03-24 12:39:37.907205+00', '2026-03-24 12:39:37.907205+00', '{"eTag": "\"8482e3404e1897741b0410d0a08bc848\"", "size": 95772, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:39:38.000Z", "contentLength": 95772, "httpStatusCode": 200}', DEFAULT, '80dffd32-238c-4558-ad29-b45218329f2c', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('0c247920-8a37-495c-9f3b-7f9b75a62cca', 'product-images', '0.31401498497928426.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:39:37.990323+00', '2026-03-24 12:39:37.990323+00', '2026-03-24 12:39:37.990323+00', '{"eTag": "\"b8ada340565acb81abc672113d86df36\"", "size": 108720, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:39:38.000Z", "contentLength": 108720, "httpStatusCode": 200}', DEFAULT, '982fb4ab-a173-4391-9b21-442ff94d1f70', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('177e16fb-0db4-440e-a429-0ee0624229ed', 'product-images', '0.14232249254638674.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:39:38.072476+00', '2026-03-24 12:39:38.072476+00', '2026-03-24 12:39:38.072476+00', '{"eTag": "\"c5566bbc031420cd2e0966efb606b45d\"", "size": 116284, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:39:39.000Z", "contentLength": 116284, "httpStatusCode": 200}', DEFAULT, 'b0bcf060-7134-4325-80a9-cb01e1a3c475', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('c6a22e3d-aa5b-43c1-94f7-639ca782a45f', 'product-images', '0.07967809507626189.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:39:38.152141+00', '2026-03-24 12:39:38.152141+00', '2026-03-24 12:39:38.152141+00', '{"eTag": "\"9a35a7a33968097503f8eef0552e3b36\"", "size": 120604, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:39:39.000Z", "contentLength": 120604, "httpStatusCode": 200}', DEFAULT, 'f8296eb5-2cde-43bf-99e7-c2da7cca30d4', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('7b264e5c-9e03-465c-a2dd-efb9b0f27abb', 'product-images', '0.12344100980506434.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:39:39.086388+00', '2026-03-24 12:39:39.086388+00', '2026-03-24 12:39:39.086388+00', '{"eTag": "\"a627c8a08711b2485dede0d071b47e5f\"", "size": 132360, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:39:39.000Z", "contentLength": 132360, "httpStatusCode": 200}', DEFAULT, '8c0a4e80-aa66-43fe-bca2-046f6d8c1993', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('67fed876-4338-4b27-be4e-dc9b33a34709', 'product-images', '0.7133745931360366.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:41:58.17474+00', '2026-03-24 12:41:58.17474+00', '2026-03-24 12:41:58.17474+00', '{"eTag": "\"841c7191a7937a956525029edf974d1f\"", "size": 73948, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:41:59.000Z", "contentLength": 73948, "httpStatusCode": 200}', DEFAULT, 'a2553b4e-6c50-4849-b004-d7e368382354', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('bc6a5b63-0bfe-4193-aab8-c147287ffa18', 'product-images', '0.7081899827648043.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:41:58.273849+00', '2026-03-24 12:41:58.273849+00', '2026-03-24 12:41:58.273849+00', '{"eTag": "\"d3674902e616943c62d82c1b50fe49f8\"", "size": 134304, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:41:59.000Z", "contentLength": 134304, "httpStatusCode": 200}', DEFAULT, '98c9e81e-4aee-46df-b05d-557fea0d56a9', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a02f9853-efe8-4561-a881-8b7b96725bac', 'product-images', '0.9199188989262441.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:41:59.060102+00', '2026-03-24 12:41:59.060102+00', '2026-03-24 12:41:59.060102+00', '{"eTag": "\"591a8eb7e9b91895c8d4fea0c6666b42\"", "size": 92298, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:42:00.000Z", "contentLength": 92298, "httpStatusCode": 200}', DEFAULT, '92dcb478-d1e0-4ee5-8a70-b2fa5e71aef7', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('2c49b65e-9c5e-49cf-be26-7e0d9a05aba4', 'product-images', '0.2726485529732041.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:43:56.239356+00', '2026-03-24 12:43:56.239356+00', '2026-03-24 12:43:56.239356+00', '{"eTag": "\"a334d2dbcb365a35cdcb7c22186bb4bd\"", "size": 64952, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:43:57.000Z", "contentLength": 64952, "httpStatusCode": 200}', DEFAULT, '7e811e46-87c2-476a-934a-9e9f806d32cd', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('1e15b923-dbb2-4a6f-a943-86f13ed444b6', 'product-images', '0.7345162422952085.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:43:56.306916+00', '2026-03-24 12:43:56.306916+00', '2026-03-24 12:43:56.306916+00', '{"eTag": "\"5ece271ec664ba83d0af7f9c27165b17\"", "size": 80858, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:43:57.000Z", "contentLength": 80858, "httpStatusCode": 200}', DEFAULT, '7690340e-dc54-46c1-bfa5-0fa6f80fe5f8', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('5a4e010b-b5fa-4787-91c5-91681a35e17d', 'product-images', '0.1589116043710067.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:43:56.4276+00', '2026-03-24 12:43:56.4276+00', '2026-03-24 12:43:56.4276+00', '{"eTag": "\"6ba11347dd5961b9ac47b63cb6878967\"", "size": 126158, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:43:57.000Z", "contentLength": 126158, "httpStatusCode": 200}', DEFAULT, 'ab4b7f79-5936-427c-a17d-2321a2e5b6f1', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('d916435f-403d-44d2-8f2b-cb496164e3da', 'product-images', '0.5818045829116851.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 12:41:58.140002+00', '2026-03-24 12:41:58.140002+00', '2026-03-24 12:41:58.140002+00', '{"eTag": "\"1ee374d5c15673ae6f9692ace0b05f74\"", "size": 79508, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T12:41:59.000Z", "contentLength": 79508, "httpStatusCode": 200}', DEFAULT, '0a826bfc-0978-4a37-85c6-e4dab711b38d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('cfd7e35c-c175-4073-8412-23b4722c2410', 'product-images', '0.0088711799504394.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 18:21:24.231955+00', '2026-03-24 18:21:24.231955+00', '2026-03-24 18:21:24.231955+00', '{"eTag": "\"cecec57acfcc9ffc7580abdaad6fde54\"", "size": 45220, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T18:21:25.000Z", "contentLength": 45220, "httpStatusCode": 200}', DEFAULT, '1b57276f-6f79-4c31-8f29-1fd337e88829', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('c499b5a7-ddfc-4af7-a1e9-0eba63ea2567', 'product-images', '0.163328654934927.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 18:21:24.285401+00', '2026-03-24 18:21:24.285401+00', '2026-03-24 18:21:24.285401+00', '{"eTag": "\"9661a01ce9736cdb6630486a98bb2a98\"", "size": 89170, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T18:21:25.000Z", "contentLength": 89170, "httpStatusCode": 200}', DEFAULT, 'd9fd091c-fb23-4f62-871e-99c0f468adcf', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('aac0e759-4576-4b47-92e9-7076aa245fba', 'product-images', '1774388379220-o45sfsjrz6.jpeg', NULL, '2026-03-24 21:39:39.84808+00', '2026-03-24 21:39:39.84808+00', '2026-03-24 21:39:39.84808+00', '{"eTag": "\"60bfa28784bdd7df22d7421bb8193c4e\"", "size": 49347, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T21:39:40.000Z", "contentLength": 49347, "httpStatusCode": 200}', DEFAULT, '1ee7352a-aac5-41c5-bf2b-c8bcd2f1bcbd', NULL, '{}');
INSERT INTO storage.objects VALUES ('694fb316-fe0c-4a8d-a8cd-6d2a0d0e4198', 'product-images', '0.007576596784928169.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 21:41:50.42674+00', '2026-03-24 21:41:50.42674+00', '2026-03-24 21:41:50.42674+00', '{"eTag": "\"e99187efd3ce5fc17238739814fbaed1\"", "size": 4372, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T21:41:51.000Z", "contentLength": 4372, "httpStatusCode": 200}', DEFAULT, 'f8e36701-8832-4179-84d4-36b86045b83c', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('5af0970e-a92c-4f4b-a2f1-5271b6566e37', 'product-images', '0.47961204644975686.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 22:04:50.876276+00', '2026-03-24 22:04:50.876276+00', '2026-03-24 22:04:50.876276+00', '{"eTag": "\"4ab9de1dfebe14d6a9c339a3732e8b11\"", "size": 60220, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T22:04:51.000Z", "contentLength": 60220, "httpStatusCode": 200}', DEFAULT, '2d608a02-04ed-47dd-bcaa-b2444960af4f', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('55b3f0ff-cbf1-4328-8798-ca0ccd3f3911', 'product-images', '0.7590792970313767.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 22:04:50.924421+00', '2026-03-24 22:04:50.924421+00', '2026-03-24 22:04:50.924421+00', '{"eTag": "\"84cc18d459368aa51da716f5bacc5eeb\"", "size": 89100, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T22:04:51.000Z", "contentLength": 89100, "httpStatusCode": 200}', DEFAULT, 'a47da986-0f64-453c-a98c-60e942659d6b', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('da3135d2-6627-434a-a5eb-dc4743d5cf0c', 'product-images', '0.7617709020121965.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-24 22:04:50.929544+00', '2026-03-24 22:04:50.929544+00', '2026-03-24 22:04:50.929544+00', '{"eTag": "\"9f9282bed74b2d175b997e5728313506\"", "size": 107220, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-24T22:04:51.000Z", "contentLength": 107220, "httpStatusCode": 200}', DEFAULT, 'ac1cb75b-6728-4188-b291-191f6de39707', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('175d8664-8219-4fa3-a828-d874dd5408e9', 'product-images', '0.4908170594646226.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:08:08.271203+00', '2026-03-25 00:08:08.271203+00', '2026-03-25 00:08:08.271203+00', '{"eTag": "\"05028df3150f3b24004e0121734f53a3\"", "size": 64434, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T00:08:09.000Z", "contentLength": 64434, "httpStatusCode": 200}', DEFAULT, 'f27b097a-e61a-4d96-b6cf-3fc288dd219d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('68294bf2-28a3-4ea1-b49c-285f2dc64fd9', 'product-images', '0.7230824503314834.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:08:08.368023+00', '2026-03-25 00:08:08.368023+00', '2026-03-25 00:08:08.368023+00', '{"eTag": "\"e922d35ae5eb28fb5d77c8b1cfb83f74\"", "size": 67646, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T00:08:09.000Z", "contentLength": 67646, "httpStatusCode": 200}', DEFAULT, 'e878e176-d435-4471-a912-24e5e39aabbf', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('2db8b178-493d-48a0-8c28-374b333fd585', 'product-images', '0.9122669907373486.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:08:08.432937+00', '2026-03-25 00:08:08.432937+00', '2026-03-25 00:08:08.432937+00', '{"eTag": "\"1b634849d3731fcce2cd669de10fdc3a\"", "size": 62386, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T00:08:09.000Z", "contentLength": 62386, "httpStatusCode": 200}', DEFAULT, '8c609a1c-8bd7-476a-86d7-36f14ca9d9b3', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('3a7f295e-ad46-48e5-b099-8cc2b8aa1b48', 'product-images', '0.17922385780395.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:08:08.474961+00', '2026-03-25 00:08:08.474961+00', '2026-03-25 00:08:08.474961+00', '{"eTag": "\"de5a58383bba3b9a9cfe61dc4dcf33bf\"", "size": 112856, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T00:08:09.000Z", "contentLength": 112856, "httpStatusCode": 200}', DEFAULT, 'e71a4727-dd65-4e16-a168-89128a2ca74d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f56c6aba-e117-4cd5-8c8d-5d62cb5d2418', 'product-images', '0.6826810539320676.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:08:08.754777+00', '2026-03-25 00:08:08.754777+00', '2026-03-25 00:08:08.754777+00', '{"eTag": "\"8b31a160d45181b3fe4a8d1e08038de8\"", "size": 135088, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T00:08:09.000Z", "contentLength": 135088, "httpStatusCode": 200}', DEFAULT, '1006ef7c-524d-4042-a2eb-d644b929e1a5', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('2375aa0b-56a1-4e79-a1e8-a69a2d5575c4', 'product-images', '0.11666030154676355.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 00:08:08.827672+00', '2026-03-25 00:08:08.827672+00', '2026-03-25 00:08:08.827672+00', '{"eTag": "\"7b609d297008f2727ab461563ca27440\"", "size": 131442, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T00:08:09.000Z", "contentLength": 131442, "httpStatusCode": 200}', DEFAULT, 'ad970d28-3aa8-4093-ad39-6d4934f7d2fa', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('16dd41c6-9b9d-4b29-8479-bfd25c021ce9', 'product-images', '1774442801173-8yz6gdnnjcn.png', NULL, '2026-03-25 12:46:41.931508+00', '2026-03-25 12:46:41.931508+00', '2026-03-25 12:46:41.931508+00', '{"eTag": "\"9fca58e6a66029c36c6c13cf1890d391\"", "size": 90159, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T12:46:42.000Z", "contentLength": 90159, "httpStatusCode": 200}', DEFAULT, '091e6e92-6693-4a7f-aa8c-a1257c1c2714', NULL, '{}');
INSERT INTO storage.objects VALUES ('ee297060-a9a7-4140-aa6f-c3e3b646c304', 'product-images', '0.8485202115731872.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 12:48:31.534198+00', '2026-03-25 12:48:31.534198+00', '2026-03-25 12:48:31.534198+00', '{"eTag": "\"61e530a98e6169d55b13b34e96d0e969\"", "size": 31992, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T12:48:32.000Z", "contentLength": 31992, "httpStatusCode": 200}', DEFAULT, '721e4c31-35e3-4f54-b8e8-ae4fd4b597bf', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a0d30189-d94b-419d-95bb-f96a24995d69', 'product-images', '0.7316931613537193.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 12:48:31.569387+00', '2026-03-25 12:48:31.569387+00', '2026-03-25 12:48:31.569387+00', '{"eTag": "\"1fe7a1ac7e95290adc1c9098ff87cb49\"", "size": 64856, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T12:48:32.000Z", "contentLength": 64856, "httpStatusCode": 200}', DEFAULT, 'a38d7eab-e3e2-450b-b5ab-d3f6dd6ed638', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('4ff600a2-e47e-407c-8d66-fda50e5f7cf0', 'product-images', '0.24104327480223364.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 12:48:32.179158+00', '2026-03-25 12:48:32.179158+00', '2026-03-25 12:48:32.179158+00', '{"eTag": "\"1b888bb6a4b727503ad8e72a1b4a4919\"", "size": 94758, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T12:48:33.000Z", "contentLength": 94758, "httpStatusCode": 200}', DEFAULT, '516e560b-d3bb-47c5-b133-a60a2c7d6d55', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('6a3dc416-8379-43d5-8728-e2c56a1a4110', 'product-images', '1774442998431-uydwjxrx2zr.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 12:49:59.336737+00', '2026-03-25 12:49:59.336737+00', '2026-03-25 12:49:59.336737+00', '{"eTag": "\"13f310fd0c8ae2ebfedee2585b053938\"", "size": 69920, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T12:50:00.000Z", "contentLength": 69920, "httpStatusCode": 200}', DEFAULT, '33d3fb95-2861-4a0b-904a-9c8733149631', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('f7ab1388-8a35-4822-864c-c0d1abd35f27', 'product-images', '0.9069651944189062.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 13:01:21.475023+00', '2026-03-25 13:01:21.475023+00', '2026-03-25 13:01:21.475023+00', '{"eTag": "\"e7acf56237de905773801ebbe0203a08\"", "size": 94628, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T13:01:22.000Z", "contentLength": 94628, "httpStatusCode": 200}', DEFAULT, '8eebefa0-a8ae-43a0-8379-b8945af17b44', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('4bbed350-7cf9-4aff-9b50-e92c59a93766', 'product-images', '0.06662447064288157.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 13:01:21.457887+00', '2026-03-25 13:01:21.457887+00', '2026-03-25 13:01:21.457887+00', '{"eTag": "\"f14e71a97aec819ca05c9e3496c191f4\"", "size": 87614, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T13:01:22.000Z", "contentLength": 87614, "httpStatusCode": 200}', DEFAULT, 'fd1e316f-3af4-428a-ab64-a5d00d283c5d', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a0b964d3-f842-4345-a46a-9977f0ea6d6b', 'product-images', '0.7406187774776257.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 13:01:21.558534+00', '2026-03-25 13:01:21.558534+00', '2026-03-25 13:01:21.558534+00', '{"eTag": "\"611dfa0faf311a735b9fae058d9ecadc\"", "size": 120828, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T13:01:22.000Z", "contentLength": 120828, "httpStatusCode": 200}', DEFAULT, 'baf26968-65a6-4aa5-8b54-9c78f569e3cf', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('69feedb2-aac7-4665-88f3-97033ce964a2', 'product-images', '0.7680479737627378.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 13:01:21.64716+00', '2026-03-25 13:01:21.64716+00', '2026-03-25 13:01:21.64716+00', '{"eTag": "\"43b8c4b3fa821d66fc1a975cb341afec\"", "size": 141380, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T13:01:22.000Z", "contentLength": 141380, "httpStatusCode": 200}', DEFAULT, '905d70f1-ec55-4c5d-bff2-c9ca3fc0f38e', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('dfb8c7a5-451b-4298-a03a-65c47ca8ae36', 'product-images', '0.3745469439165241.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 13:01:21.753019+00', '2026-03-25 13:01:21.753019+00', '2026-03-25 13:01:21.753019+00', '{"eTag": "\"c0536d8155b10b8acb7c75787f54dcdc\"", "size": 228286, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T13:01:22.000Z", "contentLength": 228286, "httpStatusCode": 200}', DEFAULT, '77eff889-eb64-4890-91b2-7d2a81c2ce54', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('792cdfbb-db64-46f7-83cb-c9621a96925c', 'product-images', '1774450600012-0e29tnjdsege.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 14:56:40.891306+00', '2026-03-25 14:56:40.891306+00', '2026-03-25 14:56:40.891306+00', '{"eTag": "\"ec93948743b7e8030ea7148966f57039\"", "size": 53434, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T14:56:41.000Z", "contentLength": 53434, "httpStatusCode": 200}', DEFAULT, '56315993-022d-48cb-b848-7ad621e064bf', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');
INSERT INTO storage.objects VALUES ('a314e858-262a-4b03-9113-0cc6b164e199', 'product-images', '1774450609824-v5yocrjlz9q.webp', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '2026-03-25 14:56:50.108707+00', '2026-03-25 14:56:50.108707+00', '2026-03-25 14:56:50.108707+00', '{"eTag": "\"9c227abbeeb9259fa5ede9ba95bdfce7\"", "size": 44168, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-25T14:56:51.000Z", "contentLength": 44168, "httpStatusCode": 200}', DEFAULT, '8a4239fa-1952-482a-9b52-a7e1fa89cd07', 'ae8dfd8c-5182-41d7-9a4a-c02ebba36890', '{}');


--
-- TOC entry 4807 (class 0 OID 17226)
-- Dependencies: 376
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4808 (class 0 OID 17240)
-- Dependencies: 377
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 4811 (class 0 OID 17309)
-- Dependencies: 380
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- TOC entry 3834 (class 0 OID 16608)
-- Dependencies: 350
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--



--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 345
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 211, true);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 371
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 531, true);


--
-- TOC entry 4171 (class 2606 OID 16783)
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- TOC entry 4140 (class 2606 OID 16531)
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4226 (class 2606 OID 17115)
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- TOC entry 4228 (class 2606 OID 17113)
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4194 (class 2606 OID 16889)
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4149 (class 2606 OID 16907)
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- TOC entry 4151 (class 2606 OID 16917)
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- TOC entry 4138 (class 2606 OID 16524)
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- TOC entry 4173 (class 2606 OID 16776)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- TOC entry 4169 (class 2606 OID 16764)
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4161 (class 2606 OID 16957)
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- TOC entry 4163 (class 2606 OID 16751)
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- TOC entry 4207 (class 2606 OID 17016)
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- TOC entry 4209 (class 2606 OID 17014)
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- TOC entry 4211 (class 2606 OID 17012)
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- TOC entry 4221 (class 2606 OID 17074)
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4204 (class 2606 OID 16976)
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 17038)
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- TOC entry 4217 (class 2606 OID 17040)
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- TOC entry 4198 (class 2606 OID 16942)
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4132 (class 2606 OID 16514)
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4135 (class 2606 OID 16694)
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- TOC entry 4183 (class 2606 OID 16823)
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- TOC entry 4185 (class 2606 OID 16821)
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4190 (class 2606 OID 16837)
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- TOC entry 4143 (class 2606 OID 16537)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4156 (class 2606 OID 16715)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 4180 (class 2606 OID 16804)
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- TOC entry 4175 (class 2606 OID 16795)
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- TOC entry 4125 (class 2606 OID 16877)
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- TOC entry 4127 (class 2606 OID 16501)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4360 (class 2606 OID 27153)
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- TOC entry 4356 (class 2606 OID 27136)
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- TOC entry 4375 (class 2606 OID 28477)
-- Name: admin_settings admin_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_settings
    ADD CONSTRAINT admin_settings_pkey PRIMARY KEY (key);


--
-- TOC entry 4392 (class 2606 OID 29720)
-- Name: amazon_product_mappings amazon_product_mappings_amazon_item_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amazon_product_mappings
    ADD CONSTRAINT amazon_product_mappings_amazon_item_id_key UNIQUE (amazon_item_id);


--
-- TOC entry 4394 (class 2606 OID 29718)
-- Name: amazon_product_mappings amazon_product_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amazon_product_mappings
    ADD CONSTRAINT amazon_product_mappings_pkey PRIMARY KEY (id);


--
-- TOC entry 4278 (class 2606 OID 17556)
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- TOC entry 4284 (class 2606 OID 22139)
-- Name: brands brands_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_name_key UNIQUE (name);


--
-- TOC entry 4286 (class 2606 OID 22137)
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- TOC entry 4296 (class 2606 OID 22183)
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- TOC entry 4298 (class 2606 OID 22181)
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- TOC entry 4300 (class 2606 OID 22185)
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- TOC entry 4340 (class 2606 OID 22464)
-- Name: coupon_votes coupon_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_pkey PRIMARY KEY (id);


--
-- TOC entry 4342 (class 2606 OID 22468)
-- Name: coupon_votes coupon_votes_session_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_session_unique UNIQUE (coupon_id, session_token);


--
-- TOC entry 4344 (class 2606 OID 22466)
-- Name: coupon_votes coupon_votes_user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_user_unique UNIQUE (coupon_id, user_id);


--
-- TOC entry 4336 (class 2606 OID 22450)
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 22435)
-- Name: institutional_pages institutional_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutional_pages
    ADD CONSTRAINT institutional_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 4334 (class 2606 OID 22437)
-- Name: institutional_pages institutional_pages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.institutional_pages
    ADD CONSTRAINT institutional_pages_slug_key UNIQUE (slug);


--
-- TOC entry 4365 (class 2606 OID 27192)
-- Name: ml_product_mappings ml_product_mappings_ml_item_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_product_mappings
    ADD CONSTRAINT ml_product_mappings_ml_item_id_key UNIQUE (ml_item_id);


--
-- TOC entry 4367 (class 2606 OID 27190)
-- Name: ml_product_mappings ml_product_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_product_mappings
    ADD CONSTRAINT ml_product_mappings_pkey PRIMARY KEY (id);


--
-- TOC entry 4369 (class 2606 OID 27212)
-- Name: ml_sync_logs ml_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_sync_logs
    ADD CONSTRAINT ml_sync_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4363 (class 2606 OID 27175)
-- Name: ml_tokens ml_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_tokens
    ADD CONSTRAINT ml_tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 4288 (class 2606 OID 22152)
-- Name: models models_brand_id_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_brand_id_name_key UNIQUE (brand_id, name);


--
-- TOC entry 4290 (class 2606 OID 22150)
-- Name: models models_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_pkey PRIMARY KEY (id);


--
-- TOC entry 4328 (class 2606 OID 22385)
-- Name: newsletter_products newsletter_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_products
    ADD CONSTRAINT newsletter_products_pkey PRIMARY KEY (newsletter_id, product_id);


--
-- TOC entry 4326 (class 2606 OID 22380)
-- Name: newsletters newsletters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletters
    ADD CONSTRAINT newsletters_pkey PRIMARY KEY (id);


--
-- TOC entry 4292 (class 2606 OID 22170)
-- Name: platforms platforms_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_name_key UNIQUE (name);


--
-- TOC entry 4294 (class 2606 OID 22168)
-- Name: platforms platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.platforms
    ADD CONSTRAINT platforms_pkey PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 22416)
-- Name: price_history price_history_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_pkey PRIMARY KEY (id);


--
-- TOC entry 4320 (class 2606 OID 22334)
-- Name: product_clicks product_clicks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_clicks
    ADD CONSTRAINT product_clicks_pkey PRIMARY KEY (id);


--
-- TOC entry 4316 (class 2606 OID 22260)
-- Name: product_likes product_likes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_pkey PRIMARY KEY (id);


--
-- TOC entry 4318 (class 2606 OID 22262)
-- Name: product_likes product_likes_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- TOC entry 4322 (class 2606 OID 22355)
-- Name: product_trust_votes product_trust_votes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_pkey PRIMARY KEY (id);


--
-- TOC entry 4324 (class 2606 OID 22357)
-- Name: product_trust_votes product_trust_votes_user_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_user_unique UNIQUE (product_id, user_id);


--
-- TOC entry 4275 (class 2606 OID 17544)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- TOC entry 4266 (class 2606 OID 17513)
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- TOC entry 4268 (class 2606 OID 17515)
-- Name: profiles profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_user_id_key UNIQUE (user_id);


--
-- TOC entry 4282 (class 2606 OID 17582)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 17567)
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- TOC entry 4373 (class 2606 OID 27223)
-- Name: search_cache search_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.search_cache
    ADD CONSTRAINT search_cache_pkey PRIMARY KEY (id);


--
-- TOC entry 4348 (class 2606 OID 25980)
-- Name: shopee_product_mappings shopee_product_mappings_item_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_product_mappings
    ADD CONSTRAINT shopee_product_mappings_item_unique UNIQUE (shopee_item_id);


--
-- TOC entry 4350 (class 2606 OID 25978)
-- Name: shopee_product_mappings shopee_product_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_product_mappings
    ADD CONSTRAINT shopee_product_mappings_pkey PRIMARY KEY (id);


--
-- TOC entry 4353 (class 2606 OID 25998)
-- Name: shopee_sync_logs shopee_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_sync_logs
    ADD CONSTRAINT shopee_sync_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4306 (class 2606 OID 22207)
-- Name: special_page_products special_page_products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_pkey PRIMARY KEY (id);


--
-- TOC entry 4308 (class 2606 OID 22209)
-- Name: special_page_products special_page_products_special_page_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_special_page_id_product_id_key UNIQUE (special_page_id, product_id);


--
-- TOC entry 4302 (class 2606 OID 22197)
-- Name: special_pages special_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_pages
    ADD CONSTRAINT special_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 4304 (class 2606 OID 22199)
-- Name: special_pages special_pages_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_pages
    ADD CONSTRAINT special_pages_slug_key UNIQUE (slug);


--
-- TOC entry 4338 (class 2606 OID 23729)
-- Name: coupons uq_coupons_platform_code; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT uq_coupons_platform_code UNIQUE (platform_id, code);


--
-- TOC entry 4270 (class 2606 OID 17522)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4272 (class 2606 OID 17524)
-- Name: user_roles user_roles_user_id_role_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_role_key UNIQUE (user_id, role);


--
-- TOC entry 4310 (class 2606 OID 22231)
-- Name: whatsapp_groups whatsapp_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whatsapp_groups
    ADD CONSTRAINT whatsapp_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4312 (class 2606 OID 22240)
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- TOC entry 4314 (class 2606 OID 22242)
-- Name: wishlists wishlists_user_id_product_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_product_id_key UNIQUE (user_id, product_id);


--
-- TOC entry 4264 (class 2606 OID 17489)
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4378 (class 2606 OID 29625)
-- Name: messages_2026_03_23 messages_2026_03_23_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_23
    ADD CONSTRAINT messages_2026_03_23_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4381 (class 2606 OID 29637)
-- Name: messages_2026_03_24 messages_2026_03_24_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_24
    ADD CONSTRAINT messages_2026_03_24_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4384 (class 2606 OID 29649)
-- Name: messages_2026_03_25 messages_2026_03_25_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_25
    ADD CONSTRAINT messages_2026_03_25_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4387 (class 2606 OID 29661)
-- Name: messages_2026_03_26 messages_2026_03_26_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_26
    ADD CONSTRAINT messages_2026_03_26_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4390 (class 2606 OID 29673)
-- Name: messages_2026_03_27 messages_2026_03_27_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_27
    ADD CONSTRAINT messages_2026_03_27_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4399 (class 2606 OID 30856)
-- Name: messages_2026_03_28 messages_2026_03_28_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_28
    ADD CONSTRAINT messages_2026_03_28_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4402 (class 2606 OID 32002)
-- Name: messages_2026_03_29 messages_2026_03_29_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_29
    ADD CONSTRAINT messages_2026_03_29_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4405 (class 2606 OID 33155)
-- Name: messages_2026_03_30 messages_2026_03_30_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.messages_2026_03_30
    ADD CONSTRAINT messages_2026_03_30_pkey PRIMARY KEY (id, inserted_at);


--
-- TOC entry 4234 (class 2606 OID 17151)
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- TOC entry 4231 (class 2606 OID 17124)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4255 (class 2606 OID 17332)
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- TOC entry 4242 (class 2606 OID 17175)
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- TOC entry 4258 (class 2606 OID 17308)
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- TOC entry 4237 (class 2606 OID 17166)
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- TOC entry 4239 (class 2606 OID 17164)
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4248 (class 2606 OID 17187)
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- TOC entry 4253 (class 2606 OID 17249)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- TOC entry 4251 (class 2606 OID 17234)
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- TOC entry 4261 (class 2606 OID 17318)
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- TOC entry 4141 (class 1259 OID 16532)
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- TOC entry 4115 (class 1259 OID 16704)
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4222 (class 1259 OID 17119)
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- TOC entry 4223 (class 1259 OID 17118)
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- TOC entry 4224 (class 1259 OID 17116)
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- TOC entry 4229 (class 1259 OID 17117)
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- TOC entry 4116 (class 1259 OID 16706)
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4117 (class 1259 OID 16707)
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4159 (class 1259 OID 16785)
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- TOC entry 4192 (class 1259 OID 16893)
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- TOC entry 4147 (class 1259 OID 16873)
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 4147
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- TOC entry 4152 (class 1259 OID 16701)
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- TOC entry 4195 (class 1259 OID 16890)
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- TOC entry 4219 (class 1259 OID 17075)
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- TOC entry 4196 (class 1259 OID 16891)
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- TOC entry 4167 (class 1259 OID 16896)
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- TOC entry 4164 (class 1259 OID 16757)
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- TOC entry 4165 (class 1259 OID 16902)
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- TOC entry 4205 (class 1259 OID 17027)
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- TOC entry 4202 (class 1259 OID 16980)
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- TOC entry 4212 (class 1259 OID 17053)
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4213 (class 1259 OID 17051)
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- TOC entry 4218 (class 1259 OID 17052)
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- TOC entry 4199 (class 1259 OID 16949)
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- TOC entry 4200 (class 1259 OID 16948)
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- TOC entry 4201 (class 1259 OID 16950)
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- TOC entry 4118 (class 1259 OID 16708)
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4119 (class 1259 OID 16705)
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- TOC entry 4128 (class 1259 OID 16515)
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- TOC entry 4129 (class 1259 OID 16516)
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- TOC entry 4130 (class 1259 OID 16700)
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- TOC entry 4133 (class 1259 OID 16787)
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- TOC entry 4136 (class 1259 OID 16892)
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- TOC entry 4186 (class 1259 OID 16829)
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- TOC entry 4187 (class 1259 OID 16894)
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- TOC entry 4188 (class 1259 OID 16844)
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- TOC entry 4191 (class 1259 OID 16843)
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- TOC entry 4153 (class 1259 OID 16895)
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- TOC entry 4154 (class 1259 OID 17065)
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- TOC entry 4157 (class 1259 OID 16786)
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- TOC entry 4178 (class 1259 OID 16811)
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- TOC entry 4181 (class 1259 OID 16810)
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- TOC entry 4176 (class 1259 OID 16796)
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- TOC entry 4177 (class 1259 OID 16958)
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- TOC entry 4166 (class 1259 OID 16955)
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- TOC entry 4158 (class 1259 OID 16784)
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- TOC entry 4120 (class 1259 OID 16864)
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 4120
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- TOC entry 4121 (class 1259 OID 16702)
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- TOC entry 4122 (class 1259 OID 16505)
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- TOC entry 4123 (class 1259 OID 16919)
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- TOC entry 4358 (class 1259 OID 27160)
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- TOC entry 4361 (class 1259 OID 27159)
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- TOC entry 4354 (class 1259 OID 27142)
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- TOC entry 4357 (class 1259 OID 27143)
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- TOC entry 4395 (class 1259 OID 29726)
-- Name: idx_amazon_product_mappings_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_amazon_product_mappings_item_id ON public.amazon_product_mappings USING btree (amazon_item_id);


--
-- TOC entry 4396 (class 1259 OID 29727)
-- Name: idx_amazon_product_mappings_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_amazon_product_mappings_product_id ON public.amazon_product_mappings USING btree (product_id);


--
-- TOC entry 4273 (class 1259 OID 25964)
-- Name: idx_products_external_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_products_external_id ON public.products USING btree (external_id);


--
-- TOC entry 4370 (class 1259 OID 27225)
-- Name: idx_search_cache_exp; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_search_cache_exp ON public.search_cache USING btree (expires_at);


--
-- TOC entry 4371 (class 1259 OID 27224)
-- Name: idx_search_cache_kw; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_search_cache_kw ON public.search_cache USING btree (keyword, offset_val);


--
-- TOC entry 4345 (class 1259 OID 26003)
-- Name: idx_shopee_mappings_item_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shopee_mappings_item_id ON public.shopee_product_mappings USING btree (shopee_item_id);


--
-- TOC entry 4346 (class 1259 OID 26004)
-- Name: idx_shopee_mappings_product_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shopee_mappings_product_id ON public.shopee_product_mappings USING btree (product_id);


--
-- TOC entry 4351 (class 1259 OID 26005)
-- Name: idx_shopee_sync_logs_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_shopee_sync_logs_created ON public.shopee_sync_logs USING btree (created_at DESC);


--
-- TOC entry 4276 (class 1259 OID 25967)
-- Name: uq_products_external_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_products_external_id ON public.products USING btree (external_id) WHERE (external_id IS NOT NULL);


--
-- TOC entry 4232 (class 1259 OID 17490)
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- TOC entry 4262 (class 1259 OID 17491)
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4376 (class 1259 OID 29626)
-- Name: messages_2026_03_23_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_23_inserted_at_topic_idx ON realtime.messages_2026_03_23 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4379 (class 1259 OID 29638)
-- Name: messages_2026_03_24_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_24_inserted_at_topic_idx ON realtime.messages_2026_03_24 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4382 (class 1259 OID 29650)
-- Name: messages_2026_03_25_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_25_inserted_at_topic_idx ON realtime.messages_2026_03_25 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4385 (class 1259 OID 29662)
-- Name: messages_2026_03_26_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_26_inserted_at_topic_idx ON realtime.messages_2026_03_26 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4388 (class 1259 OID 29674)
-- Name: messages_2026_03_27_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_27_inserted_at_topic_idx ON realtime.messages_2026_03_27 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4397 (class 1259 OID 30857)
-- Name: messages_2026_03_28_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_28_inserted_at_topic_idx ON realtime.messages_2026_03_28 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4400 (class 1259 OID 32003)
-- Name: messages_2026_03_29_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_29_inserted_at_topic_idx ON realtime.messages_2026_03_29 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4403 (class 1259 OID 33156)
-- Name: messages_2026_03_30_inserted_at_topic_idx; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX messages_2026_03_30_inserted_at_topic_idx ON realtime.messages_2026_03_30 USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- TOC entry 4235 (class 1259 OID 17494)
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- TOC entry 4240 (class 1259 OID 17176)
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- TOC entry 4243 (class 1259 OID 17193)
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- TOC entry 4256 (class 1259 OID 17333)
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- TOC entry 4249 (class 1259 OID 17260)
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- TOC entry 4244 (class 1259 OID 17225)
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- TOC entry 4245 (class 1259 OID 17340)
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- TOC entry 4246 (class 1259 OID 17194)
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- TOC entry 4259 (class 1259 OID 17324)
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- TOC entry 4406 (class 0 OID 0)
-- Name: messages_2026_03_23_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_23_inserted_at_topic_idx;


--
-- TOC entry 4407 (class 0 OID 0)
-- Name: messages_2026_03_23_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_23_pkey;


--
-- TOC entry 4408 (class 0 OID 0)
-- Name: messages_2026_03_24_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_24_inserted_at_topic_idx;


--
-- TOC entry 4409 (class 0 OID 0)
-- Name: messages_2026_03_24_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_24_pkey;


--
-- TOC entry 4410 (class 0 OID 0)
-- Name: messages_2026_03_25_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_25_inserted_at_topic_idx;


--
-- TOC entry 4411 (class 0 OID 0)
-- Name: messages_2026_03_25_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_25_pkey;


--
-- TOC entry 4412 (class 0 OID 0)
-- Name: messages_2026_03_26_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_26_inserted_at_topic_idx;


--
-- TOC entry 4413 (class 0 OID 0)
-- Name: messages_2026_03_26_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_26_pkey;


--
-- TOC entry 4414 (class 0 OID 0)
-- Name: messages_2026_03_27_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_27_inserted_at_topic_idx;


--
-- TOC entry 4415 (class 0 OID 0)
-- Name: messages_2026_03_27_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_27_pkey;


--
-- TOC entry 4416 (class 0 OID 0)
-- Name: messages_2026_03_28_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_28_inserted_at_topic_idx;


--
-- TOC entry 4417 (class 0 OID 0)
-- Name: messages_2026_03_28_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_28_pkey;


--
-- TOC entry 4418 (class 0 OID 0)
-- Name: messages_2026_03_29_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_29_inserted_at_topic_idx;


--
-- TOC entry 4419 (class 0 OID 0)
-- Name: messages_2026_03_29_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_29_pkey;


--
-- TOC entry 4420 (class 0 OID 0)
-- Name: messages_2026_03_30_inserted_at_topic_idx; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_inserted_at_topic_index ATTACH PARTITION realtime.messages_2026_03_30_inserted_at_topic_idx;


--
-- TOC entry 4421 (class 0 OID 0)
-- Name: messages_2026_03_30_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2026_03_30_pkey;


--
-- TOC entry 4473 (class 2620 OID 17602)
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- TOC entry 4480 (class 2620 OID 22298)
-- Name: products trg_calc_discount; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_calc_discount BEFORE INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.calc_discount_percentage();


--
-- TOC entry 4485 (class 2620 OID 23733)
-- Name: coupons trg_coupons_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_coupons_updated_at BEFORE UPDATE ON public.coupons FOR EACH ROW EXECUTE FUNCTION public.update_coupons_updated_at();


--
-- TOC entry 4484 (class 2620 OID 22532)
-- Name: product_clicks trg_increment_product_clicks; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_increment_product_clicks AFTER INSERT ON public.product_clicks FOR EACH ROW EXECUTE FUNCTION public.increment_product_clicks();


--
-- TOC entry 4481 (class 2620 OID 22531)
-- Name: products trg_log_price_change; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_price_change AFTER INSERT OR UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.log_price_change();


--
-- TOC entry 4483 (class 2620 OID 17600)
-- Name: banners update_banners_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_banners_updated_at BEFORE UPDATE ON public.banners FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4482 (class 2620 OID 17599)
-- Name: products update_products_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON public.products FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4479 (class 2620 OID 17601)
-- Name: profiles update_profiles_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON public.profiles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4474 (class 2620 OID 17156)
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- TOC entry 4475 (class 2620 OID 17279)
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- TOC entry 4476 (class 2620 OID 17342)
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4477 (class 2620 OID 17343)
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- TOC entry 4478 (class 2620 OID 17213)
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- TOC entry 4423 (class 2606 OID 16688)
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4428 (class 2606 OID 16777)
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4427 (class 2606 OID 16765)
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- TOC entry 4426 (class 2606 OID 16752)
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4434 (class 2606 OID 17017)
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4435 (class 2606 OID 17022)
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4436 (class 2606 OID 17046)
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4437 (class 2606 OID 17041)
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4433 (class 2606 OID 16943)
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4422 (class 2606 OID 16721)
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- TOC entry 4430 (class 2606 OID 16824)
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4431 (class 2606 OID 16897)
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- TOC entry 4432 (class 2606 OID 16838)
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4424 (class 2606 OID 17060)
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- TOC entry 4425 (class 2606 OID 16716)
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4429 (class 2606 OID 16805)
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- TOC entry 4470 (class 2606 OID 27154)
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4469 (class 2606 OID 27137)
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4472 (class 2606 OID 29721)
-- Name: amazon_product_mappings amazon_product_mappings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.amazon_product_mappings
    ADD CONSTRAINT amazon_product_mappings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4466 (class 2606 OID 22469)
-- Name: coupon_votes coupon_votes_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE;


--
-- TOC entry 4467 (class 2606 OID 22474)
-- Name: coupon_votes coupon_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_votes
    ADD CONSTRAINT coupon_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id) ON DELETE SET NULL;


--
-- TOC entry 4465 (class 2606 OID 22451)
-- Name: coupons coupons_platform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id) ON DELETE CASCADE;


--
-- TOC entry 4471 (class 2606 OID 27193)
-- Name: ml_product_mappings ml_product_mappings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ml_product_mappings
    ADD CONSTRAINT ml_product_mappings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4451 (class 2606 OID 22153)
-- Name: models models_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.models
    ADD CONSTRAINT models_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE CASCADE;


--
-- TOC entry 4462 (class 2606 OID 22386)
-- Name: newsletter_products newsletter_products_newsletter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_products
    ADD CONSTRAINT newsletter_products_newsletter_id_fkey FOREIGN KEY (newsletter_id) REFERENCES public.newsletters(id) ON DELETE CASCADE;


--
-- TOC entry 4463 (class 2606 OID 22391)
-- Name: newsletter_products newsletter_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.newsletter_products
    ADD CONSTRAINT newsletter_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4464 (class 2606 OID 22417)
-- Name: price_history price_history_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.price_history
    ADD CONSTRAINT price_history_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4458 (class 2606 OID 22339)
-- Name: product_clicks product_clicks_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_clicks
    ADD CONSTRAINT product_clicks_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4459 (class 2606 OID 22553)
-- Name: product_clicks product_clicks_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_clicks
    ADD CONSTRAINT product_clicks_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4456 (class 2606 OID 22268)
-- Name: product_likes product_likes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4457 (class 2606 OID 22263)
-- Name: product_likes product_likes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_likes
    ADD CONSTRAINT product_likes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4460 (class 2606 OID 22360)
-- Name: product_trust_votes product_trust_votes_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4461 (class 2606 OID 22548)
-- Name: product_trust_votes product_trust_votes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.product_trust_votes
    ADD CONSTRAINT product_trust_votes_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4444 (class 2606 OID 22277)
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE SET NULL;


--
-- TOC entry 4445 (class 2606 OID 22320)
-- Name: products products_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- TOC entry 4446 (class 2606 OID 22282)
-- Name: products products_model_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_model_id_fkey FOREIGN KEY (model_id) REFERENCES public.models(id) ON DELETE SET NULL;


--
-- TOC entry 4447 (class 2606 OID 22287)
-- Name: products products_platform_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_platform_id_fkey FOREIGN KEY (platform_id) REFERENCES public.platforms(id) ON DELETE SET NULL;


--
-- TOC entry 4448 (class 2606 OID 22292)
-- Name: products products_registered_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_registered_by_fkey FOREIGN KEY (registered_by) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- TOC entry 4450 (class 2606 OID 17583)
-- Name: reports reports_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 4449 (class 2606 OID 17568)
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- TOC entry 4468 (class 2606 OID 25981)
-- Name: shopee_product_mappings shopee_product_mappings_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopee_product_mappings
    ADD CONSTRAINT shopee_product_mappings_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4452 (class 2606 OID 22215)
-- Name: special_page_products special_page_products_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4453 (class 2606 OID 22210)
-- Name: special_page_products special_page_products_special_page_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.special_page_products
    ADD CONSTRAINT special_page_products_special_page_id_fkey FOREIGN KEY (special_page_id) REFERENCES public.special_pages(id) ON DELETE CASCADE;


--
-- TOC entry 4443 (class 2606 OID 17525)
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4454 (class 2606 OID 22248)
-- Name: wishlists wishlists_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- TOC entry 4455 (class 2606 OID 22243)
-- Name: wishlists wishlists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- TOC entry 4438 (class 2606 OID 17188)
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4439 (class 2606 OID 17235)
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4440 (class 2606 OID 17255)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- TOC entry 4441 (class 2606 OID 17250)
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- TOC entry 4442 (class 2606 OID 17319)
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- TOC entry 4638 (class 0 OID 16525)
-- Dependencies: 348
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4649 (class 0 OID 16883)
-- Dependencies: 362
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4640 (class 0 OID 16681)
-- Dependencies: 353
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4637 (class 0 OID 16518)
-- Dependencies: 347
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4644 (class 0 OID 16770)
-- Dependencies: 357
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4643 (class 0 OID 16758)
-- Dependencies: 356
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4642 (class 0 OID 16745)
-- Dependencies: 355
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4650 (class 0 OID 16933)
-- Dependencies: 363
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4636 (class 0 OID 16507)
-- Dependencies: 346
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4647 (class 0 OID 16812)
-- Dependencies: 360
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4648 (class 0 OID 16830)
-- Dependencies: 361
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4639 (class 0 OID 16533)
-- Dependencies: 349
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4641 (class 0 OID 16711)
-- Dependencies: 354
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4646 (class 0 OID 16797)
-- Dependencies: 359
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4645 (class 0 OID 16788)
-- Dependencies: 358
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4635 (class 0 OID 16495)
-- Dependencies: 344
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4711 (class 3256 OID 17621)
-- Name: banners Admin can delete banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can delete banners" ON public.banners FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4704 (class 3256 OID 17617)
-- Name: products Admin can delete products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can delete products" ON public.products FOR DELETE TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4770 (class 3256 OID 27213)
-- Name: ml_sync_logs Admin can manage ml sync logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage ml sync logs" ON public.ml_sync_logs TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4767 (class 3256 OID 27176)
-- Name: ml_tokens Admin can manage ml_tokens; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage ml_tokens" ON public.ml_tokens TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4735 (class 3256 OID 22221)
-- Name: special_page_products Admin can manage special page products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage special page products" ON public.special_page_products TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4733 (class 3256 OID 22201)
-- Name: special_pages Admin can manage special pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage special pages" ON public.special_pages TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4766 (class 3256 OID 26002)
-- Name: shopee_sync_logs Admin can manage sync logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage sync logs" ON public.shopee_sync_logs TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4737 (class 3256 OID 22233)
-- Name: whatsapp_groups Admin can manage whatsapp groups; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can manage whatsapp groups" ON public.whatsapp_groups TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role)) WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4717 (class 3256 OID 17627)
-- Name: reports Admin can update reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can update reports" ON public.reports FOR UPDATE USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4765 (class 3256 OID 26001)
-- Name: shopee_sync_logs Admin can view sync logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin can view sync logs" ON public.shopee_sync_logs FOR SELECT TO authenticated USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4715 (class 3256 OID 17625)
-- Name: reviews Admin/Editor can delete reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can delete reviews" ON public.reviews FOR DELETE USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4706 (class 3256 OID 17619)
-- Name: banners Admin/Editor can insert banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can insert banners" ON public.banners FOR INSERT TO authenticated WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4702 (class 3256 OID 17615)
-- Name: products Admin/Editor can insert products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can insert products" ON public.products FOR INSERT TO authenticated WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4726 (class 3256 OID 22141)
-- Name: brands Admin/Editor can manage brands; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage brands" ON public.brands TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4731 (class 3256 OID 22187)
-- Name: categories Admin/Editor can manage categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage categories" ON public.categories TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4728 (class 3256 OID 22159)
-- Name: models Admin/Editor can manage models; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage models" ON public.models TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4729 (class 3256 OID 22172)
-- Name: platforms Admin/Editor can manage platforms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can manage platforms" ON public.platforms TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4710 (class 3256 OID 17620)
-- Name: banners Admin/Editor can update banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can update banners" ON public.banners FOR UPDATE TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4703 (class 3256 OID 17616)
-- Name: products Admin/Editor can update products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can update products" ON public.products FOR UPDATE TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4714 (class 3256 OID 17624)
-- Name: reviews Admin/Editor can update reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can update reviews" ON public.reviews FOR UPDATE USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4716 (class 3256 OID 17626)
-- Name: reports Admin/Editor can view reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin/Editor can view reports" ON public.reports FOR SELECT USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4768 (class 3256 OID 27198)
-- Name: ml_product_mappings Admin_Editor can manage ml mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin_Editor can manage ml mappings" ON public.ml_product_mappings TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4764 (class 3256 OID 26000)
-- Name: shopee_product_mappings Admin_Editor can manage shopee mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin_Editor can manage shopee mappings" ON public.shopee_product_mappings TO authenticated USING ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role))) WITH CHECK ((public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4757 (class 3256 OID 22537)
-- Name: coupons Admins can manage coupons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage coupons" ON public.coupons TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4755 (class 3256 OID 22535)
-- Name: institutional_pages Admins can manage institutional pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage institutional pages" ON public.institutional_pages TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4745 (class 3256 OID 22401)
-- Name: newsletter_products Admins can manage newsletter products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage newsletter products" ON public.newsletter_products TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4744 (class 3256 OID 22400)
-- Name: newsletters Admins can manage newsletters; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage newsletters" ON public.newsletters TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4752 (class 3256 OID 22530)
-- Name: price_history Admins can manage price history; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage price history" ON public.price_history TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4697 (class 3256 OID 17610)
-- Name: user_roles Admins can manage roles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage roles" ON public.user_roles USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4700 (class 3256 OID 17613)
-- Name: user_roles Admins can manage user roles (Delete); Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage user roles (Delete)" ON public.user_roles FOR DELETE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4698 (class 3256 OID 17611)
-- Name: user_roles Admins can manage user roles (Insert); Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage user roles (Insert)" ON public.user_roles FOR INSERT WITH CHECK (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4699 (class 3256 OID 17612)
-- Name: user_roles Admins can manage user roles (Update); Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can manage user roles (Update)" ON public.user_roles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4695 (class 3256 OID 17608)
-- Name: profiles Admins can update any profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update any profile" ON public.profiles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4694 (class 3256 OID 17607)
-- Name: profiles Admins can update profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can update profiles" ON public.profiles FOR UPDATE USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4761 (class 3256 OID 22563)
-- Name: coupons Admins can view all coupons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all coupons" ON public.coupons FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4754 (class 3256 OID 22534)
-- Name: institutional_pages Admins can view all institutional pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all institutional pages" ON public.institutional_pages FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.user_roles
  WHERE ((user_roles.user_id = auth.uid()) AND (user_roles.role = 'admin'::public.app_role)))));


--
-- TOC entry 4691 (class 3256 OID 17604)
-- Name: profiles Admins can view all profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins can view all profiles" ON public.profiles FOR SELECT USING (public.has_role(auth.uid(), 'admin'::public.app_role));


--
-- TOC entry 4740 (class 3256 OID 22274)
-- Name: product_likes Anyone can count likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can count likes" ON public.product_likes FOR SELECT USING (true);


--
-- TOC entry 4707 (class 3256 OID 17628)
-- Name: reports Anyone can create reports with email; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can create reports with email" ON public.reports FOR INSERT WITH CHECK (((reporter_email IS NOT NULL) AND (reporter_email <> ''::text)));


--
-- TOC entry 4758 (class 3256 OID 22538)
-- Name: coupon_votes Anyone can insert coupon votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can insert coupon votes" ON public.coupon_votes FOR INSERT WITH CHECK (true);


--
-- TOC entry 4746 (class 3256 OID 22525)
-- Name: product_clicks Anyone can insert product clicks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can insert product clicks" ON public.product_clicks FOR INSERT WITH CHECK (true);


--
-- TOC entry 4748 (class 3256 OID 22527)
-- Name: product_trust_votes Anyone can insert trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can insert trust votes" ON public.product_trust_votes FOR INSERT WITH CHECK (true);


--
-- TOC entry 4762 (class 3256 OID 22564)
-- Name: coupons Anyone can update coupon reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can update coupon reports" ON public.coupons FOR UPDATE USING (true) WITH CHECK (true);


--
-- TOC entry 4705 (class 3256 OID 17618)
-- Name: banners Anyone can view active banners; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active banners" ON public.banners FOR SELECT USING (((is_active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4756 (class 3256 OID 22536)
-- Name: coupons Anyone can view active coupons; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active coupons" ON public.coupons FOR SELECT USING ((active = true));


--
-- TOC entry 4753 (class 3256 OID 22533)
-- Name: institutional_pages Anyone can view active institutional pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active institutional pages" ON public.institutional_pages FOR SELECT USING ((active = true));


--
-- TOC entry 4701 (class 3256 OID 17614)
-- Name: products Anyone can view active products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active products" ON public.products FOR SELECT USING (((is_active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role) OR public.has_role(auth.uid(), 'editor'::public.app_role)));


--
-- TOC entry 4732 (class 3256 OID 22200)
-- Name: special_pages Anyone can view active special pages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active special pages" ON public.special_pages FOR SELECT USING (((active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- TOC entry 4736 (class 3256 OID 22232)
-- Name: whatsapp_groups Anyone can view active whatsapp groups; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view active whatsapp groups" ON public.whatsapp_groups FOR SELECT USING (((active = true) OR public.has_role(auth.uid(), 'admin'::public.app_role)));


--
-- TOC entry 4725 (class 3256 OID 22140)
-- Name: brands Anyone can view brands; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view brands" ON public.brands FOR SELECT USING (true);


--
-- TOC entry 4730 (class 3256 OID 22186)
-- Name: categories Anyone can view categories; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view categories" ON public.categories FOR SELECT USING (true);


--
-- TOC entry 4759 (class 3256 OID 22539)
-- Name: coupon_votes Anyone can view coupon votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view coupon votes" ON public.coupon_votes FOR SELECT USING (true);


--
-- TOC entry 4769 (class 3256 OID 27199)
-- Name: ml_product_mappings Anyone can view ml mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view ml mappings" ON public.ml_product_mappings FOR SELECT USING (true);


--
-- TOC entry 4727 (class 3256 OID 22158)
-- Name: models Anyone can view models; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view models" ON public.models FOR SELECT USING (true);


--
-- TOC entry 4718 (class 3256 OID 22171)
-- Name: platforms Anyone can view platforms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view platforms" ON public.platforms FOR SELECT USING (true);


--
-- TOC entry 4750 (class 3256 OID 22529)
-- Name: price_history Anyone can view price history; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view price history" ON public.price_history FOR SELECT USING (true);


--
-- TOC entry 4747 (class 3256 OID 22526)
-- Name: product_clicks Anyone can view product clicks; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view product clicks" ON public.product_clicks FOR SELECT USING (true);


--
-- TOC entry 4712 (class 3256 OID 17622)
-- Name: reviews Anyone can view reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view reviews" ON public.reviews FOR SELECT USING (true);


--
-- TOC entry 4763 (class 3256 OID 25999)
-- Name: shopee_product_mappings Anyone can view shopee mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view shopee mappings" ON public.shopee_product_mappings FOR SELECT USING (true);


--
-- TOC entry 4734 (class 3256 OID 22220)
-- Name: special_page_products Anyone can view special page products; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view special page products" ON public.special_page_products FOR SELECT USING (true);


--
-- TOC entry 4749 (class 3256 OID 22528)
-- Name: product_trust_votes Anyone can view trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Anyone can view trust votes" ON public.product_trust_votes FOR SELECT USING (true);


--
-- TOC entry 4713 (class 3256 OID 17623)
-- Name: reviews Authenticated can insert reviews; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Authenticated can insert reviews" ON public.reviews FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4771 (class 3256 OID 28478)
-- Name: admin_settings Enable all access for authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable all access for authenticated users" ON public.admin_settings TO authenticated USING (true) WITH CHECK (true);


--
-- TOC entry 4773 (class 3256 OID 29729)
-- Name: amazon_product_mappings Enable all for authenticated users only on amazon_product_mappi; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable all for authenticated users only on amazon_product_mappi" ON public.amazon_product_mappings USING ((auth.role() = 'authenticated'::text)) WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- TOC entry 4772 (class 3256 OID 29728)
-- Name: amazon_product_mappings Enable read access for all users on amazon_product_mappings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users on amazon_product_mappings" ON public.amazon_product_mappings FOR SELECT USING (true);


--
-- TOC entry 4751 (class 3256 OID 22547)
-- Name: product_trust_votes Users can delete own trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete own trust votes" ON public.product_trust_votes FOR DELETE USING ((auth.uid() = user_id));


--
-- TOC entry 4743 (class 3256 OID 22327)
-- Name: wishlists Users can delete their own wishlists; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own wishlists" ON public.wishlists FOR DELETE TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 4692 (class 3256 OID 17605)
-- Name: profiles Users can insert own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert own profile" ON public.profiles FOR INSERT WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4742 (class 3256 OID 22326)
-- Name: wishlists Users can insert their own wishlists; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can insert their own wishlists" ON public.wishlists FOR INSERT TO authenticated WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4739 (class 3256 OID 22273)
-- Name: product_likes Users can manage own likes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can manage own likes" ON public.product_likes TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4738 (class 3256 OID 22253)
-- Name: wishlists Users can manage own wishlist; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can manage own wishlist" ON public.wishlists TO authenticated USING ((auth.uid() = user_id)) WITH CHECK ((auth.uid() = user_id));


--
-- TOC entry 4693 (class 3256 OID 17606)
-- Name: profiles Users can update own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own profile" ON public.profiles FOR UPDATE USING ((auth.uid() = user_id));


--
-- TOC entry 4760 (class 3256 OID 22546)
-- Name: product_trust_votes Users can update own trust votes; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update own trust votes" ON public.product_trust_votes FOR UPDATE USING ((auth.uid() = user_id));


--
-- TOC entry 4690 (class 3256 OID 17603)
-- Name: profiles Users can view own profile; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own profile" ON public.profiles FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4696 (class 3256 OID 17609)
-- Name: user_roles Users can view own role; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view own role" ON public.user_roles FOR SELECT USING ((auth.uid() = user_id));


--
-- TOC entry 4741 (class 3256 OID 22325)
-- Name: wishlists Users can view their own wishlists; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view their own wishlists" ON public.wishlists FOR SELECT TO authenticated USING ((auth.uid() = user_id));


--
-- TOC entry 4688 (class 0 OID 28470)
-- Dependencies: 416
-- Name: admin_settings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.admin_settings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4689 (class 0 OID 29710)
-- Dependencies: 422
-- Name: amazon_product_mappings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.amazon_product_mappings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4663 (class 0 OID 17545)
-- Dependencies: 387
-- Name: banners; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.banners ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4666 (class 0 OID 22129)
-- Dependencies: 391
-- Name: brands; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.brands ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4669 (class 0 OID 22173)
-- Dependencies: 394
-- Name: categories; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4682 (class 0 OID 22458)
-- Dependencies: 407
-- Name: coupon_votes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.coupon_votes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4681 (class 0 OID 22441)
-- Dependencies: 406
-- Name: coupons; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.coupons ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4680 (class 0 OID 22426)
-- Dependencies: 405
-- Name: institutional_pages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.institutional_pages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4686 (class 0 OID 27177)
-- Dependencies: 413
-- Name: ml_product_mappings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ml_product_mappings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4687 (class 0 OID 27200)
-- Dependencies: 414
-- Name: ml_sync_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ml_sync_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4685 (class 0 OID 27166)
-- Dependencies: 412
-- Name: ml_tokens; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.ml_tokens ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4667 (class 0 OID 22142)
-- Dependencies: 392
-- Name: models; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.models ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4678 (class 0 OID 22381)
-- Dependencies: 403
-- Name: newsletter_products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.newsletter_products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4677 (class 0 OID 22370)
-- Dependencies: 402
-- Name: newsletters; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.newsletters ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4668 (class 0 OID 22160)
-- Dependencies: 393
-- Name: platforms; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.platforms ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4679 (class 0 OID 22408)
-- Dependencies: 404
-- Name: price_history; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.price_history ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4675 (class 0 OID 22328)
-- Dependencies: 400
-- Name: product_clicks; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_clicks ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4674 (class 0 OID 22254)
-- Dependencies: 399
-- Name: product_likes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_likes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4676 (class 0 OID 22349)
-- Dependencies: 401
-- Name: product_trust_votes; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.product_trust_votes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4662 (class 0 OID 17530)
-- Dependencies: 386
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4660 (class 0 OID 17503)
-- Dependencies: 384
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4665 (class 0 OID 17573)
-- Dependencies: 389
-- Name: reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reports ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4664 (class 0 OID 17557)
-- Dependencies: 388
-- Name: reviews; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4683 (class 0 OID 25968)
-- Dependencies: 408
-- Name: shopee_product_mappings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shopee_product_mappings ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4684 (class 0 OID 25986)
-- Dependencies: 409
-- Name: shopee_sync_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.shopee_sync_logs ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4671 (class 0 OID 22202)
-- Dependencies: 396
-- Name: special_page_products; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.special_page_products ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4670 (class 0 OID 22188)
-- Dependencies: 395
-- Name: special_pages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.special_pages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4661 (class 0 OID 17516)
-- Dependencies: 385
-- Name: user_roles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.user_roles ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4672 (class 0 OID 22222)
-- Dependencies: 397
-- Name: whatsapp_groups; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.whatsapp_groups ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4673 (class 0 OID 22234)
-- Dependencies: 398
-- Name: wishlists; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4659 (class 0 OID 17475)
-- Dependencies: 383
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4720 (class 3256 OID 17668)
-- Name: objects Auth Delete Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Delete Banners" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'banners'::text));


--
-- TOC entry 4724 (class 3256 OID 17672)
-- Name: objects Auth Delete Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Delete Products" ON storage.objects FOR DELETE TO authenticated USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4709 (class 3256 OID 17666)
-- Name: objects Auth Insert Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Insert Banners" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'banners'::text));


--
-- TOC entry 4722 (class 3256 OID 17670)
-- Name: objects Auth Insert Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Insert Products" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((bucket_id = 'product-images'::text));


--
-- TOC entry 4719 (class 3256 OID 17667)
-- Name: objects Auth Update Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Update Banners" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'banners'::text));


--
-- TOC entry 4723 (class 3256 OID 17671)
-- Name: objects Auth Update Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Auth Update Products" ON storage.objects FOR UPDATE TO authenticated USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4708 (class 3256 OID 17665)
-- Name: objects Public Access Banners; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public Access Banners" ON storage.objects FOR SELECT USING ((bucket_id = 'banners'::text));


--
-- TOC entry 4721 (class 3256 OID 17669)
-- Name: objects Public Access Products; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Public Access Products" ON storage.objects FOR SELECT USING ((bucket_id = 'product-images'::text));


--
-- TOC entry 4652 (class 0 OID 17167)
-- Dependencies: 374
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4656 (class 0 OID 17286)
-- Dependencies: 378
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4657 (class 0 OID 17299)
-- Dependencies: 379
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4651 (class 0 OID 17159)
-- Dependencies: 373
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4653 (class 0 OID 17177)
-- Dependencies: 375
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4654 (class 0 OID 17226)
-- Dependencies: 376
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4655 (class 0 OID 17240)
-- Dependencies: 377
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4658 (class 0 OID 17309)
-- Dependencies: 380
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- TOC entry 4775 (class 6104 OID 16426)
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- TOC entry 4774 (class 6104 OID 29677)
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: supabase_admin
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO supabase_admin;

--
-- TOC entry 4777 (class 6106 OID 29687)
-- Name: supabase_realtime price_history; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.price_history;


--
-- TOC entry 4778 (class 6106 OID 29688)
-- Name: supabase_realtime products; Type: PUBLICATION TABLE; Schema: public; Owner: postgres
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.products;


--
-- TOC entry 4776 (class 6106 OID 29678)
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: supabase_admin
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- TOC entry 4858 (class 0 OID 0)
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
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 23
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 38
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 14
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- TOC entry 4862 (class 0 OID 0)
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
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 32
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 467
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 531
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- TOC entry 4873 (class 0 OID 0)
-- Dependencies: 436
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- TOC entry 4875 (class 0 OID 0)
-- Dependencies: 448
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 477
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 504
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 492
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- TOC entry 4879 (class 0 OID 0)
-- Dependencies: 485
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- TOC entry 4880 (class 0 OID 0)
-- Dependencies: 486
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4881 (class 0 OID 0)
-- Dependencies: 460
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4882 (class 0 OID 0)
-- Dependencies: 513
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- TOC entry 4883 (class 0 OID 0)
-- Dependencies: 498
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- TOC entry 4884 (class 0 OID 0)
-- Dependencies: 457
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 441
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 502
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 438
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 546
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 542
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 463
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 519
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 426
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 440
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 527
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 507
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 538
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 501
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 465
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 461
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 520
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 431
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 522
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 444
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 533
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 529
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 471
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 466
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 455
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 516
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 518
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 468
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 521
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 517
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 545
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 482
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 447
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 523
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 541
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 532
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 514
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 473
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 509
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 430
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 445
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 454
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 493
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 456
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 524
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 487
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 496
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 525
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 442
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 469
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 530
-- Name: FUNCTION admin_delete_user(target_user_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_delete_user(target_user_id uuid) TO anon;
GRANT ALL ON FUNCTION public.admin_delete_user(target_user_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.admin_delete_user(target_user_id uuid) TO service_role;


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 427
-- Name: FUNCTION admin_update_user_email(target_user_id uuid, new_email text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) TO anon;
GRANT ALL ON FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) TO authenticated;
GRANT ALL ON FUNCTION public.admin_update_user_email(target_user_id uuid, new_email text) TO service_role;


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 429
-- Name: FUNCTION admin_update_user_role(target_user_id uuid, new_role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) TO anon;
GRANT ALL ON FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) TO authenticated;
GRANT ALL ON FUNCTION public.admin_update_user_role(target_user_id uuid, new_role public.app_role) TO service_role;


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 446
-- Name: FUNCTION calc_discount_percentage(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.calc_discount_percentage() TO anon;
GRANT ALL ON FUNCTION public.calc_discount_percentage() TO authenticated;
GRANT ALL ON FUNCTION public.calc_discount_percentage() TO service_role;


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 534
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 432
-- Name: FUNCTION has_role(_user_id uuid, _role public.app_role); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO anon;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO authenticated;
GRANT ALL ON FUNCTION public.has_role(_user_id uuid, _role public.app_role) TO service_role;


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 537
-- Name: FUNCTION increment_product_clicks(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.increment_product_clicks() TO anon;
GRANT ALL ON FUNCTION public.increment_product_clicks() TO authenticated;
GRANT ALL ON FUNCTION public.increment_product_clicks() TO service_role;


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 480
-- Name: FUNCTION log_price_change(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.log_price_change() TO anon;
GRANT ALL ON FUNCTION public.log_price_change() TO authenticated;
GRANT ALL ON FUNCTION public.log_price_change() TO service_role;


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 475
-- Name: FUNCTION update_coupons_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_coupons_updated_at() TO anon;
GRANT ALL ON FUNCTION public.update_coupons_updated_at() TO authenticated;
GRANT ALL ON FUNCTION public.update_coupons_updated_at() TO service_role;


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 511
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 526
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 528
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 464
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 494
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 453
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 451
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 479
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 435
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 495
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 437
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 452
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 499
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 474
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 489
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 428
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 348
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 368
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 362
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 353
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 347
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 357
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 356
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 355
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 365
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- TOC entry 4982 (class 0 OID 0)
-- Dependencies: 367
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- TOC entry 4983 (class 0 OID 0)
-- Dependencies: 364
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- TOC entry 4984 (class 0 OID 0)
-- Dependencies: 366
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- TOC entry 4985 (class 0 OID 0)
-- Dependencies: 363
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- TOC entry 4987 (class 0 OID 0)
-- Dependencies: 346
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- TOC entry 4989 (class 0 OID 0)
-- Dependencies: 345
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- TOC entry 4991 (class 0 OID 0)
-- Dependencies: 360
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- TOC entry 4993 (class 0 OID 0)
-- Dependencies: 361
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- TOC entry 4995 (class 0 OID 0)
-- Dependencies: 349
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- TOC entry 5000 (class 0 OID 0)
-- Dependencies: 354
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- TOC entry 5002 (class 0 OID 0)
-- Dependencies: 359
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 358
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 344
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 411
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 410
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 343
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 342
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 416
-- Name: TABLE admin_settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.admin_settings TO anon;
GRANT ALL ON TABLE public.admin_settings TO authenticated;
GRANT ALL ON TABLE public.admin_settings TO service_role;


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 384
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 385
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO anon;
GRANT ALL ON TABLE public.user_roles TO authenticated;
GRANT ALL ON TABLE public.user_roles TO service_role;


--
-- TOC entry 5016 (class 0 OID 0)
-- Dependencies: 390
-- Name: TABLE admin_users_view; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.admin_users_view TO anon;
GRANT ALL ON TABLE public.admin_users_view TO authenticated;
GRANT ALL ON TABLE public.admin_users_view TO service_role;


--
-- TOC entry 5017 (class 0 OID 0)
-- Dependencies: 422
-- Name: TABLE amazon_product_mappings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.amazon_product_mappings TO anon;
GRANT ALL ON TABLE public.amazon_product_mappings TO authenticated;
GRANT ALL ON TABLE public.amazon_product_mappings TO service_role;


--
-- TOC entry 5018 (class 0 OID 0)
-- Dependencies: 387
-- Name: TABLE banners; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.banners TO anon;
GRANT ALL ON TABLE public.banners TO authenticated;
GRANT ALL ON TABLE public.banners TO service_role;


--
-- TOC entry 5019 (class 0 OID 0)
-- Dependencies: 391
-- Name: TABLE brands; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.brands TO anon;
GRANT ALL ON TABLE public.brands TO authenticated;
GRANT ALL ON TABLE public.brands TO service_role;


--
-- TOC entry 5020 (class 0 OID 0)
-- Dependencies: 394
-- Name: TABLE categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.categories TO anon;
GRANT ALL ON TABLE public.categories TO authenticated;
GRANT ALL ON TABLE public.categories TO service_role;


--
-- TOC entry 5021 (class 0 OID 0)
-- Dependencies: 407
-- Name: TABLE coupon_votes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coupon_votes TO anon;
GRANT ALL ON TABLE public.coupon_votes TO authenticated;
GRANT ALL ON TABLE public.coupon_votes TO service_role;


--
-- TOC entry 5022 (class 0 OID 0)
-- Dependencies: 406
-- Name: TABLE coupons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.coupons TO anon;
GRANT ALL ON TABLE public.coupons TO authenticated;
GRANT ALL ON TABLE public.coupons TO service_role;


--
-- TOC entry 5023 (class 0 OID 0)
-- Dependencies: 405
-- Name: TABLE institutional_pages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.institutional_pages TO anon;
GRANT ALL ON TABLE public.institutional_pages TO authenticated;
GRANT ALL ON TABLE public.institutional_pages TO service_role;


--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 413
-- Name: TABLE ml_product_mappings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ml_product_mappings TO anon;
GRANT ALL ON TABLE public.ml_product_mappings TO authenticated;
GRANT ALL ON TABLE public.ml_product_mappings TO service_role;


--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 414
-- Name: TABLE ml_sync_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ml_sync_logs TO anon;
GRANT ALL ON TABLE public.ml_sync_logs TO authenticated;
GRANT ALL ON TABLE public.ml_sync_logs TO service_role;


--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 412
-- Name: TABLE ml_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.ml_tokens TO anon;
GRANT ALL ON TABLE public.ml_tokens TO authenticated;
GRANT ALL ON TABLE public.ml_tokens TO service_role;


--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 392
-- Name: TABLE models; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.models TO anon;
GRANT ALL ON TABLE public.models TO authenticated;
GRANT ALL ON TABLE public.models TO service_role;


--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 403
-- Name: TABLE newsletter_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.newsletter_products TO anon;
GRANT ALL ON TABLE public.newsletter_products TO authenticated;
GRANT ALL ON TABLE public.newsletter_products TO service_role;


--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 402
-- Name: TABLE newsletters; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.newsletters TO anon;
GRANT ALL ON TABLE public.newsletters TO authenticated;
GRANT ALL ON TABLE public.newsletters TO service_role;


--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 393
-- Name: TABLE platforms; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.platforms TO anon;
GRANT ALL ON TABLE public.platforms TO authenticated;
GRANT ALL ON TABLE public.platforms TO service_role;


--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 404
-- Name: TABLE price_history; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.price_history TO anon;
GRANT ALL ON TABLE public.price_history TO authenticated;
GRANT ALL ON TABLE public.price_history TO service_role;


--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 400
-- Name: TABLE product_clicks; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_clicks TO anon;
GRANT ALL ON TABLE public.product_clicks TO authenticated;
GRANT ALL ON TABLE public.product_clicks TO service_role;


--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 399
-- Name: TABLE product_likes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_likes TO anon;
GRANT ALL ON TABLE public.product_likes TO authenticated;
GRANT ALL ON TABLE public.product_likes TO service_role;


--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 401
-- Name: TABLE product_trust_votes; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.product_trust_votes TO anon;
GRANT ALL ON TABLE public.product_trust_votes TO authenticated;
GRANT ALL ON TABLE public.product_trust_votes TO service_role;


--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 386
-- Name: TABLE products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.products TO anon;
GRANT ALL ON TABLE public.products TO authenticated;
GRANT ALL ON TABLE public.products TO service_role;


--
-- TOC entry 5037 (class 0 OID 0)
-- Dependencies: 389
-- Name: TABLE reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reports TO anon;
GRANT ALL ON TABLE public.reports TO authenticated;
GRANT ALL ON TABLE public.reports TO service_role;


--
-- TOC entry 5038 (class 0 OID 0)
-- Dependencies: 388
-- Name: TABLE reviews; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.reviews TO anon;
GRANT ALL ON TABLE public.reviews TO authenticated;
GRANT ALL ON TABLE public.reviews TO service_role;


--
-- TOC entry 5039 (class 0 OID 0)
-- Dependencies: 415
-- Name: TABLE search_cache; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.search_cache TO anon;
GRANT ALL ON TABLE public.search_cache TO authenticated;
GRANT ALL ON TABLE public.search_cache TO service_role;


--
-- TOC entry 5040 (class 0 OID 0)
-- Dependencies: 408
-- Name: TABLE shopee_product_mappings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shopee_product_mappings TO anon;
GRANT ALL ON TABLE public.shopee_product_mappings TO authenticated;
GRANT ALL ON TABLE public.shopee_product_mappings TO service_role;


--
-- TOC entry 5041 (class 0 OID 0)
-- Dependencies: 409
-- Name: TABLE shopee_sync_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.shopee_sync_logs TO anon;
GRANT ALL ON TABLE public.shopee_sync_logs TO authenticated;
GRANT ALL ON TABLE public.shopee_sync_logs TO service_role;


--
-- TOC entry 5042 (class 0 OID 0)
-- Dependencies: 396
-- Name: TABLE special_page_products; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.special_page_products TO anon;
GRANT ALL ON TABLE public.special_page_products TO authenticated;
GRANT ALL ON TABLE public.special_page_products TO service_role;


--
-- TOC entry 5043 (class 0 OID 0)
-- Dependencies: 395
-- Name: TABLE special_pages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.special_pages TO anon;
GRANT ALL ON TABLE public.special_pages TO authenticated;
GRANT ALL ON TABLE public.special_pages TO service_role;


--
-- TOC entry 5044 (class 0 OID 0)
-- Dependencies: 397
-- Name: TABLE whatsapp_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.whatsapp_groups TO anon;
GRANT ALL ON TABLE public.whatsapp_groups TO authenticated;
GRANT ALL ON TABLE public.whatsapp_groups TO service_role;


--
-- TOC entry 5045 (class 0 OID 0)
-- Dependencies: 398
-- Name: TABLE wishlists; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.wishlists TO anon;
GRANT ALL ON TABLE public.wishlists TO authenticated;
GRANT ALL ON TABLE public.wishlists TO service_role;


--
-- TOC entry 5046 (class 0 OID 0)
-- Dependencies: 383
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- TOC entry 5047 (class 0 OID 0)
-- Dependencies: 417
-- Name: TABLE messages_2026_03_23; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_23 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_23 TO dashboard_user;


--
-- TOC entry 5048 (class 0 OID 0)
-- Dependencies: 418
-- Name: TABLE messages_2026_03_24; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_24 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_24 TO dashboard_user;


--
-- TOC entry 5049 (class 0 OID 0)
-- Dependencies: 419
-- Name: TABLE messages_2026_03_25; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_25 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_25 TO dashboard_user;


--
-- TOC entry 5050 (class 0 OID 0)
-- Dependencies: 420
-- Name: TABLE messages_2026_03_26; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_26 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_26 TO dashboard_user;


--
-- TOC entry 5051 (class 0 OID 0)
-- Dependencies: 421
-- Name: TABLE messages_2026_03_27; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_27 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_27 TO dashboard_user;


--
-- TOC entry 5052 (class 0 OID 0)
-- Dependencies: 423
-- Name: TABLE messages_2026_03_28; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_28 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_28 TO dashboard_user;


--
-- TOC entry 5053 (class 0 OID 0)
-- Dependencies: 424
-- Name: TABLE messages_2026_03_29; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_29 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_29 TO dashboard_user;


--
-- TOC entry 5054 (class 0 OID 0)
-- Dependencies: 425
-- Name: TABLE messages_2026_03_30; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.messages_2026_03_30 TO postgres;
GRANT ALL ON TABLE realtime.messages_2026_03_30 TO dashboard_user;


--
-- TOC entry 5055 (class 0 OID 0)
-- Dependencies: 369
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- TOC entry 5056 (class 0 OID 0)
-- Dependencies: 372
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 371
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 374
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
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 378
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 379
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 375
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
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 376
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 377
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 380
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 350
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 351
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- TOC entry 2646 (class 826 OID 16553)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2647 (class 826 OID 16554)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2645 (class 826 OID 16552)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2656 (class 826 OID 16632)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2655 (class 826 OID 16631)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- TOC entry 2654 (class 826 OID 16630)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- TOC entry 2659 (class 826 OID 16587)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2658 (class 826 OID 16586)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2657 (class 826 OID 16585)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2651 (class 826 OID 16567)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2653 (class 826 OID 16566)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2652 (class 826 OID 16565)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2638 (class 826 OID 16490)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2639 (class 826 OID 16491)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2637 (class 826 OID 16489)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2641 (class 826 OID 16493)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2636 (class 826 OID 16488)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2640 (class 826 OID 16492)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 2649 (class 826 OID 16557)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- TOC entry 2650 (class 826 OID 16558)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- TOC entry 2648 (class 826 OID 16556)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- TOC entry 2644 (class 826 OID 16546)
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- TOC entry 2643 (class 826 OID 16545)
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- TOC entry 2642 (class 826 OID 16544)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- TOC entry 3827 (class 3466 OID 16571)
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- TOC entry 3832 (class 3466 OID 16650)
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- TOC entry 3826 (class 3466 OID 16569)
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- TOC entry 3833 (class 3466 OID 16653)
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- TOC entry 3828 (class 3466 OID 16572)
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- TOC entry 3829 (class 3466 OID 16573)
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

-- Completed on 2026-03-26 23:54:03

--
-- PostgreSQL database dump complete
--

\unrestrict 5XcHDDeghSdv6ZISUNb1IcKrMwEWGoHApZVcIQoX1MhL34XMSQFMZCkJgbRzNmT

-- Completed on 2026-03-26 23:54:03

--
-- PostgreSQL database cluster dump complete
--

