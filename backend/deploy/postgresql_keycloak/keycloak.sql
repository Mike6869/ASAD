--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Debian 15.2-1.pgdg110+1)
-- Dumped by pg_dump version 16.0

-- Started on 2024-04-04 11:59:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- TOC entry 214 (class 1259 OID 16385)
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO keycloak;

--
-- TOC entry 215 (class 1259 OID 16390)
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO keycloak;

--
-- TOC entry 216 (class 1259 OID 16393)
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO keycloak;

--
-- TOC entry 217 (class 1259 OID 16397)
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO keycloak;

--
-- TOC entry 218 (class 1259 OID 16405)
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO keycloak;

--
-- TOC entry 219 (class 1259 OID 16408)
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO keycloak;

--
-- TOC entry 220 (class 1259 OID 16413)
-- Name: broker_link; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO keycloak;

--
-- TOC entry 221 (class 1259 OID 16418)
-- Name: client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO keycloak;

--
-- TOC entry 222 (class 1259 OID 16436)
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.client_attributes OWNER TO keycloak;

--
-- TOC entry 223 (class 1259 OID 16441)
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO keycloak;

--
-- TOC entry 224 (class 1259 OID 16444)
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO keycloak;

--
-- TOC entry 225 (class 1259 OID 16447)
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO keycloak;

--
-- TOC entry 226 (class 1259 OID 16450)
-- Name: client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO keycloak;

--
-- TOC entry 227 (class 1259 OID 16455)
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO keycloak;

--
-- TOC entry 228 (class 1259 OID 16460)
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO keycloak;

--
-- TOC entry 229 (class 1259 OID 16466)
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO keycloak;

--
-- TOC entry 230 (class 1259 OID 16469)
-- Name: client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO keycloak;

--
-- TOC entry 231 (class 1259 OID 16474)
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO keycloak;

--
-- TOC entry 232 (class 1259 OID 16477)
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO keycloak;

--
-- TOC entry 233 (class 1259 OID 16482)
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO keycloak;

--
-- TOC entry 234 (class 1259 OID 16485)
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO keycloak;

--
-- TOC entry 235 (class 1259 OID 16488)
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO keycloak;

--
-- TOC entry 236 (class 1259 OID 16493)
-- Name: component; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO keycloak;

--
-- TOC entry 237 (class 1259 OID 16498)
-- Name: component_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.component_config OWNER TO keycloak;

--
-- TOC entry 238 (class 1259 OID 16503)
-- Name: composite_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO keycloak;

--
-- TOC entry 239 (class 1259 OID 16506)
-- Name: credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO keycloak;

--
-- TOC entry 240 (class 1259 OID 16511)
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO keycloak;

--
-- TOC entry 241 (class 1259 OID 16516)
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO keycloak;

--
-- TOC entry 242 (class 1259 OID 16519)
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO keycloak;

--
-- TOC entry 243 (class 1259 OID 16523)
-- Name: event_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255),
    details_json_long_value text
);


ALTER TABLE public.event_entity OWNER TO keycloak;

--
-- TOC entry 244 (class 1259 OID 16528)
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO keycloak;

--
-- TOC entry 245 (class 1259 OID 16533)
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO keycloak;

--
-- TOC entry 246 (class 1259 OID 16538)
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO keycloak;

--
-- TOC entry 247 (class 1259 OID 16541)
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO keycloak;

--
-- TOC entry 248 (class 1259 OID 16546)
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO keycloak;

--
-- TOC entry 249 (class 1259 OID 16549)
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO keycloak;

--
-- TOC entry 250 (class 1259 OID 16555)
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO keycloak;

--
-- TOC entry 251 (class 1259 OID 16558)
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO keycloak;

--
-- TOC entry 252 (class 1259 OID 16563)
-- Name: federated_user; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO keycloak;

--
-- TOC entry 253 (class 1259 OID 16568)
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO keycloak;

--
-- TOC entry 254 (class 1259 OID 16574)
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO keycloak;

--
-- TOC entry 255 (class 1259 OID 16577)
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO keycloak;

--
-- TOC entry 256 (class 1259 OID 16588)
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO keycloak;

--
-- TOC entry 257 (class 1259 OID 16593)
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO keycloak;

--
-- TOC entry 258 (class 1259 OID 16598)
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO keycloak;

--
-- TOC entry 259 (class 1259 OID 16603)
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO keycloak;

--
-- TOC entry 260 (class 1259 OID 16606)
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO keycloak;

--
-- TOC entry 261 (class 1259 OID 16612)
-- Name: migration_model; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO keycloak;

--
-- TOC entry 262 (class 1259 OID 16616)
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO keycloak;

--
-- TOC entry 263 (class 1259 OID 16623)
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO keycloak;

--
-- TOC entry 264 (class 1259 OID 16629)
-- Name: policy_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO keycloak;

--
-- TOC entry 265 (class 1259 OID 16634)
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO keycloak;

--
-- TOC entry 266 (class 1259 OID 16639)
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO keycloak;

--
-- TOC entry 267 (class 1259 OID 16644)
-- Name: realm; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO keycloak;

--
-- TOC entry 268 (class 1259 OID 16677)
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO keycloak;

--
-- TOC entry 269 (class 1259 OID 16682)
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO keycloak;

--
-- TOC entry 270 (class 1259 OID 16685)
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO keycloak;

--
-- TOC entry 271 (class 1259 OID 16688)
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO keycloak;

--
-- TOC entry 272 (class 1259 OID 16691)
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO keycloak;

--
-- TOC entry 273 (class 1259 OID 16696)
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO keycloak;

--
-- TOC entry 274 (class 1259 OID 16703)
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO keycloak;

--
-- TOC entry 275 (class 1259 OID 16708)
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO keycloak;

--
-- TOC entry 276 (class 1259 OID 16711)
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO keycloak;

--
-- TOC entry 277 (class 1259 OID 16714)
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO keycloak;

--
-- TOC entry 278 (class 1259 OID 16719)
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO keycloak;

--
-- TOC entry 279 (class 1259 OID 16726)
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO keycloak;

--
-- TOC entry 280 (class 1259 OID 16732)
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO keycloak;

--
-- TOC entry 281 (class 1259 OID 16735)
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO keycloak;

--
-- TOC entry 282 (class 1259 OID 16738)
-- Name: resource_server; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode smallint NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO keycloak;

--
-- TOC entry 283 (class 1259 OID 16743)
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO keycloak;

--
-- TOC entry 284 (class 1259 OID 16748)
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy smallint,
    logic smallint,
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO keycloak;

--
-- TOC entry 285 (class 1259 OID 16753)
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO keycloak;

--
-- TOC entry 286 (class 1259 OID 16759)
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO keycloak;

--
-- TOC entry 287 (class 1259 OID 16764)
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO keycloak;

--
-- TOC entry 288 (class 1259 OID 16767)
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO keycloak;

--
-- TOC entry 289 (class 1259 OID 16772)
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO keycloak;

--
-- TOC entry 290 (class 1259 OID 16775)
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO keycloak;

--
-- TOC entry 291 (class 1259 OID 16778)
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO keycloak;

--
-- TOC entry 292 (class 1259 OID 16784)
-- Name: user_consent; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO keycloak;

--
-- TOC entry 293 (class 1259 OID 16789)
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO keycloak;

--
-- TOC entry 294 (class 1259 OID 16792)
-- Name: user_entity; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO keycloak;

--
-- TOC entry 295 (class 1259 OID 16800)
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO keycloak;

--
-- TOC entry 296 (class 1259 OID 16805)
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO keycloak;

--
-- TOC entry 297 (class 1259 OID 16810)
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO keycloak;

--
-- TOC entry 298 (class 1259 OID 16815)
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO keycloak;

--
-- TOC entry 299 (class 1259 OID 16820)
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO keycloak;

--
-- TOC entry 300 (class 1259 OID 16823)
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO keycloak;

--
-- TOC entry 301 (class 1259 OID 16827)
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO keycloak;

--
-- TOC entry 302 (class 1259 OID 16830)
-- Name: user_session; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO keycloak;

--
-- TOC entry 303 (class 1259 OID 16836)
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO keycloak;

--
-- TOC entry 304 (class 1259 OID 16841)
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO keycloak;

--
-- TOC entry 305 (class 1259 OID 16846)
-- Name: web_origins; Type: TABLE; Schema: public; Owner: keycloak
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO keycloak;

--
-- TOC entry 4122 (class 0 OID 16385)
-- Dependencies: 214
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- TOC entry 4123 (class 0 OID 16390)
-- Dependencies: 215
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- TOC entry 4124 (class 0 OID 16393)
-- Dependencies: 216
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
584d09e6-80c9-4133-9c7b-243dab30eb25	\N	auth-cookie	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	fdb2816f-3bf2-403e-a6cf-ee734a157524	2	10	f	\N	\N
037ec3aa-f810-4cfc-8a60-1534eb87487e	\N	auth-spnego	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	fdb2816f-3bf2-403e-a6cf-ee734a157524	3	20	f	\N	\N
3fb0cd3b-6d1d-42f4-8082-4c0895a58b93	\N	identity-provider-redirector	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	fdb2816f-3bf2-403e-a6cf-ee734a157524	2	25	f	\N	\N
96ced68e-4d95-4675-b960-b35c11837e07	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	fdb2816f-3bf2-403e-a6cf-ee734a157524	2	30	t	c897c405-d108-4a97-8493-acd0e3cf7c6b	\N
93980c6d-b810-4626-829d-0a085e8dc0ed	\N	auth-username-password-form	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	c897c405-d108-4a97-8493-acd0e3cf7c6b	0	10	f	\N	\N
a7c6e114-9580-4e41-a11d-1b5622f699cc	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	c897c405-d108-4a97-8493-acd0e3cf7c6b	1	20	t	ed72139c-5354-4721-af88-f7222b2bd4f7	\N
c7e11a11-081b-42e1-94ce-ba116e7890ab	\N	conditional-user-configured	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	ed72139c-5354-4721-af88-f7222b2bd4f7	0	10	f	\N	\N
b4f4f28e-6337-4d2a-9646-f6912252ffe0	\N	auth-otp-form	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	ed72139c-5354-4721-af88-f7222b2bd4f7	0	20	f	\N	\N
969adb5a-0dc4-46cb-91ed-d930ef024dda	\N	direct-grant-validate-username	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	09c8f64d-36be-45ab-983e-979e3f35729e	0	10	f	\N	\N
9bea03a6-3358-42aa-b41c-b6e52a7f0949	\N	direct-grant-validate-password	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	09c8f64d-36be-45ab-983e-979e3f35729e	0	20	f	\N	\N
6b63b9ca-e260-4675-8f97-997d5a46a287	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	09c8f64d-36be-45ab-983e-979e3f35729e	1	30	t	072edaba-7d54-4a0e-8b2a-c9da9dcd850a	\N
c5876309-7b44-49f2-94e4-51e7f6d237b7	\N	conditional-user-configured	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	072edaba-7d54-4a0e-8b2a-c9da9dcd850a	0	10	f	\N	\N
f87f74e3-5650-4011-bca5-a0cb468099c8	\N	direct-grant-validate-otp	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	072edaba-7d54-4a0e-8b2a-c9da9dcd850a	0	20	f	\N	\N
2bb12d13-9282-4c93-9a45-cc4b8d54ab85	\N	registration-page-form	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	0ca78339-815b-48e4-a7ad-c233244d7f07	0	10	t	0d407781-6b10-45ad-9582-f8f11d0b855d	\N
cc7c7db9-8402-48aa-96b9-6d8cca6682f5	\N	registration-user-creation	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	0d407781-6b10-45ad-9582-f8f11d0b855d	0	20	f	\N	\N
fd95ee26-f324-4f56-ba2b-dc67da076c5b	\N	registration-password-action	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	0d407781-6b10-45ad-9582-f8f11d0b855d	0	50	f	\N	\N
a7385507-0b90-45b1-b26b-134a58190116	\N	registration-recaptcha-action	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	0d407781-6b10-45ad-9582-f8f11d0b855d	3	60	f	\N	\N
38e64d90-fcb2-4498-af0a-c0b44b12ec47	\N	registration-terms-and-conditions	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	0d407781-6b10-45ad-9582-f8f11d0b855d	3	70	f	\N	\N
6a433d04-160a-4594-8db8-58aa2064368d	\N	reset-credentials-choose-user	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	b9a4c737-541f-41d5-8976-7560941251bb	0	10	f	\N	\N
221a285b-2172-436a-a599-19c45f4ccf3c	\N	reset-credential-email	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	b9a4c737-541f-41d5-8976-7560941251bb	0	20	f	\N	\N
68844411-3fc9-457a-be61-c1bfd33b5f82	\N	reset-password	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	b9a4c737-541f-41d5-8976-7560941251bb	0	30	f	\N	\N
7a3123d5-269f-482f-a343-95aca89c037c	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	b9a4c737-541f-41d5-8976-7560941251bb	1	40	t	1441c0bc-fb19-4a8d-bb3b-5835a075e2bc	\N
89bc9d4d-6702-47e8-a62c-1a20d1f430ce	\N	conditional-user-configured	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	1441c0bc-fb19-4a8d-bb3b-5835a075e2bc	0	10	f	\N	\N
c25ceb81-93dd-4f1a-b71d-c5c9e7fb0192	\N	reset-otp	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	1441c0bc-fb19-4a8d-bb3b-5835a075e2bc	0	20	f	\N	\N
cdf62306-373f-406d-a612-f3e91d7f00a3	\N	client-secret	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	a43a7112-d91d-4adc-88f0-9a9c91abe43b	2	10	f	\N	\N
335ae91c-b257-42ff-85e9-0f0def472c81	\N	client-jwt	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	a43a7112-d91d-4adc-88f0-9a9c91abe43b	2	20	f	\N	\N
2887653d-eedd-4918-b30d-16f3a66a4c76	\N	client-secret-jwt	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	a43a7112-d91d-4adc-88f0-9a9c91abe43b	2	30	f	\N	\N
3e0ee0ac-61a0-4e1f-9731-71802607e0ba	\N	client-x509	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	a43a7112-d91d-4adc-88f0-9a9c91abe43b	2	40	f	\N	\N
61f5a939-be6d-4e8e-9b17-7b9c38f8eedc	\N	idp-review-profile	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	dd5608a3-eb9d-4bb5-af42-57de6ecf4eab	0	10	f	\N	35c6101f-808d-4851-84f7-166756ed52d5
0c7c502a-951d-4c57-9ad6-46412af9cff2	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	dd5608a3-eb9d-4bb5-af42-57de6ecf4eab	0	20	t	4260a750-a627-4a15-967f-d9bf8bace418	\N
43b91545-db12-4d06-a9c0-fe7ae1677ac3	\N	idp-create-user-if-unique	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	4260a750-a627-4a15-967f-d9bf8bace418	2	10	f	\N	c8796ba6-456f-4ed6-8f62-fc5becf539fa
99e4738d-c689-42c7-a1b1-4c783c016ec5	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	4260a750-a627-4a15-967f-d9bf8bace418	2	20	t	f031cc4f-43ce-4f62-93f6-065af8d5ff0f	\N
fe378a90-dad3-4b80-a1a1-bfe2840a4ed6	\N	idp-confirm-link	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f031cc4f-43ce-4f62-93f6-065af8d5ff0f	0	10	f	\N	\N
4b82ed87-9776-431b-b227-2f49a7ccd24b	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f031cc4f-43ce-4f62-93f6-065af8d5ff0f	0	20	t	1cb4d017-eb2a-4abf-96ed-a63067c2b06e	\N
d64cf429-f314-43fa-a240-47d1e2b6686e	\N	idp-email-verification	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	1cb4d017-eb2a-4abf-96ed-a63067c2b06e	2	10	f	\N	\N
8fdfa47a-06c2-41bc-a62d-15266a871714	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	1cb4d017-eb2a-4abf-96ed-a63067c2b06e	2	20	t	821f6c3f-a787-49ad-b97e-f7a491ad7da6	\N
d8803b70-78cc-4b11-9087-313f8502b520	\N	idp-username-password-form	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	821f6c3f-a787-49ad-b97e-f7a491ad7da6	0	10	f	\N	\N
7a1e2552-9b46-4089-a279-d8b4aff46371	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	821f6c3f-a787-49ad-b97e-f7a491ad7da6	1	20	t	384cb3bf-7dca-4458-b631-a84fddc08c92	\N
caf6b63b-56de-4503-8671-92a867772442	\N	conditional-user-configured	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	384cb3bf-7dca-4458-b631-a84fddc08c92	0	10	f	\N	\N
966ab2d3-49e6-48e0-b9a3-54f460c34cbb	\N	auth-otp-form	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	384cb3bf-7dca-4458-b631-a84fddc08c92	0	20	f	\N	\N
fa72c187-e432-4641-9424-3134d56a3427	\N	http-basic-authenticator	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	c475139c-767e-40aa-9154-3b176c8dc479	0	10	f	\N	\N
466bb230-8d19-4f79-8fd6-8e828384e390	\N	docker-http-basic-authenticator	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	2c6d133d-0e6f-4b1a-84f3-0faf74f0e80e	0	10	f	\N	\N
56ac47c1-585c-44ff-942f-d299abc6a723	\N	auth-cookie	e79a028c-615a-4cf7-8850-e49274b70888	410756cc-f22c-4b6f-b3be-3cb7540628ca	2	10	f	\N	\N
f5091f82-13c0-41e8-bcee-7f2883e987b8	\N	auth-spnego	e79a028c-615a-4cf7-8850-e49274b70888	410756cc-f22c-4b6f-b3be-3cb7540628ca	3	20	f	\N	\N
dccd0638-d273-490c-bb13-0018d3821f6d	\N	identity-provider-redirector	e79a028c-615a-4cf7-8850-e49274b70888	410756cc-f22c-4b6f-b3be-3cb7540628ca	2	25	f	\N	\N
c7a8d7de-5135-4626-8d8d-3b419859b8df	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	410756cc-f22c-4b6f-b3be-3cb7540628ca	2	30	t	947c2a61-f04b-45a9-917a-d7b4371c106c	\N
8bacace9-c01e-46c9-ab6f-4ef08e77c627	\N	auth-username-password-form	e79a028c-615a-4cf7-8850-e49274b70888	947c2a61-f04b-45a9-917a-d7b4371c106c	0	10	f	\N	\N
8cb891dc-beb5-4bdc-a0fd-4bac7ad52a6a	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	947c2a61-f04b-45a9-917a-d7b4371c106c	1	20	t	47be9ca1-8b7a-4961-9205-b45ebec4440a	\N
f836d4b5-5075-4426-a5da-3be28848dd0c	\N	conditional-user-configured	e79a028c-615a-4cf7-8850-e49274b70888	47be9ca1-8b7a-4961-9205-b45ebec4440a	0	10	f	\N	\N
edf1a7eb-164b-449b-a485-25dd1068238a	\N	auth-otp-form	e79a028c-615a-4cf7-8850-e49274b70888	47be9ca1-8b7a-4961-9205-b45ebec4440a	0	20	f	\N	\N
52a6a663-c2cb-46ec-86ca-9cb2f67bc829	\N	direct-grant-validate-username	e79a028c-615a-4cf7-8850-e49274b70888	4c8ff1ef-142f-433e-8d73-e5c1cd66087e	0	10	f	\N	\N
75554637-23ec-45bf-a8bb-ca011d5f2905	\N	direct-grant-validate-password	e79a028c-615a-4cf7-8850-e49274b70888	4c8ff1ef-142f-433e-8d73-e5c1cd66087e	0	20	f	\N	\N
982a48a0-74c6-4da2-85f4-31802422b82a	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	4c8ff1ef-142f-433e-8d73-e5c1cd66087e	1	30	t	689a52a2-66a0-4b2c-8516-2d46225930e9	\N
05b787b9-aefd-4977-b0ae-ae7bc65468b6	\N	conditional-user-configured	e79a028c-615a-4cf7-8850-e49274b70888	689a52a2-66a0-4b2c-8516-2d46225930e9	0	10	f	\N	\N
0b35d78a-bf3a-4012-a2d4-d4f3876c53f0	\N	direct-grant-validate-otp	e79a028c-615a-4cf7-8850-e49274b70888	689a52a2-66a0-4b2c-8516-2d46225930e9	0	20	f	\N	\N
98d324a3-c923-4570-81d3-0d8ed11e4983	\N	registration-page-form	e79a028c-615a-4cf7-8850-e49274b70888	2158f692-8d5f-457a-adad-a8304fb7d513	0	10	t	25a427f3-e74a-4501-9fd1-cc252377ac2a	\N
3bc25481-55c6-4f0a-9ad7-00b1ef1c4c7d	\N	registration-user-creation	e79a028c-615a-4cf7-8850-e49274b70888	25a427f3-e74a-4501-9fd1-cc252377ac2a	0	20	f	\N	\N
42588236-422a-4fe0-bc00-a27b7aa90513	\N	registration-password-action	e79a028c-615a-4cf7-8850-e49274b70888	25a427f3-e74a-4501-9fd1-cc252377ac2a	0	50	f	\N	\N
0a867749-f986-415d-83fe-b3b3cd66a189	\N	registration-recaptcha-action	e79a028c-615a-4cf7-8850-e49274b70888	25a427f3-e74a-4501-9fd1-cc252377ac2a	3	60	f	\N	\N
f24abee2-6cb8-46fd-a35c-f9e9a9244fbd	\N	reset-credentials-choose-user	e79a028c-615a-4cf7-8850-e49274b70888	6806780a-d1f0-4d85-b639-372dbba9ccfa	0	10	f	\N	\N
dc550483-4983-4710-969f-452826ca5557	\N	reset-credential-email	e79a028c-615a-4cf7-8850-e49274b70888	6806780a-d1f0-4d85-b639-372dbba9ccfa	0	20	f	\N	\N
4d082315-bfdd-42a1-bfc9-2406f24195a3	\N	reset-password	e79a028c-615a-4cf7-8850-e49274b70888	6806780a-d1f0-4d85-b639-372dbba9ccfa	0	30	f	\N	\N
1a72c9c0-d754-45bc-ba5c-1c27a8f4cd06	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	6806780a-d1f0-4d85-b639-372dbba9ccfa	1	40	t	1a51409b-cc05-4539-b681-b661bdfab42b	\N
3c466a70-579d-4ddd-b985-0408661e9dbf	\N	conditional-user-configured	e79a028c-615a-4cf7-8850-e49274b70888	1a51409b-cc05-4539-b681-b661bdfab42b	0	10	f	\N	\N
1e21573d-3c1d-43f2-9646-597e3a7c7d71	\N	reset-otp	e79a028c-615a-4cf7-8850-e49274b70888	1a51409b-cc05-4539-b681-b661bdfab42b	0	20	f	\N	\N
86162b58-6991-4e26-aed6-1e346bbd581b	\N	client-secret	e79a028c-615a-4cf7-8850-e49274b70888	ee07cb62-63ee-4f5b-bc81-899620cb0e46	2	10	f	\N	\N
c1ba10ec-458b-4cb4-bb45-0533543d19cd	\N	client-jwt	e79a028c-615a-4cf7-8850-e49274b70888	ee07cb62-63ee-4f5b-bc81-899620cb0e46	2	20	f	\N	\N
ebeed3b6-f04e-4891-87c0-3cf883911af3	\N	client-secret-jwt	e79a028c-615a-4cf7-8850-e49274b70888	ee07cb62-63ee-4f5b-bc81-899620cb0e46	2	30	f	\N	\N
7a34d6bb-4ac8-4b55-8d97-dd150a8dd449	\N	client-x509	e79a028c-615a-4cf7-8850-e49274b70888	ee07cb62-63ee-4f5b-bc81-899620cb0e46	2	40	f	\N	\N
b2730c75-e5c0-42cc-8ed3-c00aeb740726	\N	idp-review-profile	e79a028c-615a-4cf7-8850-e49274b70888	be15aac6-9b78-4471-9b34-b2c9a3daac76	0	10	f	\N	21b3786b-eea0-4dbc-ac09-59a6bb1a7d8d
676183bb-d7de-4e34-932c-aa6c915558d6	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	be15aac6-9b78-4471-9b34-b2c9a3daac76	0	20	t	b913cb46-5ece-432a-8285-0fc8687a4d22	\N
f40bf124-4429-4819-8848-ad4333a8bf98	\N	idp-create-user-if-unique	e79a028c-615a-4cf7-8850-e49274b70888	b913cb46-5ece-432a-8285-0fc8687a4d22	2	10	f	\N	75bd3c67-4ba4-42ec-8fd8-7b6a020263d4
f6dfab7d-34a2-4a4f-b69d-9acb7222fbe2	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	b913cb46-5ece-432a-8285-0fc8687a4d22	2	20	t	68c359df-2e3e-4f8f-b982-096f13bf5ddc	\N
e1845cd2-82a6-4726-975e-4d6eb88eafb5	\N	idp-confirm-link	e79a028c-615a-4cf7-8850-e49274b70888	68c359df-2e3e-4f8f-b982-096f13bf5ddc	0	10	f	\N	\N
393ad10e-3ec7-4f1e-af71-469c3a272b17	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	68c359df-2e3e-4f8f-b982-096f13bf5ddc	0	20	t	cf4d7b16-d51a-492e-88a7-23246de807fa	\N
88e8a27e-f624-4e6f-8a06-aab6636875c1	\N	idp-email-verification	e79a028c-615a-4cf7-8850-e49274b70888	cf4d7b16-d51a-492e-88a7-23246de807fa	2	10	f	\N	\N
bf7c7a8e-0bbf-4739-86ad-3df70d45c260	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	cf4d7b16-d51a-492e-88a7-23246de807fa	2	20	t	0be781bb-5fe6-4a90-8c4c-23295bddd6f3	\N
fee2834c-eab2-482f-8fd2-f97d6e3d453f	\N	idp-username-password-form	e79a028c-615a-4cf7-8850-e49274b70888	0be781bb-5fe6-4a90-8c4c-23295bddd6f3	0	10	f	\N	\N
98f3249c-388f-4027-8db7-b72ce7541675	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	0be781bb-5fe6-4a90-8c4c-23295bddd6f3	1	20	t	fcebb7c3-8072-40ec-bf9e-720ed14444e5	\N
6cfa7eba-7a36-4036-8bd4-b4151a7f3254	\N	conditional-user-configured	e79a028c-615a-4cf7-8850-e49274b70888	fcebb7c3-8072-40ec-bf9e-720ed14444e5	0	10	f	\N	\N
e8b82188-f6cc-439d-bd88-5e8fcbead0e9	\N	auth-otp-form	e79a028c-615a-4cf7-8850-e49274b70888	fcebb7c3-8072-40ec-bf9e-720ed14444e5	0	20	f	\N	\N
3480ac32-4a3d-45ed-882d-6057e40dbd23	\N	http-basic-authenticator	e79a028c-615a-4cf7-8850-e49274b70888	246003b1-ead5-43b9-aca3-551919d02898	0	10	f	\N	\N
d010cc9c-5f33-4b5e-9e23-a44f00a5947f	\N	docker-http-basic-authenticator	e79a028c-615a-4cf7-8850-e49274b70888	ac9bcd99-eb4d-4a2d-8c10-ce5820db8b2f	0	10	f	\N	\N
\.


--
-- TOC entry 4125 (class 0 OID 16397)
-- Dependencies: 217
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
fdb2816f-3bf2-403e-a6cf-ee734a157524	browser	browser based authentication	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
c897c405-d108-4a97-8493-acd0e3cf7c6b	forms	Username, password, otp and other auth forms.	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
ed72139c-5354-4721-af88-f7222b2bd4f7	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
09c8f64d-36be-45ab-983e-979e3f35729e	direct grant	OpenID Connect Resource Owner Grant	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
072edaba-7d54-4a0e-8b2a-c9da9dcd850a	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
0ca78339-815b-48e4-a7ad-c233244d7f07	registration	registration flow	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
0d407781-6b10-45ad-9582-f8f11d0b855d	registration form	registration form	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	form-flow	f	t
b9a4c737-541f-41d5-8976-7560941251bb	reset credentials	Reset credentials for a user if they forgot their password or something	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
1441c0bc-fb19-4a8d-bb3b-5835a075e2bc	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
a43a7112-d91d-4adc-88f0-9a9c91abe43b	clients	Base authentication for clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	client-flow	t	t
dd5608a3-eb9d-4bb5-af42-57de6ecf4eab	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
4260a750-a627-4a15-967f-d9bf8bace418	User creation or linking	Flow for the existing/non-existing user alternatives	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
f031cc4f-43ce-4f62-93f6-065af8d5ff0f	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
1cb4d017-eb2a-4abf-96ed-a63067c2b06e	Account verification options	Method with which to verity the existing account	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
821f6c3f-a787-49ad-b97e-f7a491ad7da6	Verify Existing Account by Re-authentication	Reauthentication of existing account	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
384cb3bf-7dca-4458-b631-a84fddc08c92	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	f	t
c475139c-767e-40aa-9154-3b176c8dc479	saml ecp	SAML ECP Profile Authentication Flow	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
2c6d133d-0e6f-4b1a-84f3-0faf74f0e80e	docker auth	Used by Docker clients to authenticate against the IDP	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	basic-flow	t	t
410756cc-f22c-4b6f-b3be-3cb7540628ca	browser	browser based authentication	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
947c2a61-f04b-45a9-917a-d7b4371c106c	forms	Username, password, otp and other auth forms.	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
47be9ca1-8b7a-4961-9205-b45ebec4440a	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
4c8ff1ef-142f-433e-8d73-e5c1cd66087e	direct grant	OpenID Connect Resource Owner Grant	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
689a52a2-66a0-4b2c-8516-2d46225930e9	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
2158f692-8d5f-457a-adad-a8304fb7d513	registration	registration flow	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
25a427f3-e74a-4501-9fd1-cc252377ac2a	registration form	registration form	e79a028c-615a-4cf7-8850-e49274b70888	form-flow	f	t
6806780a-d1f0-4d85-b639-372dbba9ccfa	reset credentials	Reset credentials for a user if they forgot their password or something	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
1a51409b-cc05-4539-b681-b661bdfab42b	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
ee07cb62-63ee-4f5b-bc81-899620cb0e46	clients	Base authentication for clients	e79a028c-615a-4cf7-8850-e49274b70888	client-flow	t	t
be15aac6-9b78-4471-9b34-b2c9a3daac76	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
b913cb46-5ece-432a-8285-0fc8687a4d22	User creation or linking	Flow for the existing/non-existing user alternatives	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
68c359df-2e3e-4f8f-b982-096f13bf5ddc	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
cf4d7b16-d51a-492e-88a7-23246de807fa	Account verification options	Method with which to verity the existing account	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
0be781bb-5fe6-4a90-8c4c-23295bddd6f3	Verify Existing Account by Re-authentication	Reauthentication of existing account	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
fcebb7c3-8072-40ec-bf9e-720ed14444e5	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	f	t
246003b1-ead5-43b9-aca3-551919d02898	saml ecp	SAML ECP Profile Authentication Flow	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
ac9bcd99-eb4d-4a2d-8c10-ce5820db8b2f	docker auth	Used by Docker clients to authenticate against the IDP	e79a028c-615a-4cf7-8850-e49274b70888	basic-flow	t	t
\.


--
-- TOC entry 4126 (class 0 OID 16405)
-- Dependencies: 218
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
35c6101f-808d-4851-84f7-166756ed52d5	review profile config	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576
c8796ba6-456f-4ed6-8f62-fc5becf539fa	create unique user config	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576
21b3786b-eea0-4dbc-ac09-59a6bb1a7d8d	review profile config	e79a028c-615a-4cf7-8850-e49274b70888
75bd3c67-4ba4-42ec-8fd8-7b6a020263d4	create unique user config	e79a028c-615a-4cf7-8850-e49274b70888
\.


--
-- TOC entry 4127 (class 0 OID 16408)
-- Dependencies: 219
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
35c6101f-808d-4851-84f7-166756ed52d5	missing	update.profile.on.first.login
c8796ba6-456f-4ed6-8f62-fc5becf539fa	false	require.password.update.after.registration
21b3786b-eea0-4dbc-ac09-59a6bb1a7d8d	missing	update.profile.on.first.login
75bd3c67-4ba4-42ec-8fd8-7b6a020263d4	false	require.password.update.after.registration
\.


--
-- TOC entry 4128 (class 0 OID 16413)
-- Dependencies: 220
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- TOC entry 4129 (class 0 OID 16418)
-- Dependencies: 221
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
7c9f997b-7e37-4849-8110-6b2374f15399	t	f	master-realm	0	f	\N	\N	t	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
352ffebc-61f6-4559-8273-dc37678f202c	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
e4cb5111-b259-47d0-8a21-d01b0232264b	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	t	f	broker	0	f	\N	\N	t	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
2a4712b8-affa-4ae0-a56d-93263b4a881f	t	f	admin-cli	0	t	\N	\N	f	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	f	doc-analysis-realm	0	f	\N	\N	t	\N	f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	0	f	f	doc-analysis Realm	f	client-secret	\N	\N	\N	t	f	f	f
c0a3244c-5e71-420c-a23a-0116a1db716f	t	f	realm-management	0	f	\N	\N	t	\N	f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	0	f	f	${client_realm-management}	f	client-secret	\N	\N	\N	t	f	f	f
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	f	account	0	t	\N	/realms/doc-analysis/account/	f	\N	f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
cd13309d-ade7-4da3-9e23-4578525d91dd	t	f	account-console	0	t	\N	/realms/doc-analysis/account/	f	\N	f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
ce54bcea-da57-477e-a372-b6798b722c44	t	f	broker	0	f	\N	\N	t	\N	f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
046748c7-389d-4b7f-8c0d-858f48da46f8	t	f	security-admin-console	0	t	\N	/admin/doc-analysis/console/	f	\N	f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
79e3b0cf-6700-46d6-a376-49ea340a5a16	t	f	admin-cli	0	t	\N	\N	f	\N	f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
e8cbcfbc-caa1-482e-a719-599f9ea03e88	t	t	react-client	0	t	\N		f		f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	-1	t	f	React Client	f	client-secret		Frontend (React) client	\N	t	f	f	f
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	t	t	dev-client	0	f	wEkcFsrzFE86K9S7j7v1kn8PfQo8PIkx		f		f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	-1	t	f	Client for development	f	client-secret			\N	t	f	t	f
d3610fe9-5387-4fb2-b30c-ee6309fe5742	t	t	flask-client	0	f	ZsmvdYqx52ghSYKoqVAbnFH3xZkN2IYz	http://127.0.0.1:5001	f		f	e79a028c-615a-4cf7-8850-e49274b70888	openid-connect	-1	t	f	Flask Client	t	client-secret	http://127.0.0.1:5001		\N	f	f	t	f
\.


--
-- TOC entry 4130 (class 0 OID 16436)
-- Dependencies: 222
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_attributes (client_id, name, value) FROM stdin;
352ffebc-61f6-4559-8273-dc37678f202c	post.logout.redirect.uris	+
e4cb5111-b259-47d0-8a21-d01b0232264b	post.logout.redirect.uris	+
e4cb5111-b259-47d0-8a21-d01b0232264b	pkce.code.challenge.method	S256
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	post.logout.redirect.uris	+
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	pkce.code.challenge.method	S256
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	post.logout.redirect.uris	+
cd13309d-ade7-4da3-9e23-4578525d91dd	post.logout.redirect.uris	+
cd13309d-ade7-4da3-9e23-4578525d91dd	pkce.code.challenge.method	S256
046748c7-389d-4b7f-8c0d-858f48da46f8	post.logout.redirect.uris	+
046748c7-389d-4b7f-8c0d-858f48da46f8	pkce.code.challenge.method	S256
e8cbcfbc-caa1-482e-a719-599f9ea03e88	client.secret.creation.time	1706193435
e8cbcfbc-caa1-482e-a719-599f9ea03e88	oauth2.device.authorization.grant.enabled	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	oidc.ciba.grant.enabled	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	backchannel.logout.session.required	true
e8cbcfbc-caa1-482e-a719-599f9ea03e88	backchannel.logout.revoke.offline.tokens	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	display.on.consent.screen	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	use.refresh.tokens	true
e8cbcfbc-caa1-482e-a719-599f9ea03e88	client_credentials.use_refresh_token	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	token.response.type.bearer.lower-case	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	tls.client.certificate.bound.access.tokens	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	pkce.code.challenge.method	S256
e8cbcfbc-caa1-482e-a719-599f9ea03e88	require.pushed.authorization.requests	false
e8cbcfbc-caa1-482e-a719-599f9ea03e88	acr.loa.map	{}
d3610fe9-5387-4fb2-b30c-ee6309fe5742	client.secret.creation.time	1706194421
d3610fe9-5387-4fb2-b30c-ee6309fe5742	oauth2.device.authorization.grant.enabled	false
d3610fe9-5387-4fb2-b30c-ee6309fe5742	oidc.ciba.grant.enabled	false
d3610fe9-5387-4fb2-b30c-ee6309fe5742	backchannel.logout.session.required	true
d3610fe9-5387-4fb2-b30c-ee6309fe5742	backchannel.logout.revoke.offline.tokens	false
d3610fe9-5387-4fb2-b30c-ee6309fe5742	display.on.consent.screen	false
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	client.secret.creation.time	1707912708
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	oauth2.device.authorization.grant.enabled	false
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	oidc.ciba.grant.enabled	false
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	backchannel.logout.session.required	true
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	backchannel.logout.revoke.offline.tokens	false
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	display.on.consent.screen	false
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	post.logout.redirect.uris	/*
\.


--
-- TOC entry 4131 (class 0 OID 16441)
-- Dependencies: 223
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- TOC entry 4132 (class 0 OID 16444)
-- Dependencies: 224
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- TOC entry 4133 (class 0 OID 16447)
-- Dependencies: 225
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- TOC entry 4134 (class 0 OID 16450)
-- Dependencies: 226
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	offline_access	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect built-in scope: offline_access	openid-connect
9cb2d3f5-61cc-4d9a-85b1-f28c911bbe90	role_list	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	SAML role list	saml
b73496be-314e-48cb-926a-d11e6dd88cd2	profile	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect built-in scope: profile	openid-connect
52e10ef0-5620-47d7-a89a-c800b7d6998b	email	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect built-in scope: email	openid-connect
b32a7337-695a-4b60-be9d-a538ad72abfc	address	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect built-in scope: address	openid-connect
7d3b937d-0d48-42d9-8db9-1451b154ff2e	phone	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect built-in scope: phone	openid-connect
a3c2889f-b8aa-4ff2-b992-604934f57dda	roles	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect scope for add user roles to the access token	openid-connect
29b11608-7d74-49c4-9155-788f107f5a12	web-origins	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect scope for add allowed web origins to the access token	openid-connect
aa5ec348-d155-4909-9a13-4ad95bedee23	microprofile-jwt	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	Microprofile - JWT built-in scope	openid-connect
37acc24e-f3a1-430c-8624-bd74e2f7f5d4	acr	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
e590b491-6ada-495b-a830-ff28429cb619	offline_access	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect built-in scope: offline_access	openid-connect
6ba6afd0-d8e5-4d12-a4bb-a1ca869540c4	role_list	e79a028c-615a-4cf7-8850-e49274b70888	SAML role list	saml
f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	profile	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect built-in scope: profile	openid-connect
0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	email	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect built-in scope: email	openid-connect
0083ae97-ba80-4c79-9baa-9addd3c4c688	address	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect built-in scope: address	openid-connect
ce4f907c-b147-413f-bc74-2ad284138816	phone	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect built-in scope: phone	openid-connect
1d9b3046-a8f8-4524-8675-6d12e6cbab04	roles	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect scope for add user roles to the access token	openid-connect
380abffc-0088-40ed-a1a6-5b70e8b081fc	web-origins	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect scope for add allowed web origins to the access token	openid-connect
7c0d75e2-4146-43a6-a782-b21b4409f4b3	microprofile-jwt	e79a028c-615a-4cf7-8850-e49274b70888	Microprofile - JWT built-in scope	openid-connect
16998a60-6487-4163-b2b3-4823acba5115	acr	e79a028c-615a-4cf7-8850-e49274b70888	OpenID Connect scope for add acr (authentication context class reference) to the token	openid-connect
\.


--
-- TOC entry 4135 (class 0 OID 16455)
-- Dependencies: 227
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	true	display.on.consent.screen
9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	${offlineAccessScopeConsentText}	consent.screen.text
9cb2d3f5-61cc-4d9a-85b1-f28c911bbe90	true	display.on.consent.screen
9cb2d3f5-61cc-4d9a-85b1-f28c911bbe90	${samlRoleListScopeConsentText}	consent.screen.text
b73496be-314e-48cb-926a-d11e6dd88cd2	true	display.on.consent.screen
b73496be-314e-48cb-926a-d11e6dd88cd2	${profileScopeConsentText}	consent.screen.text
b73496be-314e-48cb-926a-d11e6dd88cd2	true	include.in.token.scope
52e10ef0-5620-47d7-a89a-c800b7d6998b	true	display.on.consent.screen
52e10ef0-5620-47d7-a89a-c800b7d6998b	${emailScopeConsentText}	consent.screen.text
52e10ef0-5620-47d7-a89a-c800b7d6998b	true	include.in.token.scope
b32a7337-695a-4b60-be9d-a538ad72abfc	true	display.on.consent.screen
b32a7337-695a-4b60-be9d-a538ad72abfc	${addressScopeConsentText}	consent.screen.text
b32a7337-695a-4b60-be9d-a538ad72abfc	true	include.in.token.scope
7d3b937d-0d48-42d9-8db9-1451b154ff2e	true	display.on.consent.screen
7d3b937d-0d48-42d9-8db9-1451b154ff2e	${phoneScopeConsentText}	consent.screen.text
7d3b937d-0d48-42d9-8db9-1451b154ff2e	true	include.in.token.scope
a3c2889f-b8aa-4ff2-b992-604934f57dda	true	display.on.consent.screen
a3c2889f-b8aa-4ff2-b992-604934f57dda	${rolesScopeConsentText}	consent.screen.text
a3c2889f-b8aa-4ff2-b992-604934f57dda	false	include.in.token.scope
29b11608-7d74-49c4-9155-788f107f5a12	false	display.on.consent.screen
29b11608-7d74-49c4-9155-788f107f5a12		consent.screen.text
29b11608-7d74-49c4-9155-788f107f5a12	false	include.in.token.scope
aa5ec348-d155-4909-9a13-4ad95bedee23	false	display.on.consent.screen
aa5ec348-d155-4909-9a13-4ad95bedee23	true	include.in.token.scope
37acc24e-f3a1-430c-8624-bd74e2f7f5d4	false	display.on.consent.screen
37acc24e-f3a1-430c-8624-bd74e2f7f5d4	false	include.in.token.scope
e590b491-6ada-495b-a830-ff28429cb619	true	display.on.consent.screen
e590b491-6ada-495b-a830-ff28429cb619	${offlineAccessScopeConsentText}	consent.screen.text
6ba6afd0-d8e5-4d12-a4bb-a1ca869540c4	true	display.on.consent.screen
6ba6afd0-d8e5-4d12-a4bb-a1ca869540c4	${samlRoleListScopeConsentText}	consent.screen.text
f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	true	display.on.consent.screen
f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	${profileScopeConsentText}	consent.screen.text
f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	true	include.in.token.scope
0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	true	display.on.consent.screen
0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	${emailScopeConsentText}	consent.screen.text
0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	true	include.in.token.scope
0083ae97-ba80-4c79-9baa-9addd3c4c688	true	display.on.consent.screen
0083ae97-ba80-4c79-9baa-9addd3c4c688	${addressScopeConsentText}	consent.screen.text
0083ae97-ba80-4c79-9baa-9addd3c4c688	true	include.in.token.scope
ce4f907c-b147-413f-bc74-2ad284138816	true	display.on.consent.screen
ce4f907c-b147-413f-bc74-2ad284138816	${phoneScopeConsentText}	consent.screen.text
ce4f907c-b147-413f-bc74-2ad284138816	true	include.in.token.scope
1d9b3046-a8f8-4524-8675-6d12e6cbab04	true	display.on.consent.screen
1d9b3046-a8f8-4524-8675-6d12e6cbab04	${rolesScopeConsentText}	consent.screen.text
1d9b3046-a8f8-4524-8675-6d12e6cbab04	false	include.in.token.scope
380abffc-0088-40ed-a1a6-5b70e8b081fc	false	display.on.consent.screen
380abffc-0088-40ed-a1a6-5b70e8b081fc		consent.screen.text
380abffc-0088-40ed-a1a6-5b70e8b081fc	false	include.in.token.scope
7c0d75e2-4146-43a6-a782-b21b4409f4b3	false	display.on.consent.screen
7c0d75e2-4146-43a6-a782-b21b4409f4b3	true	include.in.token.scope
16998a60-6487-4163-b2b3-4823acba5115	false	display.on.consent.screen
16998a60-6487-4163-b2b3-4823acba5115	false	include.in.token.scope
\.


--
-- TOC entry 4136 (class 0 OID 16460)
-- Dependencies: 228
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
352ffebc-61f6-4559-8273-dc37678f202c	29b11608-7d74-49c4-9155-788f107f5a12	t
352ffebc-61f6-4559-8273-dc37678f202c	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
352ffebc-61f6-4559-8273-dc37678f202c	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
352ffebc-61f6-4559-8273-dc37678f202c	b73496be-314e-48cb-926a-d11e6dd88cd2	t
352ffebc-61f6-4559-8273-dc37678f202c	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
352ffebc-61f6-4559-8273-dc37678f202c	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
352ffebc-61f6-4559-8273-dc37678f202c	b32a7337-695a-4b60-be9d-a538ad72abfc	f
352ffebc-61f6-4559-8273-dc37678f202c	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
352ffebc-61f6-4559-8273-dc37678f202c	aa5ec348-d155-4909-9a13-4ad95bedee23	f
e4cb5111-b259-47d0-8a21-d01b0232264b	29b11608-7d74-49c4-9155-788f107f5a12	t
e4cb5111-b259-47d0-8a21-d01b0232264b	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
e4cb5111-b259-47d0-8a21-d01b0232264b	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
e4cb5111-b259-47d0-8a21-d01b0232264b	b73496be-314e-48cb-926a-d11e6dd88cd2	t
e4cb5111-b259-47d0-8a21-d01b0232264b	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
e4cb5111-b259-47d0-8a21-d01b0232264b	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
e4cb5111-b259-47d0-8a21-d01b0232264b	b32a7337-695a-4b60-be9d-a538ad72abfc	f
e4cb5111-b259-47d0-8a21-d01b0232264b	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
e4cb5111-b259-47d0-8a21-d01b0232264b	aa5ec348-d155-4909-9a13-4ad95bedee23	f
2a4712b8-affa-4ae0-a56d-93263b4a881f	29b11608-7d74-49c4-9155-788f107f5a12	t
2a4712b8-affa-4ae0-a56d-93263b4a881f	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
2a4712b8-affa-4ae0-a56d-93263b4a881f	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
2a4712b8-affa-4ae0-a56d-93263b4a881f	b73496be-314e-48cb-926a-d11e6dd88cd2	t
2a4712b8-affa-4ae0-a56d-93263b4a881f	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
2a4712b8-affa-4ae0-a56d-93263b4a881f	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
2a4712b8-affa-4ae0-a56d-93263b4a881f	b32a7337-695a-4b60-be9d-a538ad72abfc	f
2a4712b8-affa-4ae0-a56d-93263b4a881f	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
2a4712b8-affa-4ae0-a56d-93263b4a881f	aa5ec348-d155-4909-9a13-4ad95bedee23	f
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	29b11608-7d74-49c4-9155-788f107f5a12	t
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	b73496be-314e-48cb-926a-d11e6dd88cd2	t
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	b32a7337-695a-4b60-be9d-a538ad72abfc	f
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
2ada4a55-53f6-4d89-bc00-01b458bcc3d0	aa5ec348-d155-4909-9a13-4ad95bedee23	f
7c9f997b-7e37-4849-8110-6b2374f15399	29b11608-7d74-49c4-9155-788f107f5a12	t
7c9f997b-7e37-4849-8110-6b2374f15399	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
7c9f997b-7e37-4849-8110-6b2374f15399	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
7c9f997b-7e37-4849-8110-6b2374f15399	b73496be-314e-48cb-926a-d11e6dd88cd2	t
7c9f997b-7e37-4849-8110-6b2374f15399	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
7c9f997b-7e37-4849-8110-6b2374f15399	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
7c9f997b-7e37-4849-8110-6b2374f15399	b32a7337-695a-4b60-be9d-a538ad72abfc	f
7c9f997b-7e37-4849-8110-6b2374f15399	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
7c9f997b-7e37-4849-8110-6b2374f15399	aa5ec348-d155-4909-9a13-4ad95bedee23	f
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	29b11608-7d74-49c4-9155-788f107f5a12	t
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	b73496be-314e-48cb-926a-d11e6dd88cd2	t
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	b32a7337-695a-4b60-be9d-a538ad72abfc	f
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	aa5ec348-d155-4909-9a13-4ad95bedee23	f
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	16998a60-6487-4163-b2b3-4823acba5115	t
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	e590b491-6ada-495b-a830-ff28429cb619	f
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	ce4f907c-b147-413f-bc74-2ad284138816	f
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
cd13309d-ade7-4da3-9e23-4578525d91dd	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
cd13309d-ade7-4da3-9e23-4578525d91dd	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
cd13309d-ade7-4da3-9e23-4578525d91dd	16998a60-6487-4163-b2b3-4823acba5115	t
cd13309d-ade7-4da3-9e23-4578525d91dd	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
cd13309d-ade7-4da3-9e23-4578525d91dd	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
cd13309d-ade7-4da3-9e23-4578525d91dd	e590b491-6ada-495b-a830-ff28429cb619	f
cd13309d-ade7-4da3-9e23-4578525d91dd	ce4f907c-b147-413f-bc74-2ad284138816	f
cd13309d-ade7-4da3-9e23-4578525d91dd	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
cd13309d-ade7-4da3-9e23-4578525d91dd	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
79e3b0cf-6700-46d6-a376-49ea340a5a16	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
79e3b0cf-6700-46d6-a376-49ea340a5a16	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
79e3b0cf-6700-46d6-a376-49ea340a5a16	16998a60-6487-4163-b2b3-4823acba5115	t
79e3b0cf-6700-46d6-a376-49ea340a5a16	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
79e3b0cf-6700-46d6-a376-49ea340a5a16	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
79e3b0cf-6700-46d6-a376-49ea340a5a16	e590b491-6ada-495b-a830-ff28429cb619	f
79e3b0cf-6700-46d6-a376-49ea340a5a16	ce4f907c-b147-413f-bc74-2ad284138816	f
79e3b0cf-6700-46d6-a376-49ea340a5a16	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
79e3b0cf-6700-46d6-a376-49ea340a5a16	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
ce54bcea-da57-477e-a372-b6798b722c44	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
ce54bcea-da57-477e-a372-b6798b722c44	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
ce54bcea-da57-477e-a372-b6798b722c44	16998a60-6487-4163-b2b3-4823acba5115	t
ce54bcea-da57-477e-a372-b6798b722c44	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
ce54bcea-da57-477e-a372-b6798b722c44	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
ce54bcea-da57-477e-a372-b6798b722c44	e590b491-6ada-495b-a830-ff28429cb619	f
ce54bcea-da57-477e-a372-b6798b722c44	ce4f907c-b147-413f-bc74-2ad284138816	f
ce54bcea-da57-477e-a372-b6798b722c44	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
ce54bcea-da57-477e-a372-b6798b722c44	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
c0a3244c-5e71-420c-a23a-0116a1db716f	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
c0a3244c-5e71-420c-a23a-0116a1db716f	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
c0a3244c-5e71-420c-a23a-0116a1db716f	16998a60-6487-4163-b2b3-4823acba5115	t
c0a3244c-5e71-420c-a23a-0116a1db716f	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
c0a3244c-5e71-420c-a23a-0116a1db716f	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
c0a3244c-5e71-420c-a23a-0116a1db716f	e590b491-6ada-495b-a830-ff28429cb619	f
c0a3244c-5e71-420c-a23a-0116a1db716f	ce4f907c-b147-413f-bc74-2ad284138816	f
c0a3244c-5e71-420c-a23a-0116a1db716f	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
c0a3244c-5e71-420c-a23a-0116a1db716f	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
046748c7-389d-4b7f-8c0d-858f48da46f8	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
046748c7-389d-4b7f-8c0d-858f48da46f8	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
046748c7-389d-4b7f-8c0d-858f48da46f8	16998a60-6487-4163-b2b3-4823acba5115	t
046748c7-389d-4b7f-8c0d-858f48da46f8	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
046748c7-389d-4b7f-8c0d-858f48da46f8	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
046748c7-389d-4b7f-8c0d-858f48da46f8	e590b491-6ada-495b-a830-ff28429cb619	f
046748c7-389d-4b7f-8c0d-858f48da46f8	ce4f907c-b147-413f-bc74-2ad284138816	f
046748c7-389d-4b7f-8c0d-858f48da46f8	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
046748c7-389d-4b7f-8c0d-858f48da46f8	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
e8cbcfbc-caa1-482e-a719-599f9ea03e88	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
e8cbcfbc-caa1-482e-a719-599f9ea03e88	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
e8cbcfbc-caa1-482e-a719-599f9ea03e88	16998a60-6487-4163-b2b3-4823acba5115	t
e8cbcfbc-caa1-482e-a719-599f9ea03e88	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
e8cbcfbc-caa1-482e-a719-599f9ea03e88	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
e8cbcfbc-caa1-482e-a719-599f9ea03e88	e590b491-6ada-495b-a830-ff28429cb619	f
e8cbcfbc-caa1-482e-a719-599f9ea03e88	ce4f907c-b147-413f-bc74-2ad284138816	f
e8cbcfbc-caa1-482e-a719-599f9ea03e88	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
e8cbcfbc-caa1-482e-a719-599f9ea03e88	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
d3610fe9-5387-4fb2-b30c-ee6309fe5742	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
d3610fe9-5387-4fb2-b30c-ee6309fe5742	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
d3610fe9-5387-4fb2-b30c-ee6309fe5742	16998a60-6487-4163-b2b3-4823acba5115	t
d3610fe9-5387-4fb2-b30c-ee6309fe5742	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
d3610fe9-5387-4fb2-b30c-ee6309fe5742	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
d3610fe9-5387-4fb2-b30c-ee6309fe5742	e590b491-6ada-495b-a830-ff28429cb619	f
d3610fe9-5387-4fb2-b30c-ee6309fe5742	ce4f907c-b147-413f-bc74-2ad284138816	f
d3610fe9-5387-4fb2-b30c-ee6309fe5742	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
d3610fe9-5387-4fb2-b30c-ee6309fe5742	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	16998a60-6487-4163-b2b3-4823acba5115	t
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	e590b491-6ada-495b-a830-ff28429cb619	f
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	ce4f907c-b147-413f-bc74-2ad284138816	f
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
\.


--
-- TOC entry 4137 (class 0 OID 16466)
-- Dependencies: 229
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	8df41d99-d1b8-4148-a892-556ba268d0fb
e590b491-6ada-495b-a830-ff28429cb619	a567c65a-d764-4436-af73-e3722c5c496b
\.


--
-- TOC entry 4138 (class 0 OID 16469)
-- Dependencies: 230
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- TOC entry 4139 (class 0 OID 16474)
-- Dependencies: 231
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- TOC entry 4140 (class 0 OID 16477)
-- Dependencies: 232
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- TOC entry 4141 (class 0 OID 16482)
-- Dependencies: 233
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- TOC entry 4142 (class 0 OID 16485)
-- Dependencies: 234
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- TOC entry 4143 (class 0 OID 16488)
-- Dependencies: 235
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- TOC entry 4144 (class 0 OID 16493)
-- Dependencies: 236
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
9224bf74-eff9-4b66-b905-461288ec934a	Trusted Hosts	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	anonymous
33f32d5c-8836-4f9f-aba1-0574f3e16b7d	Consent Required	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	anonymous
5e909b7a-c370-4955-a59d-8e59d8156178	Full Scope Disabled	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	anonymous
c5f93691-ffb2-4a04-9fc7-a7673134dad1	Max Clients Limit	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	anonymous
86028bfc-8674-4978-bd9b-c669ca2430f7	Allowed Protocol Mapper Types	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	anonymous
e2a7e910-18b9-452e-9187-51fb2b933200	Allowed Client Scopes	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	anonymous
22b27f3c-2ef3-4647-9aef-a00a18da00d3	Allowed Protocol Mapper Types	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	authenticated
df596244-3e47-4a14-9394-9deead3d6ced	Allowed Client Scopes	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	authenticated
9d5323a4-3851-4a97-b6aa-57d4e6cd28af	rsa-generated	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	rsa-generated	org.keycloak.keys.KeyProvider	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N
8c843976-7909-4ccc-9d48-011a9a05d958	rsa-enc-generated	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	rsa-enc-generated	org.keycloak.keys.KeyProvider	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N
d8afc5d4-0855-4989-b490-5fdc7846404d	hmac-generated	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	hmac-generated	org.keycloak.keys.KeyProvider	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N
0e3085ee-137f-4a35-b2c6-4ce6f20a9a0d	aes-generated	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	aes-generated	org.keycloak.keys.KeyProvider	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N
537f92c9-b4c0-41c6-9386-47aced1706db	rsa-generated	e79a028c-615a-4cf7-8850-e49274b70888	rsa-generated	org.keycloak.keys.KeyProvider	e79a028c-615a-4cf7-8850-e49274b70888	\N
826f271c-291f-47f1-be0b-ec29aa27dfcf	rsa-enc-generated	e79a028c-615a-4cf7-8850-e49274b70888	rsa-enc-generated	org.keycloak.keys.KeyProvider	e79a028c-615a-4cf7-8850-e49274b70888	\N
50d9712b-8c9a-4ae4-87e7-5171ce09545c	hmac-generated	e79a028c-615a-4cf7-8850-e49274b70888	hmac-generated	org.keycloak.keys.KeyProvider	e79a028c-615a-4cf7-8850-e49274b70888	\N
c2894392-f481-46f5-ba23-4641cb2a93b1	aes-generated	e79a028c-615a-4cf7-8850-e49274b70888	aes-generated	org.keycloak.keys.KeyProvider	e79a028c-615a-4cf7-8850-e49274b70888	\N
42f41e53-4225-4a12-a4bf-a1b3eae0dd25	Trusted Hosts	e79a028c-615a-4cf7-8850-e49274b70888	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	anonymous
9d15531d-b663-475e-b987-ec4ac140453f	Consent Required	e79a028c-615a-4cf7-8850-e49274b70888	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	anonymous
891d693b-b22d-49ad-99db-7578650d4fd7	Full Scope Disabled	e79a028c-615a-4cf7-8850-e49274b70888	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	anonymous
bc5464ad-2ad6-4eae-9ddd-71fd20fec5bd	Max Clients Limit	e79a028c-615a-4cf7-8850-e49274b70888	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	anonymous
9794a4da-94c5-4699-bd54-0b979ee05db9	Allowed Protocol Mapper Types	e79a028c-615a-4cf7-8850-e49274b70888	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	anonymous
cab455db-1f80-4b56-8275-25d291d665c2	Allowed Client Scopes	e79a028c-615a-4cf7-8850-e49274b70888	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	anonymous
886bf95a-1518-4529-9dda-c1476c5ace50	Allowed Protocol Mapper Types	e79a028c-615a-4cf7-8850-e49274b70888	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	authenticated
08e55acf-0df1-482b-a311-c2247ab22f72	Allowed Client Scopes	e79a028c-615a-4cf7-8850-e49274b70888	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	e79a028c-615a-4cf7-8850-e49274b70888	authenticated
\.


--
-- TOC entry 4145 (class 0 OID 16498)
-- Dependencies: 237
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
afce14cd-6bbc-4431-a1f4-c7a25cd6f776	c5f93691-ffb2-4a04-9fc7-a7673134dad1	max-clients	200
06f0df36-c2dd-46b4-8103-978c34f99a1e	e2a7e910-18b9-452e-9187-51fb2b933200	allow-default-scopes	true
31ea89e3-0206-4932-a9a5-7cc007c032b6	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	saml-role-list-mapper
a697c98b-b7b0-4dbf-944d-6bb0381d980a	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
9c10992c-851a-4890-bb01-bde21eefa71e	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	oidc-full-name-mapper
6f7ad178-aafe-4cf6-b82d-27ac0d1147ff	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
7b8567f8-ebaf-4fc1-88a5-c8f280ba525a	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
6d8a2f16-bf16-45a6-8d04-35a986d339db	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	saml-user-property-mapper
e374226f-b136-4c0a-9da1-e7994c1c17d0	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	oidc-address-mapper
2dda8e77-e411-40b8-8c82-5c6ddf658922	86028bfc-8674-4978-bd9b-c669ca2430f7	allowed-protocol-mapper-types	saml-user-attribute-mapper
e24c0b69-22a7-44d6-beb0-2a1fcfd848d3	9224bf74-eff9-4b66-b905-461288ec934a	client-uris-must-match	true
96efdb60-a88c-43d9-a5fe-5d5fb298f618	9224bf74-eff9-4b66-b905-461288ec934a	host-sending-registration-request-must-match	true
a1bee8ca-aad0-424b-8aa5-41c1a4b62eda	df596244-3e47-4a14-9394-9deead3d6ced	allow-default-scopes	true
a061e57a-f195-40bc-9a24-99979a0dffc5	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
cb87007f-52a6-4dd2-8ff0-6b79a08b4d07	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	saml-user-property-mapper
66b39c80-1e34-4636-8016-311d0b39114f	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	oidc-full-name-mapper
e8f24251-b094-4f9f-89f8-4898c9cbc17a	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
b3ac541c-df87-48c0-a893-f3d4183011b1	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	saml-role-list-mapper
4fda19b3-488b-41a4-b4ff-f4879278575b	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	saml-user-attribute-mapper
9a894e46-55bf-4e7f-be08-17cf43d108dc	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
44a79095-3424-402c-94d8-19be73cabc48	22b27f3c-2ef3-4647-9aef-a00a18da00d3	allowed-protocol-mapper-types	oidc-address-mapper
c7558922-637d-4407-ba97-acd927b8b571	0e3085ee-137f-4a35-b2c6-4ce6f20a9a0d	kid	0570479a-4f72-47f8-a37b-955c07465823
1ca436a3-a515-4770-925e-7ed49b3b9e42	0e3085ee-137f-4a35-b2c6-4ce6f20a9a0d	secret	FAtsfr2A597qlDmdDjSnyQ
8ebc89a4-dcc2-4f5e-9ee0-21e87070e26e	0e3085ee-137f-4a35-b2c6-4ce6f20a9a0d	priority	100
0247b2ac-9937-4c3f-9270-e44d6c0a1e43	9d5323a4-3851-4a97-b6aa-57d4e6cd28af	certificate	MIICmzCCAYMCBgGNO9+8oTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwMTI0MTQyNzE1WhcNMzQwMTI0MTQyODU1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCrDe0exoX2IR1EUqm5ne31jssW+7a31vwgxCUUxobmi2/e9OfE5mcEgL+OlmBGcm04x5emZBK3ldB2gB4KUox6n4ecM3ELaCHFfB7A3Zlly1cKVbJJMYEW0F0Bgdvt+4hCsZCjjgbvb+8YV7K3QkudfL4dmdxUcGCRjJJnZregGH7N1vVVaqseMnImJOhhtvWWdGzKvkqDqKr7HduLOKs+9PvHFRT9Btiu87sjN59IyeaD5nRtV2+2PMkzA7jbiwTaDsLwwDeBLdoy8nOGDg1WLBDN3HO5XejgqdSpmhcoJbRSjh1qcs0IbwSwV4Xi+iaUq8VHzrT4jJpNe2mXRzsPAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAFUL5jLGdthRkebjLLQN0eE33CjkO0QQRig2pebUHijkjk3WKNFvne8eA3nICGSQLyEyJcwgKivwoIAqGzFHIi3akAJQI8WKGhE4skM5vv9qiBc1he3sWwmngw7wW4ZGeWFyxQLviNt0kHJuG/hT1vGyDl7m+a4DB2vatpi3oASE10SekGj3umGxyap597P4MtS7k7Gpps1eqHYs+aDwq3zQRj9ORO1kf1yF3VtzyYpjEh346VJmGUrxdoEQ5tzjEH0c4wV9IBTm7xPAg6YaKceMTxZBJJJkYG5URF4D7D1Fhe+wrzIDT94kJBHnXLg9/6Bhy99QTk8yt07dbhYKpoo=
5d7c7c39-c7af-48bc-8cee-f4b8f81c806a	9d5323a4-3851-4a97-b6aa-57d4e6cd28af	privateKey	MIIEowIBAAKCAQEAqw3tHsaF9iEdRFKpuZ3t9Y7LFvu2t9b8IMQlFMaG5otv3vTnxOZnBIC/jpZgRnJtOMeXpmQSt5XQdoAeClKMep+HnDNxC2ghxXwewN2ZZctXClWySTGBFtBdAYHb7fuIQrGQo44G72/vGFeyt0JLnXy+HZncVHBgkYySZ2a3oBh+zdb1VWqrHjJyJiToYbb1lnRsyr5Kg6iq+x3bizirPvT7xxUU/QbYrvO7IzefSMnmg+Z0bVdvtjzJMwO424sE2g7C8MA3gS3aMvJzhg4NViwQzdxzuV3o4KnUqZoXKCW0Uo4danLNCG8EsFeF4vomlKvFR860+IyaTXtpl0c7DwIDAQABAoIBAA4ofm50LyVis0ny76Jx/H69PXkfB44q6L6LjagtEIBnnTBepAprqa45O+HA96INGZZACwDWOqhgaZtNWm8vSvphVveqWFqB2X2/msoK7YX78S3lTvb49n7daz1TMtF9ZtdiXB71hARwhuFEbQH3JkwYRaIsmIySqqORd5LAcUV6bsSW+4P85Ko2ZQfzDU0E1LAd7C7QmXy8eOGpIFBNEHIs9bMtLCnsw30L3Ak1SppY0TAb1OT++/WVK3qrf5UXG1ru6IZjZOL0YSw1YLRAOUcsgrwC3UWVSKAhyGeu+eWI2jJXZdBpRNQnav1c4nH7ONbj8FhnZwC86TqhMeCmuFUCgYEA5gIwWNOCm5DXhFuaUX8JGGLq1m8/2GlL5uJF27Y8ea6YfqorVEsdqSpGk/VU8dLZ5eVwiHlorkD9eH2yEnXOcwkmw8e35l3RC9/NnOhfJcPyaWWNcFUUNKd3bHn2kSpIScbkZPeyHbFQtjMTObbDLn/SdqPzbkjORqnk2hz1RnUCgYEAvmJHrVVQKXTP1riUlSLPAfGaa9M1wPiAyuL45O9rTG3eEFNzcll5XX5WB8TXYjpiI0MqDu5kpYo+A7hRGGmG17UY0fVuMbz20LQxzAngkvtnyioOWFeXHV/CFc/Rgm2VUUm6v/wOwUD5HIuqqznwqNauoiHl7C/Od+e3GZKYsvMCgYB4sQtXgN0W7mD4dey6+NL39efOT6AL2ezXIUKQ8MY4/5HLXVXRLH1K6AES4HgLUJ3AEa4EHtj8HuQiVqqbHzAOku3Ba8om2nG4Ll7BB/ntYi2QepZGLI6mtn1m8XSdZbd65x+vj33qMMHuaUycSzeN7cqtMIirBQ8ga0PH48wchQKBgQCCdP4AvHENt0mkLR9DgnKvNktGj5hJ/v7iB93domG4IaEFNuno9X7Ang19jVi5qqAM4b00Ng8pkC0mh2qqe8U2kpXLaY507rOCF7f3xNzqWvOoCGGED6ExM6jfIWTDJywmY4tgeuvxaQBKmzn70twiFdncp7XRvoCQkWtaTqXsGQKBgFXNe/6YqIZ6/UAm78H9/jj7eY/Us2aBg6h1if+PG5YFVKObsEnjnQJBrrPOIzKjTgp8Dpi8Iub6BshPurAvqZ6kRDLkpE9m+3LnbZdzQhV7X4NlU3ZhuS692Ltg8tSBtvTWQ37M9CcmAuPwyeg5g7my8e3PxhSdNLyCPJ+zQkGJ
42a4144c-8a6d-4c10-83fc-3d93a558299d	9d5323a4-3851-4a97-b6aa-57d4e6cd28af	priority	100
e39ddd6f-d944-42d1-8748-83dbcbe21f83	9d5323a4-3851-4a97-b6aa-57d4e6cd28af	keyUse	SIG
427d6161-da9d-4a5b-951e-f11e68c2b454	d8afc5d4-0855-4989-b490-5fdc7846404d	secret	4KUNQx8xHHsTVL65yNCUybbNXdHgsV7HpVmkGk_dFPlSC7jpKZ9435h43mBT-Uk1h2ntBoE6ZslnRe_qieBLeA
060488fa-5727-4c74-b3a7-c2a313942081	d8afc5d4-0855-4989-b490-5fdc7846404d	priority	100
97edf3c8-205a-45e6-8417-b45ee6c94223	d8afc5d4-0855-4989-b490-5fdc7846404d	algorithm	HS256
b47f9e9d-286f-45da-9005-e19ab77bda04	d8afc5d4-0855-4989-b490-5fdc7846404d	kid	c8aa4663-17ea-4b0b-a7a2-8b19cc40b938
ceca9d3e-b484-4603-89c9-11526566afca	8c843976-7909-4ccc-9d48-011a9a05d958	keyUse	ENC
e8b76a3a-e67a-4972-ae44-7e6477f91ff8	8c843976-7909-4ccc-9d48-011a9a05d958	certificate	MIICmzCCAYMCBgGNO9+9hzANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjQwMTI0MTQyNzE1WhcNMzQwMTI0MTQyODU1WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDemqzM+6Fd23BjlU4+jyfsCGaPU9faawrn+9ovNY4Tkv7lyu6erjnYPAuCohroUTnBpEa5Jyb1TTzWYOKEqylEqTsTOAMmgMz8ajD7CrYGKFYJsGBBpzZs0yQgxak+kjKO3lR8p9sGlo1yA475EUk0TYnU5ddCAlcVjK9hqMbLtwNq2hDMWMN806I199Sf/OP+T//pjIEf86jOEryziYnly3wrRFLevSX3pG1PPI0/U9k+QAnVUWHlES+y+e0D+JBPjrZy3cBhMmfGNQPpgb9tGIH0PQJFu1thk/eZZMY0FYDf38nOOvCae7rz/SHRsWxljDkpi+zyZqP3b5SwqFZFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAMgOo0/FtEMx13h0Pr4HftpZ8t8J1/uvcEM3qpirO2jjgWtmOh+dwMMEZtIi+N8mAVP9wlv/bWImRfDnbRCnyJsMXsx+eIbMjIqBZq6naR9e0bi9FgLZWXpzIdyHIyXBkM9DwWaa1CiPx2CDfHgCGxADNgyKYyFV4qpUsBXrndKi5/KD1wUb/RIE3SOWv8OI1LP2ujYIg0ndHtSXQgd67cHbI0jJ1pnx2QsOlqWOSl65JCYobXzXQ8padHGRjtMytwmCoMqPb7iGeUa3N1T4sobrVL4pD/5ZtmkAaTHCp47fHnpkPCYHVPQeeTalnMOG+NYdxC2/D+cfekKThM5dbtM=
3f573699-ab14-406b-834e-3ec941c52f59	8c843976-7909-4ccc-9d48-011a9a05d958	privateKey	MIIEpAIBAAKCAQEA3pqszPuhXdtwY5VOPo8n7Ahmj1PX2msK5/vaLzWOE5L+5crunq452DwLgqIa6FE5waRGuScm9U081mDihKspRKk7EzgDJoDM/Gow+wq2BihWCbBgQac2bNMkIMWpPpIyjt5UfKfbBpaNcgOO+RFJNE2J1OXXQgJXFYyvYajGy7cDatoQzFjDfNOiNffUn/zj/k//6YyBH/OozhK8s4mJ5ct8K0RS3r0l96RtTzyNP1PZPkAJ1VFh5REvsvntA/iQT462ct3AYTJnxjUD6YG/bRiB9D0CRbtbYZP3mWTGNBWA39/Jzjrwmnu68/0h0bFsZYw5KYvs8maj92+UsKhWRQIDAQABAoIBABKxsyrYw/W1oMPgLUzAKXZfQzusqx8255jRVAKscPTQXrMuHml5kLaJ3l6XXgKeFadfNChG8zTdCmungcZp+GKBgspLpSoV3YEiKuBeRyiPuSABrae90uqDNdDBwMOWNAQ/BCHe19w/Bvxo85gTnU306AsWzUPIHgebg7wEGEPRv9zvG7egOIURa05Er+VwoEA2rJwec27DrRD2s+KkG5FWm2AQF6HpUF3FCvG/QSRN/8JODkijvjJNUFyyBeciLwav0trRU6c/K10Hd/M2NX7hTzL3mE96chEV8isexALsUzxD7wm90Hj+mH9F7QB7zBhfn8HMeJ+pIegnJGyORcECgYEA/lPDsPciBP8bplRwzxDgol71FzaKtJ+x0QrfMfgyV2HGHMs3xW+tEfd8ZGIlbWtXQVijNKw8cW0AzM+pGZoozu3B8JTrVRSs6cuX/0mCPk5pHnatPPvWNN4ApqBx2xRzYyjHiI7ygald4hDgztsqDMCS+Kw15yb2eRtFkDEi4wUCgYEA4BF+1lDTtabT+ruPmIlab7OpbrES6dpQerGSXgElfNjgjwJNVkeuBp+/z5WfpbcSZMmVyB2sTXuWQb8ZNs5P5LElz1ZrtH8aDUdPiezL5jyRUFZTQUd83VK5S2k2fy39iA2URQeozMTbB9ZVpq4pqwMShqu5DdLkRjJi/kp8ikECgYEAu/LLO4xm56pflJvyghPG7jeeiHkWKEWb8xBFwXfaPBlVfxHvNUlCbXSnyMd/QU2CPhhzBAoE4Q3c+X69SN5UKhgqqtBi2Y1d+6kpus9oIQNxS8IIZHj35Dnr4TfQ7EZAv5bzXkfFj2zKpLY0bKoqeSIXew5JB3oTy4wL7HNjhMECgYBt7EdULozeBbziuZcFlwSV3gbV9eq4bNCkkG6kzV0ttVvc7J0yIbIfL8mytc1/R6OvbDGd3ejEjke1c2GUQHxzTfClmdj20I/gScacfF2/UqFbTy5CzSZVkZqzgycoF1DUqQy/HLXT1xM48g5M2g45BiXViXMcdARm55sm8zXLwQKBgQDWC7qKtjT1vYEiLsmJOAHm3SRFqeIN3nFh5Og036VDAs5Z7CUrCrRA+TPxtmerd1ctNvy2PlpMR236FwkAcIumuxDpxLp9DRt5usxfRyFDvd1i4UmMv/rEG2NP1cwVt0av+TmQ7o0WpclTO2aGKj5m6np8GosBrfyOogrvm0/T8Q==
af5d83c3-db6d-4dab-b359-82f409249242	8c843976-7909-4ccc-9d48-011a9a05d958	algorithm	RSA-OAEP
78da94de-4cd9-4ce9-be1c-e40758288571	8c843976-7909-4ccc-9d48-011a9a05d958	priority	100
8dd4483e-a30e-4192-a41e-b471ebb3f218	826f271c-291f-47f1-be0b-ec29aa27dfcf	keyUse	ENC
67543b81-18d6-466f-9d31-4366373665a6	826f271c-291f-47f1-be0b-ec29aa27dfcf	algorithm	RSA-OAEP
d5f0c40f-160f-439c-912a-b2fefd2fe480	826f271c-291f-47f1-be0b-ec29aa27dfcf	certificate	MIICpzCCAY8CBgGNQQc/XjANBgkqhkiG9w0BAQsFADAXMRUwEwYDVQQDDAxkb2MtYW5hbHlzaXMwHhcNMjQwMTI1MTQyODMwWhcNMzQwMTI1MTQzMDEwWjAXMRUwEwYDVQQDDAxkb2MtYW5hbHlzaXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDT3KglRw5Bgiscqb+CkqeZek1L2gwMBhnRLOn6R7g5SbzfQABZoA+ydq38EZMmtfMiNrbDl13BuzsGc+iggVKYgM8vs+Z43gffX/m3IsddMv6kHzyMF6Ci03Qr675zeIFaaIccCbM90GTKq72B+EO4ZcK4pn5kiHaKB1rAkVQUoCcmbZUFKpgG6h+dUQQRpIbRpA/7GZvuqnL/5LGpyn1Pmdk73Dg+3zcbHIyrCItc2tjS6gldxIYjgvzWQRpXEWMcyP3OST9tNckWMnNX9Z6jgW81E1mXKDhFFYGzlmArOqm38E3ZbKLgzZ7R4oEAOyBe2cOo2h3a5AuO6goB2mQFAgMBAAEwDQYJKoZIhvcNAQELBQADggEBABlDrh3WWYOZqFdKNfoMLNtbMVNuO09q1sAw1e77w2yqo/mHw3Y2vkyg5Ox+aUyxnedXUFGgOLYXhFjQcZobbMw+OQGL9QBE4NAjPFwfXHZeTNRRGwNFasIe00LGG8hHQGZjID5HrL9MHpLJLjGeeCIRLM5p3unQQJQAnwAFE9tLdMOx+2xx3YNE3RT8c/OIvZHH7TVJfYrt9wKDOLnUNngzDo/cu8ckxZGrnyJ61w9RMHTpU0oE37XxfszIoBfJw0lQ9QpU8KOg0p83TJOfiTPw4YXiGfiaVHeb7HnRzCrFkxn8daUWHmA1p2SR5rVQzsrlazDTm3bpVTwDW2StRAo=
5ff13cce-2099-40b4-97d1-e0189fc89ec9	826f271c-291f-47f1-be0b-ec29aa27dfcf	priority	100
e900e485-c971-4674-bd6f-267b5c394237	826f271c-291f-47f1-be0b-ec29aa27dfcf	privateKey	MIIEpAIBAAKCAQEA09yoJUcOQYIrHKm/gpKnmXpNS9oMDAYZ0Szp+ke4OUm830AAWaAPsnat/BGTJrXzIja2w5ddwbs7BnPooIFSmIDPL7PmeN4H31/5tyLHXTL+pB88jBegotN0K+u+c3iBWmiHHAmzPdBkyqu9gfhDuGXCuKZ+ZIh2igdawJFUFKAnJm2VBSqYBuofnVEEEaSG0aQP+xmb7qpy/+Sxqcp9T5nZO9w4Pt83GxyMqwiLXNrY0uoJXcSGI4L81kEaVxFjHMj9zkk/bTXJFjJzV/Weo4FvNRNZlyg4RRWBs5ZgKzqpt/BN2Wyi4M2e0eKBADsgXtnDqNod2uQLjuoKAdpkBQIDAQABAoIBAAj+YJSdM1Wkabbwssyfc/tv2xj++OIdc9pIHTz5b0Xeo49Y8hrb5gawreVEjA9e4SMg7k8XyCG0VHFgmW26MlrUeax1UdxBf//jcmBBRZ7RznMCUMmZVYGhVy4SdsuD6v5+76CzqGGq93hjZCsAsm6WbUwgOenZIX/DB6nN5uNC2bCzlKiuy60EjG0p+/IBB6CHoxIGqpLRGso5RezzaaPy5oDg3Z8h2aYpT1vi26QW3QaZcJ66vO0sjhG3TrjR+XBcoslo+wX2kJ42opDe9FDCIuGHFDhPgHKkWyKZdN7bSm9Vf1I26mumshaYlVd1yJVyD6tT8i++fBUyn0TmvMkCgYEA/dHg8cnmxW/1p5fQijHLQRI7OB8QuFR07lo930b7yn9QETvBkO9piDpnBIUOFN9FvFInH5XPrdCl0b7Liw2ajrrStBXvKZmAbE61AUyy/ZpI5Oo63j3Fa8qGeaBHLpEhSUTAhoracZO7qVMmyxvQDIOwRNfvs8yGSsYe3f5cpukCgYEA1a6Edf79dSnHWNyZx0j9EBSrhgiMoioL5rEp0VxfmC3/GSRJYg9RiliG9C6EGl7k7vkfjfSFb5u8WXN86VZUG4jqt+wKgv7VXoxIw0mAICF6w7oPWuZzf8bWDwzCkDSQ7S/MPWRH3Fzk5PlecvAdr9m49Ioc8CtWAE45FQHTmr0CgYEAmEGbD0+O+CbGFIeUGCHwjBM0pOC1te0ry4MklFhPWFRwojXXUmrbQlXOUD7EiK66dVJOl7rVPq3nml86WCqL6UyWcmKp+alUCSRZnfL1d/1h9revInupfpSZgEIuEPgMIJh2aP7INNNrAhKYNcR0U913EoT6DEAG2rnn8EDSMWkCgYA8/Ldfuix7ETaNXUEiyOk5erzN34jMC/YjnLMTxyqdk5s4gMvVCgw60TOLY+9eW3E5566i5IRlK2zhlv2y12ngBf8ACYWih7s8ZguqeULxaLzSOjuBtT6H3Kdh2kF5yRcIK1k+uG1uLrFBzQ6w/WlrtFd+rCDAR44fPjQ6k6/ifQKBgQDBcZlDg8qjDibALQJLnVN8KV7Ne34vHJ3VBrZls3l59XLFBIsDq1QKr/cT9dIR6XDVLR0C36oZSSu8jjn2VsCqIiCgab2peNo/7OVOUC9jCCctsymreXRqiLuJ48nq+p9Wwnb/8rLCD8mMX+YTxmZgtlLDmeC1Yu9mxJVw7kCfqw==
bd69f8b1-a352-49ef-a592-cc76a71cd513	50d9712b-8c9a-4ae4-87e7-5171ce09545c	priority	100
faf166e0-5222-4adb-b69e-b8901a740e26	50d9712b-8c9a-4ae4-87e7-5171ce09545c	secret	3NMN8jFsgycZu6CTDNlWS2kpUaqA3ZEQ2VIpIhQUKyIQChOwA-4xjqV1Ii4v4eaFvgutP_GPNUksUnCR-1MH3Q
7b49efde-5c62-43da-8502-c88ba5f46d8e	50d9712b-8c9a-4ae4-87e7-5171ce09545c	kid	ecdfdf0b-05ef-48ea-b1c4-31d8908ace57
69893d8a-4e19-44fe-9273-6382966120b0	50d9712b-8c9a-4ae4-87e7-5171ce09545c	algorithm	HS256
104330f4-fef1-40f1-abe5-c90ad2f987e1	537f92c9-b4c0-41c6-9386-47aced1706db	certificate	MIICpzCCAY8CBgGNQQc/EzANBgkqhkiG9w0BAQsFADAXMRUwEwYDVQQDDAxkb2MtYW5hbHlzaXMwHhcNMjQwMTI1MTQyODMwWhcNMzQwMTI1MTQzMDEwWjAXMRUwEwYDVQQDDAxkb2MtYW5hbHlzaXMwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDnt7PM121nxdJqZc5kmI/Jg3mfJbXETty/ETuhEyCXykBa0irjT0pOwjzfDRVz9VQheBNZev7SYWOARKuj7jdsYIOZvQ2trvtm7GLtmSQ6c2dxLIJ+5BeMvqZpReBgN2B1B2zOF124feUUqE/enE8O0MNyFNoPXCL9Bz9Mi+r5ZYQfEsWKwcegIHSlRBgSG7I5A7LLck6Gh5qHedVijv3sGyHOPV5caYDrT4qfKm+6/eknvz85Tb69kkAocrcfLT8bAdr3rZTc8kNgQYct75VzHZ8lfhS3xWNBT3r6oOjRJlYVpzpIfw5NMPycrp4rf0eva+5Ryf18DrgTiXfGh22nAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAKPaCd5EHERLCLh6LlvhktphbGq3mgEHqwEuU0EWKGOjy06mB5yENQ/ZQ5xhhvJOxAD6mxKbnFvLWZQ2a2cAB/WczKgHSRWseGO8274XSc37uJ5W91CB6aRXjJbkHUZI3fY6ILwt8Q+giDz5/FN0BV9PZtGISAwDR+6sVI8UJuKOfCsZ7sdlAS4uEAKscaQzeSmlSBUyXfh2RtjGBcdXwyPETpkVcWLEnyIvN0otjXp0LbHwTbFZi7tUatugz4sUwqYy9sPnSu5q3zmWcbXPMhVI/Zi177wozOomt2dd0/qj5SVhZG+U6sJxI2L0uInufq9w2hIbOHqwkZB+KhorBPA=
9795c46f-8590-4ef2-8b2a-5b074f327994	537f92c9-b4c0-41c6-9386-47aced1706db	keyUse	SIG
e0cfd797-3be9-49e1-851f-87e767d807b7	537f92c9-b4c0-41c6-9386-47aced1706db	priority	100
3284b8a1-e7d9-49c4-818e-a2edf7a5614a	537f92c9-b4c0-41c6-9386-47aced1706db	privateKey	MIIEogIBAAKCAQEA57ezzNdtZ8XSamXOZJiPyYN5nyW1xE7cvxE7oRMgl8pAWtIq409KTsI83w0Vc/VUIXgTWXr+0mFjgESro+43bGCDmb0Nra77Zuxi7ZkkOnNncSyCfuQXjL6maUXgYDdgdQdszhdduH3lFKhP3pxPDtDDchTaD1wi/Qc/TIvq+WWEHxLFisHHoCB0pUQYEhuyOQOyy3JOhoeah3nVYo797Bshzj1eXGmA60+Knypvuv3pJ78/OU2+vZJAKHK3Hy0/GwHa962U3PJDYEGHLe+Vcx2fJX4Ut8VjQU96+qDo0SZWFac6SH8OTTD8nK6eK39Hr2vuUcn9fA64E4l3xodtpwIDAQABAoIBABtz58Dymvsq9El3w1Kmwo5Q3dVtndHiuAOJEqP8RKXHKAW6las1pyualqSkg7Cn1a5bcAtvZ4ZcVHILcLxsyjM0YhMSU28K5q0kf3n/5Utphc1iRRmsg1/A7K1XQoSTuwFSfmESYp+rhrsCT+gjY7hxIl6/OrCMLXcF50l14EJou1fzZy+FJt8FgYwLWtema8E79+d9sO4yTw51IEPsdXVesWcnEMkVvVxJ4maDdIvt7f0gWEXh+W3rlTcbEWXofwRly9ccAjzsVbpXShnmMDcrVKuohdps2NI6OPuSPZtPdwTitaL7jVpmnk5yGsD9AGRFT7k8dLr6n44yUYlaMs0CgYEA+x2mnDSpEbTWkp0LGKiaOX+37kiNfxTnaBTtoyYqnMcVgFXTN7iqtVsJMWy3MWWEUiUw8FUCiIknRyuEKuS2JMuTUsySyp6JW7EPwzVPFc8d2Vta5dgXt1Q/9HJgcsyy4BAEnNBBNjkzRfNgjgKELfd6B7CJm/0WDAWJ3OhGAaMCgYEA7Dl231YeTX7ecjG8X2fhqpYxAedii9MthF7bsooMAXg8FtFWWqmH4m1/z1WArVEOxJcHIdR567YTAK4wUu0i4cTttUI9DS0hfFv+Gj+8JADs1hgKX1NhzFVpO0RoUQoJhAXf/TW71HxgeFQP/UxAPmOqWt22rivTDTEh/E6cjC0CgYAlx7w9XB7jrxVpUX9N4m/xnqmJjBjducNnAV8PYLqgg8NUX5U7mOj2CBBGA1k8cU2LHlVSkzeiWyAxsPZdjbNprccoeebL3TZFOUpp0Cdp3JNdFEWEtxI6Xs6QdHTWUL3IwCAxh5OIGOsB5y/rra09TTJq3cCWW2lpvZuURM3jiQKBgE9DANXzaXuLREyAz7obeybn+k2vO+u60h0GTyVbGKgtlcv6NcV5+PRK1YXWJLUC67efDW+WgcpLb5jc2a4Zj4i9sR0Ourl/GStHGr3oANL71HwJ2QEfU0NirUqLq4z1lzfLWNr3eqzThvMZEbxmJ3BHtNOEbVWHsutMPyEPp4uJAoGAPZBWDaASIWNir0gwYK1E2xUjpjEQoA6xDOHeaW7c2J60LOXcblc3Lf/6hWx9icdkZdx7BDVjbktvUu/X4TE6vsps09IpazuFidil9Pi+nviHwEBQAbH3pvRCIppnrxE55u3q9UkX/WBry45CWJ6dcv6dDynQZVM0GMarnv9CtNY=
cf7d7577-e0a3-473e-8d8f-e61532ad4c82	c2894392-f481-46f5-ba23-4641cb2a93b1	priority	100
5edc0d2c-73c2-4c51-aa6a-4fa0e757b90f	c2894392-f481-46f5-ba23-4641cb2a93b1	secret	WAUVcx1qPITOeoY8iLOaiA
3ef10550-1bb7-4554-a852-4bb5180fc2b5	c2894392-f481-46f5-ba23-4641cb2a93b1	kid	00fd14dc-40e2-4872-b21f-bafa1bd4a0b3
de15af5e-7d24-4a6a-9eb9-97b43f1b315f	cab455db-1f80-4b56-8275-25d291d665c2	allow-default-scopes	true
c97cd734-9990-46bd-a92c-d9d4678b4569	bc5464ad-2ad6-4eae-9ddd-71fd20fec5bd	max-clients	200
b3c8f7c5-c54a-460d-ae17-7eb19324aeae	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	saml-user-attribute-mapper
407e8e07-e11d-4b91-ab0a-fc8e1c64db4d	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	oidc-full-name-mapper
dc1d995e-e474-4074-b9fe-31b363f2b598	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	saml-user-property-mapper
87eabb93-0931-4b2b-8c72-cc05a6167f48	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
9920ad5a-8229-41df-9fdc-52bab67f43ad	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
35769568-3d2e-4009-9ffd-89148bae1638	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	saml-role-list-mapper
cdff96b2-f6e5-4519-925c-42050583c014	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	oidc-address-mapper
ff86c7a6-d4e7-40ad-839d-3833e6c3cdc4	9794a4da-94c5-4699-bd54-0b979ee05db9	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
6342f16f-3ac0-4725-afaf-80a794e1d8fc	42f41e53-4225-4a12-a4bf-a1b3eae0dd25	host-sending-registration-request-must-match	true
67f1bd42-dae9-4d74-a7ea-ebd470b2c95a	42f41e53-4225-4a12-a4bf-a1b3eae0dd25	client-uris-must-match	true
c7dc2fc6-06f2-446b-a590-356f5a4a8c59	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	oidc-address-mapper
549db6a0-3992-41f8-83e3-b4564f384b11	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
7a83a6c4-7aaf-4202-8bda-9fb2b2d33a52	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	saml-user-attribute-mapper
aa409ee1-bc2d-44cc-b2af-651d78fec4c9	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
16c4cf3d-ff92-4263-b35c-156972e5bea3	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	oidc-full-name-mapper
7eb5607d-87fc-4181-b067-38292306a1cf	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	saml-user-property-mapper
e86ecc9e-fe35-4a9f-b893-aea57b0111bf	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	saml-role-list-mapper
eb806176-4adf-4638-b2b3-9a6c034efcae	886bf95a-1518-4529-9dda-c1476c5ace50	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
76bfde42-d00f-4c27-a832-7b6309eb867f	08e55acf-0df1-482b-a311-c2247ab22f72	allow-default-scopes	true
\.


--
-- TOC entry 4146 (class 0 OID 16503)
-- Dependencies: 238
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.composite_role (composite, child_role) FROM stdin;
1d572f60-f5b8-4335-8067-971c475d93d5	45ba2dd0-d10c-426c-bdbd-ea6ddc700fb7
1d572f60-f5b8-4335-8067-971c475d93d5	6c687ea4-9d22-463c-ad32-4f1b9b3d9b58
1d572f60-f5b8-4335-8067-971c475d93d5	a977f6a4-4076-4f34-bd4b-ed3f94c58578
1d572f60-f5b8-4335-8067-971c475d93d5	bd03bb4a-12d8-4aaa-b3bc-3307c38d0f00
1d572f60-f5b8-4335-8067-971c475d93d5	faa9593e-2d90-4255-8f48-884017cdf07b
1d572f60-f5b8-4335-8067-971c475d93d5	753b9b46-9e41-45ad-aa1f-7478f92f1530
1d572f60-f5b8-4335-8067-971c475d93d5	b89f3b44-9370-4759-9b57-37ce08e055d8
1d572f60-f5b8-4335-8067-971c475d93d5	b5145426-c3b3-4b5a-a127-c71d73e11789
1d572f60-f5b8-4335-8067-971c475d93d5	0cb93156-3aa2-4c5e-82e8-1190f2e10772
1d572f60-f5b8-4335-8067-971c475d93d5	61cb2a12-036a-4d5c-9a0b-ce5fa1d94b7c
1d572f60-f5b8-4335-8067-971c475d93d5	61b7fdf1-b29e-45ad-af9e-6ce51afef300
1d572f60-f5b8-4335-8067-971c475d93d5	f1d2e69a-60fe-4342-a881-a3876d3707cc
1d572f60-f5b8-4335-8067-971c475d93d5	3945ffc6-bf52-4b28-841d-a4bdc8bd085b
1d572f60-f5b8-4335-8067-971c475d93d5	631ea094-1b77-4bdd-8dc6-e3594f2b8519
1d572f60-f5b8-4335-8067-971c475d93d5	98174597-ff5e-406c-919b-3a7b5ac1ecd2
1d572f60-f5b8-4335-8067-971c475d93d5	c9ffb85f-ffca-4815-a7c1-eb23953d8ee2
1d572f60-f5b8-4335-8067-971c475d93d5	29c53ae4-41c9-4f3d-aa87-bdb1736c5bc0
1d572f60-f5b8-4335-8067-971c475d93d5	b54889eb-e76b-4638-b16a-543c27c4b7d1
bd03bb4a-12d8-4aaa-b3bc-3307c38d0f00	98174597-ff5e-406c-919b-3a7b5ac1ecd2
bd03bb4a-12d8-4aaa-b3bc-3307c38d0f00	b54889eb-e76b-4638-b16a-543c27c4b7d1
c204f9da-6bb1-4b9b-aa8f-4460a3ac701f	3c1464f2-3d18-447d-981d-09835174ce0a
faa9593e-2d90-4255-8f48-884017cdf07b	c9ffb85f-ffca-4815-a7c1-eb23953d8ee2
c204f9da-6bb1-4b9b-aa8f-4460a3ac701f	016c1c33-dfbe-43c6-a4c5-0bccbb8c0cee
016c1c33-dfbe-43c6-a4c5-0bccbb8c0cee	03055be3-8d2a-4f41-bcc0-ffe70718346c
69dc6a0a-9802-4300-ac7e-fa1cf7774dbd	095da6b8-4679-43df-9924-cc510af6a520
1d572f60-f5b8-4335-8067-971c475d93d5	7af9707e-9211-47e6-8c98-e98d216d8a4d
c204f9da-6bb1-4b9b-aa8f-4460a3ac701f	8df41d99-d1b8-4148-a892-556ba268d0fb
c204f9da-6bb1-4b9b-aa8f-4460a3ac701f	1c3bb11f-16b0-4f39-b9f8-5633bfe5c1a7
1d572f60-f5b8-4335-8067-971c475d93d5	e4518591-f183-4be5-a398-98bb5825fc1e
1d572f60-f5b8-4335-8067-971c475d93d5	3cb506d8-7e3b-4e3c-8baa-bd1fc94dbc66
1d572f60-f5b8-4335-8067-971c475d93d5	d2c9a7c7-121a-4e33-a9e2-15c569a65168
1d572f60-f5b8-4335-8067-971c475d93d5	79fcfe2a-b5ae-4761-9514-989c565c07c5
1d572f60-f5b8-4335-8067-971c475d93d5	3e2608c5-407e-473a-9f9e-2ff09f8f86af
1d572f60-f5b8-4335-8067-971c475d93d5	780722bb-ba0a-4109-9f70-3a72d865f81a
1d572f60-f5b8-4335-8067-971c475d93d5	67d2513a-7005-4fff-9bec-b00d1e859249
1d572f60-f5b8-4335-8067-971c475d93d5	44462235-46aa-45d1-b6e7-5aa2a88c5097
1d572f60-f5b8-4335-8067-971c475d93d5	ad632e39-368e-4524-b9aa-3f017a77d641
1d572f60-f5b8-4335-8067-971c475d93d5	c920f101-ed3c-49a0-b1d0-8382b74a8d18
1d572f60-f5b8-4335-8067-971c475d93d5	4ffe19fc-5eb5-470c-beba-9cfc8f70e4cf
1d572f60-f5b8-4335-8067-971c475d93d5	47cc9b6b-0780-4a9c-84ec-fbf8034000cc
1d572f60-f5b8-4335-8067-971c475d93d5	28a15137-da57-4c20-94d4-16a604adb7da
1d572f60-f5b8-4335-8067-971c475d93d5	ea320088-9324-4000-9be7-33b4f25d8a36
1d572f60-f5b8-4335-8067-971c475d93d5	cc4f01c6-2f45-4c32-bc5e-296ce9633060
1d572f60-f5b8-4335-8067-971c475d93d5	5bdb8d51-1457-4846-88cb-f7007d8df3cc
1d572f60-f5b8-4335-8067-971c475d93d5	d8a29dd6-02bd-4e79-9bad-9209b9108ccf
79fcfe2a-b5ae-4761-9514-989c565c07c5	cc4f01c6-2f45-4c32-bc5e-296ce9633060
d2c9a7c7-121a-4e33-a9e2-15c569a65168	d8a29dd6-02bd-4e79-9bad-9209b9108ccf
d2c9a7c7-121a-4e33-a9e2-15c569a65168	ea320088-9324-4000-9be7-33b4f25d8a36
e9fa9980-32db-451d-8a6d-4e3b75842a1a	0da2709f-a0b7-488d-84b4-8b404da55049
e9fa9980-32db-451d-8a6d-4e3b75842a1a	6cea12f3-72b2-4068-beff-5a5730c8bb71
e9fa9980-32db-451d-8a6d-4e3b75842a1a	d5f6a469-96d1-447a-8414-52a8d4bbecae
e9fa9980-32db-451d-8a6d-4e3b75842a1a	a9437a80-ec92-44b6-b370-9e60f0146293
e9fa9980-32db-451d-8a6d-4e3b75842a1a	f8ff5799-8892-4dd8-b47c-ef64503ea65f
e9fa9980-32db-451d-8a6d-4e3b75842a1a	a5915248-941b-4582-9bd1-2cc75d9247c7
e9fa9980-32db-451d-8a6d-4e3b75842a1a	ab226d01-2182-4485-bb16-9a315ad73764
e9fa9980-32db-451d-8a6d-4e3b75842a1a	425b96a1-eb8a-4e88-b290-cca59628d5a3
e9fa9980-32db-451d-8a6d-4e3b75842a1a	bc6e3568-7869-4db2-a0fb-e2cae05e9905
e9fa9980-32db-451d-8a6d-4e3b75842a1a	e8575252-c396-4027-8da4-348e772f8eb6
e9fa9980-32db-451d-8a6d-4e3b75842a1a	0d740c34-f50d-48ef-a821-2f1bccb14e6d
e9fa9980-32db-451d-8a6d-4e3b75842a1a	b2ad0f81-cab4-4f5c-b031-9b3a1cabf038
e9fa9980-32db-451d-8a6d-4e3b75842a1a	89d16664-6760-40e7-aa1d-19e9a59ffdf4
e9fa9980-32db-451d-8a6d-4e3b75842a1a	616e40eb-c5f3-4de8-9398-007ddaf4232e
e9fa9980-32db-451d-8a6d-4e3b75842a1a	72f39e11-9bc0-4ca2-98e1-e284c0987a1f
e9fa9980-32db-451d-8a6d-4e3b75842a1a	f8fd5bb7-a40d-4da3-baae-3134fbef99ff
e9fa9980-32db-451d-8a6d-4e3b75842a1a	402ea37a-9556-43f1-b637-70848b6e78b5
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	c099f9ef-fdb6-41b8-bef8-1f42f92cb83e
a9437a80-ec92-44b6-b370-9e60f0146293	72f39e11-9bc0-4ca2-98e1-e284c0987a1f
d5f6a469-96d1-447a-8414-52a8d4bbecae	402ea37a-9556-43f1-b637-70848b6e78b5
d5f6a469-96d1-447a-8414-52a8d4bbecae	616e40eb-c5f3-4de8-9398-007ddaf4232e
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	e630d52e-827f-4ef0-a687-c91997c294c6
e630d52e-827f-4ef0-a687-c91997c294c6	6c261277-6018-43c0-b36e-2f7cf5b71a7d
2fb706f4-97e3-4387-8007-24d085c02086	4cd319bf-c84c-4ce7-8f71-55477564d986
1d572f60-f5b8-4335-8067-971c475d93d5	1ca33524-27f5-487f-ac91-01ff9e5294e7
e9fa9980-32db-451d-8a6d-4e3b75842a1a	a2a40099-624b-4157-ad2d-28f5ed7f7066
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	a567c65a-d764-4436-af73-e3722c5c496b
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	466a4096-6921-4d59-9eae-fff24c828237
\.


--
-- TOC entry 4147 (class 0 OID 16506)
-- Dependencies: 239
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
cec094b0-23a1-428a-a41f-4fc475b26b57	\N	password	a2bb7ed6-3c86-4ce7-b99c-da576722bacc	1706106535623	\N	{"value":"H64prYAngQgkpe+H7ICq7ZuBEg0cyiX1vray9pMB0lo=","salt":"NKIi/iXnRKnz698gaP5DFw==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
e88fdb71-ceb9-46c7-8d36-83304dd2824a	\N	password	b5a139fc-02ea-401a-95d9-38b512f8ecc5	1707829251821	\N	{"value":"C6o2bCtCIhb1yQfdRyrS9oXvm+IRLto734wwU9BvBbU=","salt":"JjX8R/Bg1cm3vjwn+EyeSA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- TOC entry 4148 (class 0 OID 16511)
-- Dependencies: 240
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2024-01-24 14:28:53.251107	1	EXECUTED	9:6f1016664e21e16d26517a4418f5e3df	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.23.2	\N	\N	6106532824
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2024-01-24 14:28:53.276718	2	MARK_RAN	9:828775b1596a07d1200ba1d49e5e3941	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	4.23.2	\N	\N	6106532824
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2024-01-24 14:28:53.305898	3	EXECUTED	9:5f090e44a7d595883c1fb61f4b41fd38	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	4.23.2	\N	\N	6106532824
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2024-01-24 14:28:53.309199	4	EXECUTED	9:c07e577387a3d2c04d1adc9aaad8730e	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	6106532824
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2024-01-24 14:28:53.39613	5	EXECUTED	9:b68ce996c655922dbcd2fe6b6ae72686	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.23.2	\N	\N	6106532824
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2024-01-24 14:28:53.407589	6	MARK_RAN	9:543b5c9989f024fe35c6f6c5a97de88e	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	4.23.2	\N	\N	6106532824
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2024-01-24 14:28:53.471811	7	EXECUTED	9:765afebbe21cf5bbca048e632df38336	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.23.2	\N	\N	6106532824
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2024-01-24 14:28:53.483223	8	MARK_RAN	9:db4a145ba11a6fdaefb397f6dbf829a1	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	4.23.2	\N	\N	6106532824
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2024-01-24 14:28:53.490353	9	EXECUTED	9:9d05c7be10cdb873f8bcb41bc3a8ab23	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	4.23.2	\N	\N	6106532824
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2024-01-24 14:28:53.555055	10	EXECUTED	9:18593702353128d53111f9b1ff0b82b8	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	4.23.2	\N	\N	6106532824
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2024-01-24 14:28:53.585259	11	EXECUTED	9:6122efe5f090e41a85c0f1c9e52cbb62	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	6106532824
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2024-01-24 14:28:53.590166	12	MARK_RAN	9:e1ff28bf7568451453f844c5d54bb0b5	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	6106532824
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2024-01-24 14:28:53.59996	13	EXECUTED	9:7af32cd8957fbc069f796b61217483fd	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	4.23.2	\N	\N	6106532824
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-01-24 14:28:53.611493	14	EXECUTED	9:6005e15e84714cd83226bf7879f54190	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	4.23.2	\N	\N	6106532824
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-01-24 14:28:53.612864	15	MARK_RAN	9:bf656f5a2b055d07f314431cae76f06c	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6106532824
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-01-24 14:28:53.615182	16	MARK_RAN	9:f8dadc9284440469dcf71e25ca6ab99b	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	4.23.2	\N	\N	6106532824
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2024-01-24 14:28:53.617447	17	EXECUTED	9:d41d8cd98f00b204e9800998ecf8427e	empty		\N	4.23.2	\N	\N	6106532824
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2024-01-24 14:28:53.644353	18	EXECUTED	9:3368ff0be4c2855ee2dd9ca813b38d8e	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	4.23.2	\N	\N	6106532824
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2024-01-24 14:28:53.675273	19	EXECUTED	9:8ac2fb5dd030b24c0570a763ed75ed20	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.23.2	\N	\N	6106532824
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2024-01-24 14:28:53.681014	20	EXECUTED	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.23.2	\N	\N	6106532824
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2024-01-24 14:28:53.686963	21	MARK_RAN	9:831e82914316dc8a57dc09d755f23c51	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	4.23.2	\N	\N	6106532824
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2024-01-24 14:28:53.689577	22	MARK_RAN	9:f91ddca9b19743db60e3057679810e6c	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	4.23.2	\N	\N	6106532824
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2024-01-24 14:28:53.701738	23	EXECUTED	9:bc3d0f9e823a69dc21e23e94c7a94bb1	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	4.23.2	\N	\N	6106532824
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2024-01-24 14:28:53.705121	24	EXECUTED	9:c9999da42f543575ab790e76439a2679	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.23.2	\N	\N	6106532824
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2024-01-24 14:28:53.706467	25	MARK_RAN	9:0d6c65c6f58732d81569e77b10ba301d	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	4.23.2	\N	\N	6106532824
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2024-01-24 14:28:53.726706	26	EXECUTED	9:fc576660fc016ae53d2d4778d84d86d0	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	4.23.2	\N	\N	6106532824
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2024-01-24 14:28:53.776313	27	EXECUTED	9:43ed6b0da89ff77206289e87eaa9c024	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	4.23.2	\N	\N	6106532824
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2024-01-24 14:28:53.778937	28	EXECUTED	9:44bae577f551b3738740281eceb4ea70	update tableName=RESOURCE_SERVER_POLICY		\N	4.23.2	\N	\N	6106532824
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2024-01-24 14:28:53.817845	29	EXECUTED	9:bd88e1f833df0420b01e114533aee5e8	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	4.23.2	\N	\N	6106532824
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2024-01-24 14:28:53.825913	30	EXECUTED	9:a7022af5267f019d020edfe316ef4371	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	4.23.2	\N	\N	6106532824
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2024-01-24 14:28:53.840603	31	EXECUTED	9:fc155c394040654d6a79227e56f5e25a	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	4.23.2	\N	\N	6106532824
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2024-01-24 14:28:53.844646	32	EXECUTED	9:eac4ffb2a14795e5dc7b426063e54d88	customChange		\N	4.23.2	\N	\N	6106532824
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-01-24 14:28:53.849379	33	EXECUTED	9:54937c05672568c4c64fc9524c1e9462	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6106532824
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-01-24 14:28:53.852063	34	MARK_RAN	9:3a32bace77c84d7678d035a7f5a8084e	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.23.2	\N	\N	6106532824
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-01-24 14:28:53.869856	35	EXECUTED	9:33d72168746f81f98ae3a1e8e0ca3554	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	4.23.2	\N	\N	6106532824
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2024-01-24 14:28:53.872807	36	EXECUTED	9:61b6d3d7a4c0e0024b0c839da283da0c	addColumn tableName=REALM		\N	4.23.2	\N	\N	6106532824
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2024-01-24 14:28:53.877648	37	EXECUTED	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6106532824
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2024-01-24 14:28:53.880051	38	EXECUTED	9:a2b870802540cb3faa72098db5388af3	addColumn tableName=FED_USER_CONSENT		\N	4.23.2	\N	\N	6106532824
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2024-01-24 14:28:53.88243	39	EXECUTED	9:132a67499ba24bcc54fb5cbdcfe7e4c0	addColumn tableName=IDENTITY_PROVIDER		\N	4.23.2	\N	\N	6106532824
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-01-24 14:28:53.883496	40	MARK_RAN	9:938f894c032f5430f2b0fafb1a243462	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	4.23.2	\N	\N	6106532824
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-01-24 14:28:53.885054	41	MARK_RAN	9:845c332ff1874dc5d35974b0babf3006	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	4.23.2	\N	\N	6106532824
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2024-01-24 14:28:53.887642	42	EXECUTED	9:fc86359c079781adc577c5a217e4d04c	customChange		\N	4.23.2	\N	\N	6106532824
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2024-01-24 14:28:53.978807	43	EXECUTED	9:59a64800e3c0d09b825f8a3b444fa8f4	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	4.23.2	\N	\N	6106532824
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2024-01-24 14:28:53.981996	44	EXECUTED	9:d48d6da5c6ccf667807f633fe489ce88	addColumn tableName=USER_ENTITY		\N	4.23.2	\N	\N	6106532824
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-01-24 14:28:53.984985	45	EXECUTED	9:dde36f7973e80d71fceee683bc5d2951	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	4.23.2	\N	\N	6106532824
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-01-24 14:28:53.987935	46	EXECUTED	9:b855e9b0a406b34fa323235a0cf4f640	customChange		\N	4.23.2	\N	\N	6106532824
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-01-24 14:28:53.98942	47	MARK_RAN	9:51abbacd7b416c50c4421a8cabf7927e	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	4.23.2	\N	\N	6106532824
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-01-24 14:28:54.023136	48	EXECUTED	9:bdc99e567b3398bac83263d375aad143	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	4.23.2	\N	\N	6106532824
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2024-01-24 14:28:54.026217	49	EXECUTED	9:d198654156881c46bfba39abd7769e69	addColumn tableName=REALM		\N	4.23.2	\N	\N	6106532824
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2024-01-24 14:28:54.051817	50	EXECUTED	9:cfdd8736332ccdd72c5256ccb42335db	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	4.23.2	\N	\N	6106532824
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2024-01-24 14:28:54.070623	51	EXECUTED	9:7c84de3d9bd84d7f077607c1a4dcb714	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	4.23.2	\N	\N	6106532824
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2024-01-24 14:28:54.07269	52	EXECUTED	9:5a6bb36cbefb6a9d6928452c0852af2d	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6106532824
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2024-01-24 14:28:54.074663	53	EXECUTED	9:8f23e334dbc59f82e0a328373ca6ced0	update tableName=REALM		\N	4.23.2	\N	\N	6106532824
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2024-01-24 14:28:54.076239	54	EXECUTED	9:9156214268f09d970cdf0e1564d866af	update tableName=CLIENT		\N	4.23.2	\N	\N	6106532824
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-01-24 14:28:54.080022	55	EXECUTED	9:db806613b1ed154826c02610b7dbdf74	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	4.23.2	\N	\N	6106532824
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-01-24 14:28:54.082669	56	EXECUTED	9:229a041fb72d5beac76bb94a5fa709de	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	4.23.2	\N	\N	6106532824
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-01-24 14:28:54.095738	57	EXECUTED	9:079899dade9c1e683f26b2aa9ca6ff04	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	4.23.2	\N	\N	6106532824
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2024-01-24 14:28:54.151775	58	EXECUTED	9:139b79bcbbfe903bb1c2d2a4dbf001d9	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	4.23.2	\N	\N	6106532824
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2024-01-24 14:28:54.168024	59	EXECUTED	9:b55738ad889860c625ba2bf483495a04	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	4.23.2	\N	\N	6106532824
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2024-01-24 14:28:54.171563	60	EXECUTED	9:e0057eac39aa8fc8e09ac6cfa4ae15fe	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	4.23.2	\N	\N	6106532824
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-01-24 14:28:54.176658	61	EXECUTED	9:42a33806f3a0443fe0e7feeec821326c	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	4.23.2	\N	\N	6106532824
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2024-01-24 14:28:54.180696	62	EXECUTED	9:9968206fca46eecc1f51db9c024bfe56	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	4.23.2	\N	\N	6106532824
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2024-01-24 14:28:54.182568	63	EXECUTED	9:92143a6daea0a3f3b8f598c97ce55c3d	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	4.23.2	\N	\N	6106532824
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2024-01-24 14:28:54.184355	64	EXECUTED	9:82bab26a27195d889fb0429003b18f40	update tableName=REQUIRED_ACTION_PROVIDER		\N	4.23.2	\N	\N	6106532824
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2024-01-24 14:28:54.186307	65	EXECUTED	9:e590c88ddc0b38b0ae4249bbfcb5abc3	update tableName=RESOURCE_SERVER_RESOURCE		\N	4.23.2	\N	\N	6106532824
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2024-01-24 14:28:54.194034	66	EXECUTED	9:5c1f475536118dbdc38d5d7977950cc0	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	4.23.2	\N	\N	6106532824
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2024-01-24 14:28:54.197577	67	EXECUTED	9:e7c9f5f9c4d67ccbbcc215440c718a17	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	4.23.2	\N	\N	6106532824
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2024-01-24 14:28:54.199929	68	EXECUTED	9:88e0bfdda924690d6f4e430c53447dd5	addColumn tableName=REALM		\N	4.23.2	\N	\N	6106532824
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2024-01-24 14:28:54.205434	69	EXECUTED	9:f53177f137e1c46b6a88c59ec1cb5218	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	4.23.2	\N	\N	6106532824
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2024-01-24 14:28:54.208696	70	EXECUTED	9:a74d33da4dc42a37ec27121580d1459f	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	4.23.2	\N	\N	6106532824
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2024-01-24 14:28:54.211582	71	EXECUTED	9:fd4ade7b90c3b67fae0bfcfcb42dfb5f	addColumn tableName=RESOURCE_SERVER		\N	4.23.2	\N	\N	6106532824
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-01-24 14:28:54.215461	72	EXECUTED	9:aa072ad090bbba210d8f18781b8cebf4	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	6106532824
8.0.0-updating-credential-data-not-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-01-24 14:28:54.219508	73	EXECUTED	9:1ae6be29bab7c2aa376f6983b932be37	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	6106532824
8.0.0-updating-credential-data-oracle-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-01-24 14:28:54.220977	74	MARK_RAN	9:14706f286953fc9a25286dbd8fb30d97	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	4.23.2	\N	\N	6106532824
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-01-24 14:28:54.231261	75	EXECUTED	9:2b9cc12779be32c5b40e2e67711a218b	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	4.23.2	\N	\N	6106532824
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2024-01-24 14:28:54.238447	76	EXECUTED	9:91fa186ce7a5af127a2d7a91ee083cc5	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	4.23.2	\N	\N	6106532824
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-01-24 14:28:54.242948	77	EXECUTED	9:6335e5c94e83a2639ccd68dd24e2e5ad	addColumn tableName=CLIENT		\N	4.23.2	\N	\N	6106532824
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-01-24 14:28:54.244716	78	MARK_RAN	9:6bdb5658951e028bfe16fa0a8228b530	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	4.23.2	\N	\N	6106532824
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-01-24 14:28:54.256749	79	EXECUTED	9:d5bc15a64117ccad481ce8792d4c608f	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	4.23.2	\N	\N	6106532824
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2024-01-24 14:28:54.258952	80	MARK_RAN	9:077cba51999515f4d3e7ad5619ab592c	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	4.23.2	\N	\N	6106532824
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-01-24 14:28:54.263268	81	EXECUTED	9:be969f08a163bf47c6b9e9ead8ac2afb	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	4.23.2	\N	\N	6106532824
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-01-24 14:28:54.264579	82	MARK_RAN	9:6d3bb4408ba5a72f39bd8a0b301ec6e3	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6106532824
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-01-24 14:28:54.26808	83	EXECUTED	9:966bda61e46bebf3cc39518fbed52fa7	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6106532824
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-01-24 14:28:54.269418	84	MARK_RAN	9:8dcac7bdf7378e7d823cdfddebf72fda	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	4.23.2	\N	\N	6106532824
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2024-01-24 14:28:54.27291	85	EXECUTED	9:7d93d602352a30c0c317e6a609b56599	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	6106532824
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2024-01-24 14:28:54.276105	86	EXECUTED	9:71c5969e6cdd8d7b6f47cebc86d37627	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	4.23.2	\N	\N	6106532824
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-01-24 14:28:54.279457	87	EXECUTED	9:a9ba7d47f065f041b7da856a81762021	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	4.23.2	\N	\N	6106532824
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2024-01-24 14:28:54.285191	88	EXECUTED	9:fffabce2bc01e1a8f5110d5278500065	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	4.23.2	\N	\N	6106532824
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.288657	89	EXECUTED	9:fa8a5b5445e3857f4b010bafb5009957	addColumn tableName=REALM; customChange		\N	4.23.2	\N	\N	6106532824
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.291509	90	EXECUTED	9:67ac3241df9a8582d591c5ed87125f39	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	4.23.2	\N	\N	6106532824
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.295576	91	EXECUTED	9:ad1194d66c937e3ffc82386c050ba089	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6106532824
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.299029	92	EXECUTED	9:d9be619d94af5a2f5d07b9f003543b91	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	4.23.2	\N	\N	6106532824
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.300141	93	MARK_RAN	9:544d201116a0fcc5a5da0925fbbc3bde	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	4.23.2	\N	\N	6106532824
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.304359	94	EXECUTED	9:43c0c1055b6761b4b3e89de76d612ccf	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	4.23.2	\N	\N	6106532824
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.305932	95	MARK_RAN	9:8bd711fd0330f4fe980494ca43ab1139	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	4.23.2	\N	\N	6106532824
json-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-13.0.0.xml	2024-01-24 14:28:54.309341	96	EXECUTED	9:e07d2bc0970c348bb06fb63b1f82ddbf	addColumn tableName=REALM_ATTRIBUTE; update tableName=REALM_ATTRIBUTE; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	4.23.2	\N	\N	6106532824
14.0.0-KEYCLOAK-11019	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.317026	97	EXECUTED	9:24fb8611e97f29989bea412aa38d12b7	createIndex indexName=IDX_OFFLINE_CSS_PRELOAD, tableName=OFFLINE_CLIENT_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USER, tableName=OFFLINE_USER_SESSION; createIndex indexName=IDX_OFFLINE_USS_BY_USERSESS, tableName=OFFLINE_USER_SESSION		\N	4.23.2	\N	\N	6106532824
14.0.0-KEYCLOAK-18286	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.318271	98	MARK_RAN	9:259f89014ce2506ee84740cbf7163aa7	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6106532824
14.0.0-KEYCLOAK-18286-revert	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.324112	99	MARK_RAN	9:04baaf56c116ed19951cbc2cca584022	dropIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6106532824
14.0.0-KEYCLOAK-18286-supported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.328157	100	EXECUTED	9:60ca84a0f8c94ec8c3504a5a3bc88ee8	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6106532824
14.0.0-KEYCLOAK-18286-unsupported-dbs	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.329316	101	MARK_RAN	9:d3d977031d431db16e2c181ce49d73e9	createIndex indexName=IDX_CLIENT_ATT_BY_NAME_VALUE, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6106532824
KEYCLOAK-17267-add-index-to-user-attributes	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.333067	102	EXECUTED	9:0b305d8d1277f3a89a0a53a659ad274c	createIndex indexName=IDX_USER_ATTRIBUTE_NAME, tableName=USER_ATTRIBUTE		\N	4.23.2	\N	\N	6106532824
KEYCLOAK-18146-add-saml-art-binding-identifier	keycloak	META-INF/jpa-changelog-14.0.0.xml	2024-01-24 14:28:54.335482	103	EXECUTED	9:2c374ad2cdfe20e2905a84c8fac48460	customChange		\N	4.23.2	\N	\N	6106532824
15.0.0-KEYCLOAK-18467	keycloak	META-INF/jpa-changelog-15.0.0.xml	2024-01-24 14:28:54.344002	104	EXECUTED	9:47a760639ac597360a8219f5b768b4de	addColumn tableName=REALM_LOCALIZATIONS; update tableName=REALM_LOCALIZATIONS; dropColumn columnName=TEXTS, tableName=REALM_LOCALIZATIONS; renameColumn newColumnName=TEXTS, oldColumnName=TEXTS_NEW, tableName=REALM_LOCALIZATIONS; addNotNullConstrai...		\N	4.23.2	\N	\N	6106532824
17.0.0-9562	keycloak	META-INF/jpa-changelog-17.0.0.xml	2024-01-24 14:28:54.349379	105	EXECUTED	9:a6272f0576727dd8cad2522335f5d99e	createIndex indexName=IDX_USER_SERVICE_ACCOUNT, tableName=USER_ENTITY		\N	4.23.2	\N	\N	6106532824
18.0.0-10625-IDX_ADMIN_EVENT_TIME	keycloak	META-INF/jpa-changelog-18.0.0.xml	2024-01-24 14:28:54.353191	106	EXECUTED	9:015479dbd691d9cc8669282f4828c41d	createIndex indexName=IDX_ADMIN_EVENT_TIME, tableName=ADMIN_EVENT_ENTITY		\N	4.23.2	\N	\N	6106532824
19.0.0-10135	keycloak	META-INF/jpa-changelog-19.0.0.xml	2024-01-24 14:28:54.355856	107	EXECUTED	9:9518e495fdd22f78ad6425cc30630221	customChange		\N	4.23.2	\N	\N	6106532824
20.0.0-12964-supported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-01-24 14:28:54.35928	108	EXECUTED	9:e5f243877199fd96bcc842f27a1656ac	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.23.2	\N	\N	6106532824
20.0.0-12964-unsupported-dbs	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-01-24 14:28:54.360287	109	MARK_RAN	9:1a6fcaa85e20bdeae0a9ce49b41946a5	createIndex indexName=IDX_GROUP_ATT_BY_NAME_VALUE, tableName=GROUP_ATTRIBUTE		\N	4.23.2	\N	\N	6106532824
client-attributes-string-accomodation-fixed	keycloak	META-INF/jpa-changelog-20.0.0.xml	2024-01-24 14:28:54.363969	110	EXECUTED	9:3f332e13e90739ed0c35b0b25b7822ca	addColumn tableName=CLIENT_ATTRIBUTES; update tableName=CLIENT_ATTRIBUTES; dropColumn columnName=VALUE, tableName=CLIENT_ATTRIBUTES; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=CLIENT_ATTRIBUTES		\N	4.23.2	\N	\N	6106532824
21.0.2-17277	keycloak	META-INF/jpa-changelog-21.0.2.xml	2024-01-24 14:28:54.366478	111	EXECUTED	9:7ee1f7a3fb8f5588f171fb9a6ab623c0	customChange		\N	4.23.2	\N	\N	6106532824
21.1.0-19404	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-01-24 14:28:54.382536	112	EXECUTED	9:3d7e830b52f33676b9d64f7f2b2ea634	modifyDataType columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=LOGIC, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=POLICY_ENFORCE_MODE, tableName=RESOURCE_SERVER		\N	4.23.2	\N	\N	6106532824
21.1.0-19404-2	keycloak	META-INF/jpa-changelog-21.1.0.xml	2024-01-24 14:28:54.384789	113	MARK_RAN	9:627d032e3ef2c06c0e1f73d2ae25c26c	addColumn tableName=RESOURCE_SERVER_POLICY; update tableName=RESOURCE_SERVER_POLICY; dropColumn columnName=DECISION_STRATEGY, tableName=RESOURCE_SERVER_POLICY; renameColumn newColumnName=DECISION_STRATEGY, oldColumnName=DECISION_STRATEGY_NEW, tabl...		\N	4.23.2	\N	\N	6106532824
22.0.0-17484-updated	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-01-24 14:28:54.389538	114	EXECUTED	9:90af0bfd30cafc17b9f4d6eccd92b8b3	customChange		\N	4.23.2	\N	\N	6106532824
22.0.5-24031	keycloak	META-INF/jpa-changelog-22.0.0.xml	2024-01-24 14:28:54.391096	115	MARK_RAN	9:a60d2d7b315ec2d3eba9e2f145f9df28	customChange		\N	4.23.2	\N	\N	6106532824
23.0.0-12062	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-01-24 14:28:54.396611	116	EXECUTED	9:2168fbe728fec46ae9baf15bf80927b8	addColumn tableName=COMPONENT_CONFIG; update tableName=COMPONENT_CONFIG; dropColumn columnName=VALUE, tableName=COMPONENT_CONFIG; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=COMPONENT_CONFIG		\N	4.23.2	\N	\N	6106532824
23.0.0-17258	keycloak	META-INF/jpa-changelog-23.0.0.xml	2024-01-24 14:28:54.398852	117	EXECUTED	9:36506d679a83bbfda85a27ea1864dca8	addColumn tableName=EVENT_ENTITY		\N	4.23.2	\N	\N	6106532824
\.


--
-- TOC entry 4149 (class 0 OID 16516)
-- Dependencies: 241
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- TOC entry 4150 (class 0 OID 16519)
-- Dependencies: 242
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	9643d6d2-b29f-43c7-8c1e-9f78bc0f62f6	f
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	9cb2d3f5-61cc-4d9a-85b1-f28c911bbe90	t
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	b73496be-314e-48cb-926a-d11e6dd88cd2	t
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	52e10ef0-5620-47d7-a89a-c800b7d6998b	t
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	b32a7337-695a-4b60-be9d-a538ad72abfc	f
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7d3b937d-0d48-42d9-8db9-1451b154ff2e	f
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	a3c2889f-b8aa-4ff2-b992-604934f57dda	t
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	29b11608-7d74-49c4-9155-788f107f5a12	t
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	aa5ec348-d155-4909-9a13-4ad95bedee23	f
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	37acc24e-f3a1-430c-8624-bd74e2f7f5d4	t
e79a028c-615a-4cf7-8850-e49274b70888	e590b491-6ada-495b-a830-ff28429cb619	f
e79a028c-615a-4cf7-8850-e49274b70888	6ba6afd0-d8e5-4d12-a4bb-a1ca869540c4	t
e79a028c-615a-4cf7-8850-e49274b70888	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557	t
e79a028c-615a-4cf7-8850-e49274b70888	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb	t
e79a028c-615a-4cf7-8850-e49274b70888	0083ae97-ba80-4c79-9baa-9addd3c4c688	f
e79a028c-615a-4cf7-8850-e49274b70888	ce4f907c-b147-413f-bc74-2ad284138816	f
e79a028c-615a-4cf7-8850-e49274b70888	1d9b3046-a8f8-4524-8675-6d12e6cbab04	t
e79a028c-615a-4cf7-8850-e49274b70888	380abffc-0088-40ed-a1a6-5b70e8b081fc	t
e79a028c-615a-4cf7-8850-e49274b70888	7c0d75e2-4146-43a6-a782-b21b4409f4b3	f
e79a028c-615a-4cf7-8850-e49274b70888	16998a60-6487-4163-b2b3-4823acba5115	t
\.


--
-- TOC entry 4151 (class 0 OID 16523)
-- Dependencies: 243
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id, details_json_long_value) FROM stdin;
\.


--
-- TOC entry 4152 (class 0 OID 16528)
-- Dependencies: 244
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- TOC entry 4153 (class 0 OID 16533)
-- Dependencies: 245
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- TOC entry 4154 (class 0 OID 16538)
-- Dependencies: 246
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- TOC entry 4155 (class 0 OID 16541)
-- Dependencies: 247
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- TOC entry 4156 (class 0 OID 16546)
-- Dependencies: 248
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- TOC entry 4157 (class 0 OID 16549)
-- Dependencies: 249
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- TOC entry 4158 (class 0 OID 16555)
-- Dependencies: 250
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- TOC entry 4159 (class 0 OID 16558)
-- Dependencies: 251
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- TOC entry 4160 (class 0 OID 16563)
-- Dependencies: 252
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- TOC entry 4161 (class 0 OID 16568)
-- Dependencies: 253
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- TOC entry 4162 (class 0 OID 16574)
-- Dependencies: 254
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- TOC entry 4163 (class 0 OID 16577)
-- Dependencies: 255
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- TOC entry 4164 (class 0 OID 16588)
-- Dependencies: 256
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- TOC entry 4165 (class 0 OID 16593)
-- Dependencies: 257
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- TOC entry 4166 (class 0 OID 16598)
-- Dependencies: 258
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- TOC entry 4167 (class 0 OID 16603)
-- Dependencies: 259
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- TOC entry 4168 (class 0 OID 16606)
-- Dependencies: 260
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
c204f9da-6bb1-4b9b-aa8f-4460a3ac701f	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	${role_default-roles}	default-roles-master	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	\N
1d572f60-f5b8-4335-8067-971c475d93d5	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	${role_admin}	admin	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	\N
45ba2dd0-d10c-426c-bdbd-ea6ddc700fb7	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	${role_create-realm}	create-realm	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	\N
6c687ea4-9d22-463c-ad32-4f1b9b3d9b58	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_create-client}	create-client	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
a977f6a4-4076-4f34-bd4b-ed3f94c58578	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_view-realm}	view-realm	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
bd03bb4a-12d8-4aaa-b3bc-3307c38d0f00	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_view-users}	view-users	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
faa9593e-2d90-4255-8f48-884017cdf07b	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_view-clients}	view-clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
753b9b46-9e41-45ad-aa1f-7478f92f1530	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_view-events}	view-events	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
b89f3b44-9370-4759-9b57-37ce08e055d8	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_view-identity-providers}	view-identity-providers	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
b5145426-c3b3-4b5a-a127-c71d73e11789	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_view-authorization}	view-authorization	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
0cb93156-3aa2-4c5e-82e8-1190f2e10772	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_manage-realm}	manage-realm	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
61cb2a12-036a-4d5c-9a0b-ce5fa1d94b7c	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_manage-users}	manage-users	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
61b7fdf1-b29e-45ad-af9e-6ce51afef300	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_manage-clients}	manage-clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
f1d2e69a-60fe-4342-a881-a3876d3707cc	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_manage-events}	manage-events	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
3945ffc6-bf52-4b28-841d-a4bdc8bd085b	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_manage-identity-providers}	manage-identity-providers	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
631ea094-1b77-4bdd-8dc6-e3594f2b8519	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_manage-authorization}	manage-authorization	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
98174597-ff5e-406c-919b-3a7b5ac1ecd2	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_query-users}	query-users	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
c9ffb85f-ffca-4815-a7c1-eb23953d8ee2	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_query-clients}	query-clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
29c53ae4-41c9-4f3d-aa87-bdb1736c5bc0	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_query-realms}	query-realms	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
b54889eb-e76b-4638-b16a-543c27c4b7d1	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_query-groups}	query-groups	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
3c1464f2-3d18-447d-981d-09835174ce0a	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_view-profile}	view-profile	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
016c1c33-dfbe-43c6-a4c5-0bccbb8c0cee	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_manage-account}	manage-account	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
03055be3-8d2a-4f41-bcc0-ffe70718346c	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_manage-account-links}	manage-account-links	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
394291ab-5d5e-4a46-962c-f330cc094c05	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_view-applications}	view-applications	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
095da6b8-4679-43df-9924-cc510af6a520	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_view-consent}	view-consent	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
69dc6a0a-9802-4300-ac7e-fa1cf7774dbd	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_manage-consent}	manage-consent	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
8c510253-f45c-48d2-8a51-3426c93528ad	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_view-groups}	view-groups	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
5dd8902b-42cc-4593-9bd9-e3d755ba2677	352ffebc-61f6-4559-8273-dc37678f202c	t	${role_delete-account}	delete-account	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	352ffebc-61f6-4559-8273-dc37678f202c	\N
8a96265c-dbff-4423-b878-78df04d3f608	2ada4a55-53f6-4d89-bc00-01b458bcc3d0	t	${role_read-token}	read-token	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	2ada4a55-53f6-4d89-bc00-01b458bcc3d0	\N
7af9707e-9211-47e6-8c98-e98d216d8a4d	7c9f997b-7e37-4849-8110-6b2374f15399	t	${role_impersonation}	impersonation	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	7c9f997b-7e37-4849-8110-6b2374f15399	\N
8df41d99-d1b8-4148-a892-556ba268d0fb	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	${role_offline-access}	offline_access	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	\N
1c3bb11f-16b0-4f39-b9f8-5633bfe5c1a7	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	${role_uma_authorization}	uma_authorization	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	\N	\N
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	e79a028c-615a-4cf7-8850-e49274b70888	f	${role_default-roles}	default-roles-doc-analysis	e79a028c-615a-4cf7-8850-e49274b70888	\N	\N
e4518591-f183-4be5-a398-98bb5825fc1e	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_create-client}	create-client	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
3cb506d8-7e3b-4e3c-8baa-bd1fc94dbc66	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_view-realm}	view-realm	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
d2c9a7c7-121a-4e33-a9e2-15c569a65168	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_view-users}	view-users	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
79fcfe2a-b5ae-4761-9514-989c565c07c5	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_view-clients}	view-clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
3e2608c5-407e-473a-9f9e-2ff09f8f86af	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_view-events}	view-events	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
780722bb-ba0a-4109-9f70-3a72d865f81a	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_view-identity-providers}	view-identity-providers	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
67d2513a-7005-4fff-9bec-b00d1e859249	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_view-authorization}	view-authorization	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
44462235-46aa-45d1-b6e7-5aa2a88c5097	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_manage-realm}	manage-realm	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
ad632e39-368e-4524-b9aa-3f017a77d641	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_manage-users}	manage-users	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
c920f101-ed3c-49a0-b1d0-8382b74a8d18	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_manage-clients}	manage-clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
4ffe19fc-5eb5-470c-beba-9cfc8f70e4cf	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_manage-events}	manage-events	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
47cc9b6b-0780-4a9c-84ec-fbf8034000cc	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_manage-identity-providers}	manage-identity-providers	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
28a15137-da57-4c20-94d4-16a604adb7da	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_manage-authorization}	manage-authorization	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
ea320088-9324-4000-9be7-33b4f25d8a36	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_query-users}	query-users	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
cc4f01c6-2f45-4c32-bc5e-296ce9633060	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_query-clients}	query-clients	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
5bdb8d51-1457-4846-88cb-f7007d8df3cc	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_query-realms}	query-realms	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
d8a29dd6-02bd-4e79-9bad-9209b9108ccf	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_query-groups}	query-groups	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
e9fa9980-32db-451d-8a6d-4e3b75842a1a	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_realm-admin}	realm-admin	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
0da2709f-a0b7-488d-84b4-8b404da55049	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_create-client}	create-client	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
6cea12f3-72b2-4068-beff-5a5730c8bb71	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_view-realm}	view-realm	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
d5f6a469-96d1-447a-8414-52a8d4bbecae	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_view-users}	view-users	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
a9437a80-ec92-44b6-b370-9e60f0146293	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_view-clients}	view-clients	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
f8ff5799-8892-4dd8-b47c-ef64503ea65f	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_view-events}	view-events	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
a5915248-941b-4582-9bd1-2cc75d9247c7	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_view-identity-providers}	view-identity-providers	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
ab226d01-2182-4485-bb16-9a315ad73764	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_view-authorization}	view-authorization	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
425b96a1-eb8a-4e88-b290-cca59628d5a3	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_manage-realm}	manage-realm	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
bc6e3568-7869-4db2-a0fb-e2cae05e9905	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_manage-users}	manage-users	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
e8575252-c396-4027-8da4-348e772f8eb6	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_manage-clients}	manage-clients	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
0d740c34-f50d-48ef-a821-2f1bccb14e6d	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_manage-events}	manage-events	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
b2ad0f81-cab4-4f5c-b031-9b3a1cabf038	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_manage-identity-providers}	manage-identity-providers	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
89d16664-6760-40e7-aa1d-19e9a59ffdf4	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_manage-authorization}	manage-authorization	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
616e40eb-c5f3-4de8-9398-007ddaf4232e	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_query-users}	query-users	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
72f39e11-9bc0-4ca2-98e1-e284c0987a1f	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_query-clients}	query-clients	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
f8fd5bb7-a40d-4da3-baae-3134fbef99ff	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_query-realms}	query-realms	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
402ea37a-9556-43f1-b637-70848b6e78b5	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_query-groups}	query-groups	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
c099f9ef-fdb6-41b8-bef8-1f42f92cb83e	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_view-profile}	view-profile	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
e630d52e-827f-4ef0-a687-c91997c294c6	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_manage-account}	manage-account	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
6c261277-6018-43c0-b36e-2f7cf5b71a7d	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_manage-account-links}	manage-account-links	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
2adcc04e-50e6-4910-9588-1a6e4755cd2e	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_view-applications}	view-applications	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
4cd319bf-c84c-4ce7-8f71-55477564d986	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_view-consent}	view-consent	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
2fb706f4-97e3-4387-8007-24d085c02086	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_manage-consent}	manage-consent	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
87629e29-6b31-4cd2-8720-7b2f302de0ed	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_view-groups}	view-groups	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
ad21efb5-27cb-4aeb-8d50-eff36c51f7f8	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	t	${role_delete-account}	delete-account	e79a028c-615a-4cf7-8850-e49274b70888	3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	\N
1ca33524-27f5-487f-ac91-01ff9e5294e7	5470c48e-e772-4bfb-ad48-aa4772deeeb3	t	${role_impersonation}	impersonation	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5470c48e-e772-4bfb-ad48-aa4772deeeb3	\N
a2a40099-624b-4157-ad2d-28f5ed7f7066	c0a3244c-5e71-420c-a23a-0116a1db716f	t	${role_impersonation}	impersonation	e79a028c-615a-4cf7-8850-e49274b70888	c0a3244c-5e71-420c-a23a-0116a1db716f	\N
608a6836-4510-4aee-b907-0cfa046d81c3	ce54bcea-da57-477e-a372-b6798b722c44	t	${role_read-token}	read-token	e79a028c-615a-4cf7-8850-e49274b70888	ce54bcea-da57-477e-a372-b6798b722c44	\N
a567c65a-d764-4436-af73-e3722c5c496b	e79a028c-615a-4cf7-8850-e49274b70888	f	${role_offline-access}	offline_access	e79a028c-615a-4cf7-8850-e49274b70888	\N	\N
466a4096-6921-4d59-9eae-fff24c828237	e79a028c-615a-4cf7-8850-e49274b70888	f	${role_uma_authorization}	uma_authorization	e79a028c-615a-4cf7-8850-e49274b70888	\N	\N
\.


--
-- TOC entry 4169 (class 0 OID 16612)
-- Dependencies: 261
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.migration_model (id, version, update_time) FROM stdin;
jn836	23.0.4	1706106534
\.


--
-- TOC entry 4170 (class 0 OID 16616)
-- Dependencies: 262
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- TOC entry 4171 (class 0 OID 16623)
-- Dependencies: 263
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- TOC entry 4172 (class 0 OID 16629)
-- Dependencies: 264
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- TOC entry 4173 (class 0 OID 16634)
-- Dependencies: 265
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
df94aab1-6bcb-4d97-ad2f-5a2167975e59	audience resolve	openid-connect	oidc-audience-resolve-mapper	e4cb5111-b259-47d0-8a21-d01b0232264b	\N
f5670557-07c0-4ff1-8f85-61054f83076f	locale	openid-connect	oidc-usermodel-attribute-mapper	8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	\N
47e72ab0-6161-45de-ba8f-84ad25dbcd64	role list	saml	saml-role-list-mapper	\N	9cb2d3f5-61cc-4d9a-85b1-f28c911bbe90
60aa8a5d-3e4b-4da1-9740-48d1a4d2819d	full name	openid-connect	oidc-full-name-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
2eef405d-27e9-42ab-a93d-a83d18738085	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
60f59f7a-5409-427d-a24c-b06008727a93	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
3b1b4c49-2327-411d-9f9e-ba6f78c50268	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
7d4f1a7a-2329-44dd-b84d-154d89106bd4	username	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
c15eada7-1174-488a-be41-7bad8e1ed2bc	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
80d55f94-60b7-42aa-bc24-738a3bc83521	website	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
9088fbb3-710b-48cd-88fa-0d296c117af4	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	b73496be-314e-48cb-926a-d11e6dd88cd2
ce6c40e2-5c00-467a-b053-78b87e9ef07b	email	openid-connect	oidc-usermodel-attribute-mapper	\N	52e10ef0-5620-47d7-a89a-c800b7d6998b
6957c70c-1d10-45d9-8d28-3b5db4087098	email verified	openid-connect	oidc-usermodel-property-mapper	\N	52e10ef0-5620-47d7-a89a-c800b7d6998b
5d8b044e-567f-4748-9909-4b95abb73785	address	openid-connect	oidc-address-mapper	\N	b32a7337-695a-4b60-be9d-a538ad72abfc
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	7d3b937d-0d48-42d9-8db9-1451b154ff2e
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	7d3b937d-0d48-42d9-8db9-1451b154ff2e
0f223d92-35a4-4c66-8189-636a34d27b5d	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	a3c2889f-b8aa-4ff2-b992-604934f57dda
19d136c7-7071-401e-8bc1-fc28312b501f	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	a3c2889f-b8aa-4ff2-b992-604934f57dda
b335dd68-6b9f-4c65-bba0-fa291b098788	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	a3c2889f-b8aa-4ff2-b992-604934f57dda
5b492b3a-685f-4c14-9541-1e7b17bf6c11	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	29b11608-7d74-49c4-9155-788f107f5a12
ee9f93fe-a900-4bf9-a015-047d314010ef	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	aa5ec348-d155-4909-9a13-4ad95bedee23
8ce44369-351f-4c92-81a6-0acf43ead354	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	aa5ec348-d155-4909-9a13-4ad95bedee23
442c538f-8f6d-4aa0-8270-7d0aaca52358	acr loa level	openid-connect	oidc-acr-mapper	\N	37acc24e-f3a1-430c-8624-bd74e2f7f5d4
6693688c-851c-4ba6-8166-9207027a71dd	audience resolve	openid-connect	oidc-audience-resolve-mapper	cd13309d-ade7-4da3-9e23-4578525d91dd	\N
ea819545-87e8-492d-a199-c8c90e489ef3	role list	saml	saml-role-list-mapper	\N	6ba6afd0-d8e5-4d12-a4bb-a1ca869540c4
49d476cc-fb4a-4fb0-b212-221ac5b29c21	full name	openid-connect	oidc-full-name-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	family name	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
30562d28-3c48-4d05-986e-2c6d3ed51ba7	given name	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
95248e55-6f0f-4510-8a81-6b5043643860	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
71d026e8-5a9c-4319-b831-e4cb2e59afc7	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
0ec6c016-d053-4abd-a607-6c3d427a154d	username	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
955090a8-ee19-4634-8fdb-9aee2687e086	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
65c620bf-7d82-4b68-82b2-4847d65237b3	website	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
0e451bf0-d25b-4889-85e0-e13e159ec016	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
47d33c75-046f-4df4-84bc-124a4018a1c2	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
c201ae94-f942-4fb8-be8f-2163fbf4ec65	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
ea7b3b26-4829-474a-b03c-ef163670b990	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	f9e8b6a8-195f-47ad-9cf2-7a288c1dd557
db039e16-d6e8-492b-921d-5702ba2d4f46	email	openid-connect	oidc-usermodel-attribute-mapper	\N	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb
74be4107-36ad-402c-9b3a-f3a3caeeebfc	email verified	openid-connect	oidc-usermodel-property-mapper	\N	0bf33c29-e7a4-4fba-83b3-3ef648afcdbb
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	address	openid-connect	oidc-address-mapper	\N	0083ae97-ba80-4c79-9baa-9addd3c4c688
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	ce4f907c-b147-413f-bc74-2ad284138816
621db25c-54ba-4a40-8dc0-024de7f0343f	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	ce4f907c-b147-413f-bc74-2ad284138816
aa1ff9e5-679f-4611-837c-8e03786feba7	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	1d9b3046-a8f8-4524-8675-6d12e6cbab04
9b4e9fb0-cc18-443a-99f3-3265aecf6859	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	1d9b3046-a8f8-4524-8675-6d12e6cbab04
90b61d3e-343c-4c34-9508-acca94d7017f	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	1d9b3046-a8f8-4524-8675-6d12e6cbab04
a9425bbc-29fb-4805-b424-12bef3238afa	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	380abffc-0088-40ed-a1a6-5b70e8b081fc
76cee4ec-1086-4b17-b786-63d5fd7113fd	upn	openid-connect	oidc-usermodel-attribute-mapper	\N	7c0d75e2-4146-43a6-a782-b21b4409f4b3
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	7c0d75e2-4146-43a6-a782-b21b4409f4b3
a8bb4aa4-9980-4c5d-a433-6215fea69fb8	acr loa level	openid-connect	oidc-acr-mapper	\N	16998a60-6487-4163-b2b3-4823acba5115
d7aae392-1079-48c6-b6bd-4d719a075da5	locale	openid-connect	oidc-usermodel-attribute-mapper	046748c7-389d-4b7f-8c0d-858f48da46f8	\N
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	Client ID	openid-connect	oidc-usersessionmodel-note-mapper	d3610fe9-5387-4fb2-b30c-ee6309fe5742	\N
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	Client Host	openid-connect	oidc-usersessionmodel-note-mapper	d3610fe9-5387-4fb2-b30c-ee6309fe5742	\N
5cb5148d-e877-48a5-ba43-66a9b4e7e061	Client IP Address	openid-connect	oidc-usersessionmodel-note-mapper	d3610fe9-5387-4fb2-b30c-ee6309fe5742	\N
\.


--
-- TOC entry 4174 (class 0 OID 16639)
-- Dependencies: 266
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
f5670557-07c0-4ff1-8f85-61054f83076f	true	introspection.token.claim
f5670557-07c0-4ff1-8f85-61054f83076f	true	userinfo.token.claim
f5670557-07c0-4ff1-8f85-61054f83076f	locale	user.attribute
f5670557-07c0-4ff1-8f85-61054f83076f	true	id.token.claim
f5670557-07c0-4ff1-8f85-61054f83076f	true	access.token.claim
f5670557-07c0-4ff1-8f85-61054f83076f	locale	claim.name
f5670557-07c0-4ff1-8f85-61054f83076f	String	jsonType.label
47e72ab0-6161-45de-ba8f-84ad25dbcd64	false	single
47e72ab0-6161-45de-ba8f-84ad25dbcd64	Basic	attribute.nameformat
47e72ab0-6161-45de-ba8f-84ad25dbcd64	Role	attribute.name
2eef405d-27e9-42ab-a93d-a83d18738085	true	introspection.token.claim
2eef405d-27e9-42ab-a93d-a83d18738085	true	userinfo.token.claim
2eef405d-27e9-42ab-a93d-a83d18738085	lastName	user.attribute
2eef405d-27e9-42ab-a93d-a83d18738085	true	id.token.claim
2eef405d-27e9-42ab-a93d-a83d18738085	true	access.token.claim
2eef405d-27e9-42ab-a93d-a83d18738085	family_name	claim.name
2eef405d-27e9-42ab-a93d-a83d18738085	String	jsonType.label
3b1b4c49-2327-411d-9f9e-ba6f78c50268	true	introspection.token.claim
3b1b4c49-2327-411d-9f9e-ba6f78c50268	true	userinfo.token.claim
3b1b4c49-2327-411d-9f9e-ba6f78c50268	nickname	user.attribute
3b1b4c49-2327-411d-9f9e-ba6f78c50268	true	id.token.claim
3b1b4c49-2327-411d-9f9e-ba6f78c50268	true	access.token.claim
3b1b4c49-2327-411d-9f9e-ba6f78c50268	nickname	claim.name
3b1b4c49-2327-411d-9f9e-ba6f78c50268	String	jsonType.label
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	true	introspection.token.claim
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	true	userinfo.token.claim
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	locale	user.attribute
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	true	id.token.claim
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	true	access.token.claim
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	locale	claim.name
5859a7c7-59c2-4921-b38a-2f10e8c57ee1	String	jsonType.label
60aa8a5d-3e4b-4da1-9740-48d1a4d2819d	true	introspection.token.claim
60aa8a5d-3e4b-4da1-9740-48d1a4d2819d	true	userinfo.token.claim
60aa8a5d-3e4b-4da1-9740-48d1a4d2819d	true	id.token.claim
60aa8a5d-3e4b-4da1-9740-48d1a4d2819d	true	access.token.claim
60f59f7a-5409-427d-a24c-b06008727a93	true	introspection.token.claim
60f59f7a-5409-427d-a24c-b06008727a93	true	userinfo.token.claim
60f59f7a-5409-427d-a24c-b06008727a93	firstName	user.attribute
60f59f7a-5409-427d-a24c-b06008727a93	true	id.token.claim
60f59f7a-5409-427d-a24c-b06008727a93	true	access.token.claim
60f59f7a-5409-427d-a24c-b06008727a93	given_name	claim.name
60f59f7a-5409-427d-a24c-b06008727a93	String	jsonType.label
7d4f1a7a-2329-44dd-b84d-154d89106bd4	true	introspection.token.claim
7d4f1a7a-2329-44dd-b84d-154d89106bd4	true	userinfo.token.claim
7d4f1a7a-2329-44dd-b84d-154d89106bd4	username	user.attribute
7d4f1a7a-2329-44dd-b84d-154d89106bd4	true	id.token.claim
7d4f1a7a-2329-44dd-b84d-154d89106bd4	true	access.token.claim
7d4f1a7a-2329-44dd-b84d-154d89106bd4	preferred_username	claim.name
7d4f1a7a-2329-44dd-b84d-154d89106bd4	String	jsonType.label
80d55f94-60b7-42aa-bc24-738a3bc83521	true	introspection.token.claim
80d55f94-60b7-42aa-bc24-738a3bc83521	true	userinfo.token.claim
80d55f94-60b7-42aa-bc24-738a3bc83521	website	user.attribute
80d55f94-60b7-42aa-bc24-738a3bc83521	true	id.token.claim
80d55f94-60b7-42aa-bc24-738a3bc83521	true	access.token.claim
80d55f94-60b7-42aa-bc24-738a3bc83521	website	claim.name
80d55f94-60b7-42aa-bc24-738a3bc83521	String	jsonType.label
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	true	introspection.token.claim
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	true	userinfo.token.claim
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	updatedAt	user.attribute
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	true	id.token.claim
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	true	access.token.claim
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	updated_at	claim.name
8abfe4c8-793d-4c84-878f-f1c28e7b3f58	long	jsonType.label
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	true	introspection.token.claim
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	true	userinfo.token.claim
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	middleName	user.attribute
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	true	id.token.claim
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	true	access.token.claim
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	middle_name	claim.name
8c424eaf-6e5b-4df4-8159-8f4aa1e80676	String	jsonType.label
9088fbb3-710b-48cd-88fa-0d296c117af4	true	introspection.token.claim
9088fbb3-710b-48cd-88fa-0d296c117af4	true	userinfo.token.claim
9088fbb3-710b-48cd-88fa-0d296c117af4	birthdate	user.attribute
9088fbb3-710b-48cd-88fa-0d296c117af4	true	id.token.claim
9088fbb3-710b-48cd-88fa-0d296c117af4	true	access.token.claim
9088fbb3-710b-48cd-88fa-0d296c117af4	birthdate	claim.name
9088fbb3-710b-48cd-88fa-0d296c117af4	String	jsonType.label
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	true	introspection.token.claim
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	true	userinfo.token.claim
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	gender	user.attribute
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	true	id.token.claim
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	true	access.token.claim
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	gender	claim.name
a6ff0d54-542c-4a3a-9468-9ba119f8d48c	String	jsonType.label
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	true	introspection.token.claim
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	true	userinfo.token.claim
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	picture	user.attribute
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	true	id.token.claim
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	true	access.token.claim
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	picture	claim.name
b98a3b06-0d52-4f60-b8fe-804a8c9bb36a	String	jsonType.label
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	true	introspection.token.claim
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	true	userinfo.token.claim
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	zoneinfo	user.attribute
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	true	id.token.claim
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	true	access.token.claim
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	zoneinfo	claim.name
bd80e5c3-fc8c-456a-b6d3-fd84c4830832	String	jsonType.label
c15eada7-1174-488a-be41-7bad8e1ed2bc	true	introspection.token.claim
c15eada7-1174-488a-be41-7bad8e1ed2bc	true	userinfo.token.claim
c15eada7-1174-488a-be41-7bad8e1ed2bc	profile	user.attribute
c15eada7-1174-488a-be41-7bad8e1ed2bc	true	id.token.claim
c15eada7-1174-488a-be41-7bad8e1ed2bc	true	access.token.claim
c15eada7-1174-488a-be41-7bad8e1ed2bc	profile	claim.name
c15eada7-1174-488a-be41-7bad8e1ed2bc	String	jsonType.label
6957c70c-1d10-45d9-8d28-3b5db4087098	true	introspection.token.claim
6957c70c-1d10-45d9-8d28-3b5db4087098	true	userinfo.token.claim
6957c70c-1d10-45d9-8d28-3b5db4087098	emailVerified	user.attribute
6957c70c-1d10-45d9-8d28-3b5db4087098	true	id.token.claim
6957c70c-1d10-45d9-8d28-3b5db4087098	true	access.token.claim
6957c70c-1d10-45d9-8d28-3b5db4087098	email_verified	claim.name
6957c70c-1d10-45d9-8d28-3b5db4087098	boolean	jsonType.label
ce6c40e2-5c00-467a-b053-78b87e9ef07b	true	introspection.token.claim
ce6c40e2-5c00-467a-b053-78b87e9ef07b	true	userinfo.token.claim
ce6c40e2-5c00-467a-b053-78b87e9ef07b	email	user.attribute
ce6c40e2-5c00-467a-b053-78b87e9ef07b	true	id.token.claim
ce6c40e2-5c00-467a-b053-78b87e9ef07b	true	access.token.claim
ce6c40e2-5c00-467a-b053-78b87e9ef07b	email	claim.name
ce6c40e2-5c00-467a-b053-78b87e9ef07b	String	jsonType.label
5d8b044e-567f-4748-9909-4b95abb73785	formatted	user.attribute.formatted
5d8b044e-567f-4748-9909-4b95abb73785	country	user.attribute.country
5d8b044e-567f-4748-9909-4b95abb73785	true	introspection.token.claim
5d8b044e-567f-4748-9909-4b95abb73785	postal_code	user.attribute.postal_code
5d8b044e-567f-4748-9909-4b95abb73785	true	userinfo.token.claim
5d8b044e-567f-4748-9909-4b95abb73785	street	user.attribute.street
5d8b044e-567f-4748-9909-4b95abb73785	true	id.token.claim
5d8b044e-567f-4748-9909-4b95abb73785	region	user.attribute.region
5d8b044e-567f-4748-9909-4b95abb73785	true	access.token.claim
5d8b044e-567f-4748-9909-4b95abb73785	locality	user.attribute.locality
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	true	introspection.token.claim
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	true	userinfo.token.claim
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	phoneNumber	user.attribute
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	true	id.token.claim
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	true	access.token.claim
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	phone_number	claim.name
1c9c38c0-6706-4b77-9b96-5ce16ba58f17	String	jsonType.label
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	true	introspection.token.claim
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	true	userinfo.token.claim
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	phoneNumberVerified	user.attribute
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	true	id.token.claim
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	true	access.token.claim
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	phone_number_verified	claim.name
7e0dd6cf-cd91-4354-9a35-9db72d66d09f	boolean	jsonType.label
0f223d92-35a4-4c66-8189-636a34d27b5d	true	introspection.token.claim
0f223d92-35a4-4c66-8189-636a34d27b5d	true	multivalued
0f223d92-35a4-4c66-8189-636a34d27b5d	foo	user.attribute
0f223d92-35a4-4c66-8189-636a34d27b5d	true	access.token.claim
0f223d92-35a4-4c66-8189-636a34d27b5d	realm_access.roles	claim.name
0f223d92-35a4-4c66-8189-636a34d27b5d	String	jsonType.label
19d136c7-7071-401e-8bc1-fc28312b501f	true	introspection.token.claim
19d136c7-7071-401e-8bc1-fc28312b501f	true	multivalued
19d136c7-7071-401e-8bc1-fc28312b501f	foo	user.attribute
19d136c7-7071-401e-8bc1-fc28312b501f	true	access.token.claim
19d136c7-7071-401e-8bc1-fc28312b501f	resource_access.${client_id}.roles	claim.name
19d136c7-7071-401e-8bc1-fc28312b501f	String	jsonType.label
b335dd68-6b9f-4c65-bba0-fa291b098788	true	introspection.token.claim
b335dd68-6b9f-4c65-bba0-fa291b098788	true	access.token.claim
5b492b3a-685f-4c14-9541-1e7b17bf6c11	true	introspection.token.claim
5b492b3a-685f-4c14-9541-1e7b17bf6c11	true	access.token.claim
8ce44369-351f-4c92-81a6-0acf43ead354	true	introspection.token.claim
8ce44369-351f-4c92-81a6-0acf43ead354	true	multivalued
8ce44369-351f-4c92-81a6-0acf43ead354	foo	user.attribute
8ce44369-351f-4c92-81a6-0acf43ead354	true	id.token.claim
8ce44369-351f-4c92-81a6-0acf43ead354	true	access.token.claim
8ce44369-351f-4c92-81a6-0acf43ead354	groups	claim.name
8ce44369-351f-4c92-81a6-0acf43ead354	String	jsonType.label
ee9f93fe-a900-4bf9-a015-047d314010ef	true	introspection.token.claim
ee9f93fe-a900-4bf9-a015-047d314010ef	true	userinfo.token.claim
ee9f93fe-a900-4bf9-a015-047d314010ef	username	user.attribute
ee9f93fe-a900-4bf9-a015-047d314010ef	true	id.token.claim
ee9f93fe-a900-4bf9-a015-047d314010ef	true	access.token.claim
ee9f93fe-a900-4bf9-a015-047d314010ef	upn	claim.name
ee9f93fe-a900-4bf9-a015-047d314010ef	String	jsonType.label
442c538f-8f6d-4aa0-8270-7d0aaca52358	true	introspection.token.claim
442c538f-8f6d-4aa0-8270-7d0aaca52358	true	id.token.claim
442c538f-8f6d-4aa0-8270-7d0aaca52358	true	access.token.claim
ea819545-87e8-492d-a199-c8c90e489ef3	false	single
ea819545-87e8-492d-a199-c8c90e489ef3	Basic	attribute.nameformat
ea819545-87e8-492d-a199-c8c90e489ef3	Role	attribute.name
0e451bf0-d25b-4889-85e0-e13e159ec016	true	introspection.token.claim
0e451bf0-d25b-4889-85e0-e13e159ec016	true	userinfo.token.claim
0e451bf0-d25b-4889-85e0-e13e159ec016	birthdate	user.attribute
0e451bf0-d25b-4889-85e0-e13e159ec016	true	id.token.claim
0e451bf0-d25b-4889-85e0-e13e159ec016	true	access.token.claim
0e451bf0-d25b-4889-85e0-e13e159ec016	birthdate	claim.name
0e451bf0-d25b-4889-85e0-e13e159ec016	String	jsonType.label
0ec6c016-d053-4abd-a607-6c3d427a154d	true	introspection.token.claim
0ec6c016-d053-4abd-a607-6c3d427a154d	true	userinfo.token.claim
0ec6c016-d053-4abd-a607-6c3d427a154d	username	user.attribute
0ec6c016-d053-4abd-a607-6c3d427a154d	true	id.token.claim
0ec6c016-d053-4abd-a607-6c3d427a154d	true	access.token.claim
0ec6c016-d053-4abd-a607-6c3d427a154d	preferred_username	claim.name
0ec6c016-d053-4abd-a607-6c3d427a154d	String	jsonType.label
30562d28-3c48-4d05-986e-2c6d3ed51ba7	true	introspection.token.claim
30562d28-3c48-4d05-986e-2c6d3ed51ba7	true	userinfo.token.claim
30562d28-3c48-4d05-986e-2c6d3ed51ba7	firstName	user.attribute
30562d28-3c48-4d05-986e-2c6d3ed51ba7	true	id.token.claim
30562d28-3c48-4d05-986e-2c6d3ed51ba7	true	access.token.claim
30562d28-3c48-4d05-986e-2c6d3ed51ba7	given_name	claim.name
30562d28-3c48-4d05-986e-2c6d3ed51ba7	String	jsonType.label
47d33c75-046f-4df4-84bc-124a4018a1c2	true	introspection.token.claim
47d33c75-046f-4df4-84bc-124a4018a1c2	true	userinfo.token.claim
47d33c75-046f-4df4-84bc-124a4018a1c2	zoneinfo	user.attribute
47d33c75-046f-4df4-84bc-124a4018a1c2	true	id.token.claim
47d33c75-046f-4df4-84bc-124a4018a1c2	true	access.token.claim
47d33c75-046f-4df4-84bc-124a4018a1c2	zoneinfo	claim.name
47d33c75-046f-4df4-84bc-124a4018a1c2	String	jsonType.label
49d476cc-fb4a-4fb0-b212-221ac5b29c21	true	introspection.token.claim
49d476cc-fb4a-4fb0-b212-221ac5b29c21	true	userinfo.token.claim
49d476cc-fb4a-4fb0-b212-221ac5b29c21	true	id.token.claim
49d476cc-fb4a-4fb0-b212-221ac5b29c21	true	access.token.claim
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	true	introspection.token.claim
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	true	userinfo.token.claim
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	lastName	user.attribute
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	true	id.token.claim
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	true	access.token.claim
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	family_name	claim.name
4e3a2dea-8dd3-45c6-8999-d04765b1e55b	String	jsonType.label
65c620bf-7d82-4b68-82b2-4847d65237b3	true	introspection.token.claim
65c620bf-7d82-4b68-82b2-4847d65237b3	true	userinfo.token.claim
65c620bf-7d82-4b68-82b2-4847d65237b3	website	user.attribute
65c620bf-7d82-4b68-82b2-4847d65237b3	true	id.token.claim
65c620bf-7d82-4b68-82b2-4847d65237b3	true	access.token.claim
65c620bf-7d82-4b68-82b2-4847d65237b3	website	claim.name
65c620bf-7d82-4b68-82b2-4847d65237b3	String	jsonType.label
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	true	introspection.token.claim
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	true	userinfo.token.claim
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	gender	user.attribute
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	true	id.token.claim
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	true	access.token.claim
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	gender	claim.name
6ef97595-f3ed-4e0c-b911-818b1b0b1c23	String	jsonType.label
71d026e8-5a9c-4319-b831-e4cb2e59afc7	true	introspection.token.claim
71d026e8-5a9c-4319-b831-e4cb2e59afc7	true	userinfo.token.claim
71d026e8-5a9c-4319-b831-e4cb2e59afc7	nickname	user.attribute
71d026e8-5a9c-4319-b831-e4cb2e59afc7	true	id.token.claim
71d026e8-5a9c-4319-b831-e4cb2e59afc7	true	access.token.claim
71d026e8-5a9c-4319-b831-e4cb2e59afc7	nickname	claim.name
71d026e8-5a9c-4319-b831-e4cb2e59afc7	String	jsonType.label
95248e55-6f0f-4510-8a81-6b5043643860	true	introspection.token.claim
95248e55-6f0f-4510-8a81-6b5043643860	true	userinfo.token.claim
95248e55-6f0f-4510-8a81-6b5043643860	middleName	user.attribute
95248e55-6f0f-4510-8a81-6b5043643860	true	id.token.claim
95248e55-6f0f-4510-8a81-6b5043643860	true	access.token.claim
95248e55-6f0f-4510-8a81-6b5043643860	middle_name	claim.name
95248e55-6f0f-4510-8a81-6b5043643860	String	jsonType.label
955090a8-ee19-4634-8fdb-9aee2687e086	true	introspection.token.claim
955090a8-ee19-4634-8fdb-9aee2687e086	true	userinfo.token.claim
955090a8-ee19-4634-8fdb-9aee2687e086	profile	user.attribute
955090a8-ee19-4634-8fdb-9aee2687e086	true	id.token.claim
955090a8-ee19-4634-8fdb-9aee2687e086	true	access.token.claim
955090a8-ee19-4634-8fdb-9aee2687e086	profile	claim.name
955090a8-ee19-4634-8fdb-9aee2687e086	String	jsonType.label
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	true	introspection.token.claim
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	true	userinfo.token.claim
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	picture	user.attribute
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	true	id.token.claim
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	true	access.token.claim
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	picture	claim.name
a5c5fb52-4169-4fae-bef0-39afbceb5bf3	String	jsonType.label
c201ae94-f942-4fb8-be8f-2163fbf4ec65	true	introspection.token.claim
c201ae94-f942-4fb8-be8f-2163fbf4ec65	true	userinfo.token.claim
c201ae94-f942-4fb8-be8f-2163fbf4ec65	locale	user.attribute
c201ae94-f942-4fb8-be8f-2163fbf4ec65	true	id.token.claim
c201ae94-f942-4fb8-be8f-2163fbf4ec65	true	access.token.claim
c201ae94-f942-4fb8-be8f-2163fbf4ec65	locale	claim.name
c201ae94-f942-4fb8-be8f-2163fbf4ec65	String	jsonType.label
ea7b3b26-4829-474a-b03c-ef163670b990	true	introspection.token.claim
ea7b3b26-4829-474a-b03c-ef163670b990	true	userinfo.token.claim
ea7b3b26-4829-474a-b03c-ef163670b990	updatedAt	user.attribute
ea7b3b26-4829-474a-b03c-ef163670b990	true	id.token.claim
ea7b3b26-4829-474a-b03c-ef163670b990	true	access.token.claim
ea7b3b26-4829-474a-b03c-ef163670b990	updated_at	claim.name
ea7b3b26-4829-474a-b03c-ef163670b990	long	jsonType.label
74be4107-36ad-402c-9b3a-f3a3caeeebfc	true	introspection.token.claim
74be4107-36ad-402c-9b3a-f3a3caeeebfc	true	userinfo.token.claim
74be4107-36ad-402c-9b3a-f3a3caeeebfc	emailVerified	user.attribute
74be4107-36ad-402c-9b3a-f3a3caeeebfc	true	id.token.claim
74be4107-36ad-402c-9b3a-f3a3caeeebfc	true	access.token.claim
74be4107-36ad-402c-9b3a-f3a3caeeebfc	email_verified	claim.name
74be4107-36ad-402c-9b3a-f3a3caeeebfc	boolean	jsonType.label
db039e16-d6e8-492b-921d-5702ba2d4f46	true	introspection.token.claim
db039e16-d6e8-492b-921d-5702ba2d4f46	true	userinfo.token.claim
db039e16-d6e8-492b-921d-5702ba2d4f46	email	user.attribute
db039e16-d6e8-492b-921d-5702ba2d4f46	true	id.token.claim
db039e16-d6e8-492b-921d-5702ba2d4f46	true	access.token.claim
db039e16-d6e8-492b-921d-5702ba2d4f46	email	claim.name
db039e16-d6e8-492b-921d-5702ba2d4f46	String	jsonType.label
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	formatted	user.attribute.formatted
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	country	user.attribute.country
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	true	introspection.token.claim
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	postal_code	user.attribute.postal_code
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	true	userinfo.token.claim
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	street	user.attribute.street
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	true	id.token.claim
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	region	user.attribute.region
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	true	access.token.claim
0cac2e75-f9dc-466e-947a-1122c9a0a5f3	locality	user.attribute.locality
621db25c-54ba-4a40-8dc0-024de7f0343f	true	introspection.token.claim
621db25c-54ba-4a40-8dc0-024de7f0343f	true	userinfo.token.claim
621db25c-54ba-4a40-8dc0-024de7f0343f	phoneNumberVerified	user.attribute
621db25c-54ba-4a40-8dc0-024de7f0343f	true	id.token.claim
621db25c-54ba-4a40-8dc0-024de7f0343f	true	access.token.claim
621db25c-54ba-4a40-8dc0-024de7f0343f	phone_number_verified	claim.name
621db25c-54ba-4a40-8dc0-024de7f0343f	boolean	jsonType.label
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	true	introspection.token.claim
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	true	userinfo.token.claim
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	phoneNumber	user.attribute
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	true	id.token.claim
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	true	access.token.claim
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	phone_number	claim.name
9ed3454a-60bc-48e8-9a40-0caa03eacaf5	String	jsonType.label
90b61d3e-343c-4c34-9508-acca94d7017f	true	introspection.token.claim
90b61d3e-343c-4c34-9508-acca94d7017f	true	access.token.claim
9b4e9fb0-cc18-443a-99f3-3265aecf6859	true	introspection.token.claim
9b4e9fb0-cc18-443a-99f3-3265aecf6859	true	multivalued
9b4e9fb0-cc18-443a-99f3-3265aecf6859	foo	user.attribute
9b4e9fb0-cc18-443a-99f3-3265aecf6859	true	access.token.claim
9b4e9fb0-cc18-443a-99f3-3265aecf6859	resource_access.${client_id}.roles	claim.name
9b4e9fb0-cc18-443a-99f3-3265aecf6859	String	jsonType.label
aa1ff9e5-679f-4611-837c-8e03786feba7	true	introspection.token.claim
aa1ff9e5-679f-4611-837c-8e03786feba7	true	multivalued
aa1ff9e5-679f-4611-837c-8e03786feba7	foo	user.attribute
aa1ff9e5-679f-4611-837c-8e03786feba7	true	access.token.claim
aa1ff9e5-679f-4611-837c-8e03786feba7	realm_access.roles	claim.name
aa1ff9e5-679f-4611-837c-8e03786feba7	String	jsonType.label
a9425bbc-29fb-4805-b424-12bef3238afa	true	introspection.token.claim
a9425bbc-29fb-4805-b424-12bef3238afa	true	access.token.claim
76cee4ec-1086-4b17-b786-63d5fd7113fd	true	introspection.token.claim
76cee4ec-1086-4b17-b786-63d5fd7113fd	true	userinfo.token.claim
76cee4ec-1086-4b17-b786-63d5fd7113fd	username	user.attribute
76cee4ec-1086-4b17-b786-63d5fd7113fd	true	id.token.claim
76cee4ec-1086-4b17-b786-63d5fd7113fd	true	access.token.claim
76cee4ec-1086-4b17-b786-63d5fd7113fd	upn	claim.name
76cee4ec-1086-4b17-b786-63d5fd7113fd	String	jsonType.label
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	true	introspection.token.claim
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	true	multivalued
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	foo	user.attribute
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	true	id.token.claim
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	true	access.token.claim
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	groups	claim.name
7d3680a1-1bbb-4109-9b2e-f888ca10ffc3	String	jsonType.label
a8bb4aa4-9980-4c5d-a433-6215fea69fb8	true	introspection.token.claim
a8bb4aa4-9980-4c5d-a433-6215fea69fb8	true	id.token.claim
a8bb4aa4-9980-4c5d-a433-6215fea69fb8	true	access.token.claim
d7aae392-1079-48c6-b6bd-4d719a075da5	true	introspection.token.claim
d7aae392-1079-48c6-b6bd-4d719a075da5	true	userinfo.token.claim
d7aae392-1079-48c6-b6bd-4d719a075da5	locale	user.attribute
d7aae392-1079-48c6-b6bd-4d719a075da5	true	id.token.claim
d7aae392-1079-48c6-b6bd-4d719a075da5	true	access.token.claim
d7aae392-1079-48c6-b6bd-4d719a075da5	locale	claim.name
d7aae392-1079-48c6-b6bd-4d719a075da5	String	jsonType.label
5cb5148d-e877-48a5-ba43-66a9b4e7e061	clientAddress	user.session.note
5cb5148d-e877-48a5-ba43-66a9b4e7e061	true	introspection.token.claim
5cb5148d-e877-48a5-ba43-66a9b4e7e061	true	id.token.claim
5cb5148d-e877-48a5-ba43-66a9b4e7e061	true	access.token.claim
5cb5148d-e877-48a5-ba43-66a9b4e7e061	clientAddress	claim.name
5cb5148d-e877-48a5-ba43-66a9b4e7e061	String	jsonType.label
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	client_id	user.session.note
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	true	introspection.token.claim
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	true	id.token.claim
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	true	access.token.claim
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	client_id	claim.name
bd949ac5-5d04-49dc-bf08-23f1fb595ac4	String	jsonType.label
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	clientHost	user.session.note
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	true	introspection.token.claim
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	true	id.token.claim
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	true	access.token.claim
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	clientHost	claim.name
e90b7cd7-e834-4cb5-89c2-e50f4b0285cf	String	jsonType.label
\.


--
-- TOC entry 4175 (class 0 OID 16644)
-- Dependencies: 267
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
e79a028c-615a-4cf7-8850-e49274b70888	60	300	300	\N	\N	\N	t	f	0	\N	doc-analysis	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	5470c48e-e772-4bfb-ad48-aa4772deeeb3	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	410756cc-f22c-4b6f-b3be-3cb7540628ca	2158f692-8d5f-457a-adad-a8304fb7d513	4c8ff1ef-142f-433e-8d73-e5c1cd66087e	6806780a-d1f0-4d85-b639-372dbba9ccfa	ee07cb62-63ee-4f5b-bc81-899620cb0e46	2592000	f	900	t	f	ac9bcd99-eb4d-4a2d-8c10-ce5820db8b2f	0	f	0	0	54015ee2-002c-43bb-82b8-ef5ca99ba2c4
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	7c9f997b-7e37-4849-8110-6b2374f15399	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	fdb2816f-3bf2-403e-a6cf-ee734a157524	0ca78339-815b-48e4-a7ad-c233244d7f07	09c8f64d-36be-45ab-983e-979e3f35729e	b9a4c737-541f-41d5-8976-7560941251bb	a43a7112-d91d-4adc-88f0-9a9c91abe43b	2592000	f	900	t	f	2c6d133d-0e6f-4b1a-84f3-0faf74f0e80e	0	f	0	0	c204f9da-6bb1-4b9b-aa8f-4460a3ac701f
\.


--
-- TOC entry 4176 (class 0 OID 16677)
-- Dependencies: 268
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	
_browser_header.xContentTypeOptions	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	nosniff
_browser_header.referrerPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	no-referrer
_browser_header.xRobotsTag	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	none
_browser_header.xFrameOptions	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	SAMEORIGIN
_browser_header.contentSecurityPolicy	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	1; mode=block
_browser_header.strictTransportSecurity	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	max-age=31536000; includeSubDomains
bruteForceProtected	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	false
permanentLockout	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	false
maxFailureWaitSeconds	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	900
minimumQuickLoginWaitSeconds	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	60
waitIncrementSeconds	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	60
quickLoginCheckMilliSeconds	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	1000
maxDeltaTimeSeconds	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	43200
failureFactor	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	30
realmReusableOtpCode	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	false
displayName	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	Keycloak
displayNameHtml	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	RS256
offlineSessionMaxLifespanEnabled	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	false
offlineSessionMaxLifespan	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	5184000
realmReusableOtpCode	e79a028c-615a-4cf7-8850-e49274b70888	false
oauth2DeviceCodeLifespan	e79a028c-615a-4cf7-8850-e49274b70888	600
oauth2DevicePollingInterval	e79a028c-615a-4cf7-8850-e49274b70888	5
cibaBackchannelTokenDeliveryMode	e79a028c-615a-4cf7-8850-e49274b70888	poll
cibaExpiresIn	e79a028c-615a-4cf7-8850-e49274b70888	120
cibaInterval	e79a028c-615a-4cf7-8850-e49274b70888	5
cibaAuthRequestedUserHint	e79a028c-615a-4cf7-8850-e49274b70888	login_hint
parRequestUriLifespan	e79a028c-615a-4cf7-8850-e49274b70888	60
frontendUrl	e79a028c-615a-4cf7-8850-e49274b70888	
acr.loa.map	e79a028c-615a-4cf7-8850-e49274b70888	{}
clientSessionIdleTimeout	e79a028c-615a-4cf7-8850-e49274b70888	0
clientSessionMaxLifespan	e79a028c-615a-4cf7-8850-e49274b70888	0
clientOfflineSessionIdleTimeout	e79a028c-615a-4cf7-8850-e49274b70888	0
clientOfflineSessionMaxLifespan	e79a028c-615a-4cf7-8850-e49274b70888	0
displayName	e79a028c-615a-4cf7-8850-e49274b70888	АСАД "Интеллект"
displayNameHtml	e79a028c-615a-4cf7-8850-e49274b70888	
bruteForceProtected	e79a028c-615a-4cf7-8850-e49274b70888	false
permanentLockout	e79a028c-615a-4cf7-8850-e49274b70888	false
maxFailureWaitSeconds	e79a028c-615a-4cf7-8850-e49274b70888	900
minimumQuickLoginWaitSeconds	e79a028c-615a-4cf7-8850-e49274b70888	60
waitIncrementSeconds	e79a028c-615a-4cf7-8850-e49274b70888	60
quickLoginCheckMilliSeconds	e79a028c-615a-4cf7-8850-e49274b70888	1000
maxDeltaTimeSeconds	e79a028c-615a-4cf7-8850-e49274b70888	43200
failureFactor	e79a028c-615a-4cf7-8850-e49274b70888	30
actionTokenGeneratedByAdminLifespan	e79a028c-615a-4cf7-8850-e49274b70888	43200
actionTokenGeneratedByUserLifespan	e79a028c-615a-4cf7-8850-e49274b70888	300
defaultSignatureAlgorithm	e79a028c-615a-4cf7-8850-e49274b70888	RS256
offlineSessionMaxLifespanEnabled	e79a028c-615a-4cf7-8850-e49274b70888	false
offlineSessionMaxLifespan	e79a028c-615a-4cf7-8850-e49274b70888	5184000
webAuthnPolicyRpEntityName	e79a028c-615a-4cf7-8850-e49274b70888	keycloak
webAuthnPolicySignatureAlgorithms	e79a028c-615a-4cf7-8850-e49274b70888	ES256
webAuthnPolicyRpId	e79a028c-615a-4cf7-8850-e49274b70888	
webAuthnPolicyAttestationConveyancePreference	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyAuthenticatorAttachment	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyRequireResidentKey	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyUserVerificationRequirement	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyCreateTimeout	e79a028c-615a-4cf7-8850-e49274b70888	0
webAuthnPolicyAvoidSameAuthenticatorRegister	e79a028c-615a-4cf7-8850-e49274b70888	false
webAuthnPolicyRpEntityNamePasswordless	e79a028c-615a-4cf7-8850-e49274b70888	keycloak
webAuthnPolicySignatureAlgorithmsPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	ES256
webAuthnPolicyRpIdPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	
webAuthnPolicyAttestationConveyancePreferencePasswordless	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyAuthenticatorAttachmentPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyRequireResidentKeyPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyUserVerificationRequirementPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	not specified
webAuthnPolicyCreateTimeoutPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	0
webAuthnPolicyAvoidSameAuthenticatorRegisterPasswordless	e79a028c-615a-4cf7-8850-e49274b70888	false
client-policies.profiles	e79a028c-615a-4cf7-8850-e49274b70888	{"profiles":[]}
client-policies.policies	e79a028c-615a-4cf7-8850-e49274b70888	{"policies":[]}
_browser_header.contentSecurityPolicyReportOnly	e79a028c-615a-4cf7-8850-e49274b70888	
_browser_header.xContentTypeOptions	e79a028c-615a-4cf7-8850-e49274b70888	nosniff
_browser_header.referrerPolicy	e79a028c-615a-4cf7-8850-e49274b70888	no-referrer
_browser_header.xRobotsTag	e79a028c-615a-4cf7-8850-e49274b70888	none
_browser_header.xFrameOptions	e79a028c-615a-4cf7-8850-e49274b70888	SAMEORIGIN
_browser_header.contentSecurityPolicy	e79a028c-615a-4cf7-8850-e49274b70888	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	e79a028c-615a-4cf7-8850-e49274b70888	1; mode=block
_browser_header.strictTransportSecurity	e79a028c-615a-4cf7-8850-e49274b70888	max-age=31536000; includeSubDomains
\.


--
-- TOC entry 4177 (class 0 OID 16682)
-- Dependencies: 269
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- TOC entry 4178 (class 0 OID 16685)
-- Dependencies: 270
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- TOC entry 4179 (class 0 OID 16688)
-- Dependencies: 271
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	jboss-logging
e79a028c-615a-4cf7-8850-e49274b70888	jboss-logging
\.


--
-- TOC entry 4180 (class 0 OID 16691)
-- Dependencies: 272
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- TOC entry 4181 (class 0 OID 16696)
-- Dependencies: 273
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576
password	password	t	t	e79a028c-615a-4cf7-8850-e49274b70888
\.


--
-- TOC entry 4182 (class 0 OID 16703)
-- Dependencies: 274
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- TOC entry 4183 (class 0 OID 16708)
-- Dependencies: 275
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- TOC entry 4184 (class 0 OID 16711)
-- Dependencies: 276
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.redirect_uris (client_id, value) FROM stdin;
352ffebc-61f6-4559-8273-dc37678f202c	/realms/master/account/*
e4cb5111-b259-47d0-8a21-d01b0232264b	/realms/master/account/*
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	/admin/master/console/*
3a8b7049-f9a6-410f-b2ad-3a0636ac2ab1	/realms/doc-analysis/account/*
cd13309d-ade7-4da3-9e23-4578525d91dd	/realms/doc-analysis/account/*
046748c7-389d-4b7f-8c0d-858f48da46f8	/admin/doc-analysis/console/*
d3610fe9-5387-4fb2-b30c-ee6309fe5742	/*
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	*
e8cbcfbc-caa1-482e-a719-599f9ea03e88	*
\.


--
-- TOC entry 4185 (class 0 OID 16714)
-- Dependencies: 277
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- TOC entry 4186 (class 0 OID 16719)
-- Dependencies: 278
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
03b7f77c-f999-4708-91b9-468e1a3a0585	VERIFY_EMAIL	Verify Email	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	VERIFY_EMAIL	50
fdaf155a-1b22-4013-b836-45538506d773	UPDATE_PROFILE	Update Profile	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	UPDATE_PROFILE	40
eba32947-9cc2-4b60-bea1-5316bf5d4242	CONFIGURE_TOTP	Configure OTP	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	CONFIGURE_TOTP	10
a955771a-5b56-4df2-830b-d6821ad1b0ed	UPDATE_PASSWORD	Update Password	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	UPDATE_PASSWORD	30
39de0bff-4204-486f-82ed-3d65b0ca5614	TERMS_AND_CONDITIONS	Terms and Conditions	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	f	TERMS_AND_CONDITIONS	20
45628b51-4f85-48b2-a763-5f1e7820e862	delete_account	Delete Account	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	f	f	delete_account	60
1dac5d28-6a2d-44a2-a193-20ed459f1edd	update_user_locale	Update User Locale	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	update_user_locale	1000
6a375b5a-fb5d-4d76-a36c-e46a0495c76f	webauthn-register	Webauthn Register	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	webauthn-register	70
59d7117a-eec0-4807-82ec-099bd3e35ee8	webauthn-register-passwordless	Webauthn Register Passwordless	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	t	f	webauthn-register-passwordless	80
5bb83b31-4bac-4e17-8772-673e55c4227c	VERIFY_EMAIL	Verify Email	e79a028c-615a-4cf7-8850-e49274b70888	t	f	VERIFY_EMAIL	50
21c5d013-849b-4460-9d1b-4a388288e8b6	UPDATE_PROFILE	Update Profile	e79a028c-615a-4cf7-8850-e49274b70888	t	f	UPDATE_PROFILE	40
a8ffe085-8582-4eda-aa5f-c7dba3b97ade	CONFIGURE_TOTP	Configure OTP	e79a028c-615a-4cf7-8850-e49274b70888	t	f	CONFIGURE_TOTP	10
5a6d0beb-500a-472f-9f7e-78c3fd2ce2b2	UPDATE_PASSWORD	Update Password	e79a028c-615a-4cf7-8850-e49274b70888	t	f	UPDATE_PASSWORD	30
ea9b7018-4b10-48cd-b196-a00e86d2e0b1	TERMS_AND_CONDITIONS	Terms and Conditions	e79a028c-615a-4cf7-8850-e49274b70888	f	f	TERMS_AND_CONDITIONS	20
aa004680-2ac2-4983-af3d-3aea09b509cc	delete_account	Delete Account	e79a028c-615a-4cf7-8850-e49274b70888	f	f	delete_account	60
18afff2e-1f3a-42f7-95a9-e07fb9e64f18	update_user_locale	Update User Locale	e79a028c-615a-4cf7-8850-e49274b70888	t	f	update_user_locale	1000
f77495eb-fba5-4fb5-b15a-281d6831e6a2	webauthn-register	Webauthn Register	e79a028c-615a-4cf7-8850-e49274b70888	t	f	webauthn-register	70
a88fefbf-11d9-4922-be32-3687d9301d80	webauthn-register-passwordless	Webauthn Register Passwordless	e79a028c-615a-4cf7-8850-e49274b70888	t	f	webauthn-register-passwordless	80
\.


--
-- TOC entry 4187 (class 0 OID 16726)
-- Dependencies: 279
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- TOC entry 4188 (class 0 OID 16732)
-- Dependencies: 280
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- TOC entry 4189 (class 0 OID 16735)
-- Dependencies: 281
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- TOC entry 4190 (class 0 OID 16738)
-- Dependencies: 282
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- TOC entry 4191 (class 0 OID 16743)
-- Dependencies: 283
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- TOC entry 4192 (class 0 OID 16748)
-- Dependencies: 284
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- TOC entry 4193 (class 0 OID 16753)
-- Dependencies: 285
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- TOC entry 4194 (class 0 OID 16759)
-- Dependencies: 286
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- TOC entry 4195 (class 0 OID 16764)
-- Dependencies: 287
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- TOC entry 4196 (class 0 OID 16767)
-- Dependencies: 288
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- TOC entry 4197 (class 0 OID 16772)
-- Dependencies: 289
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
e4cb5111-b259-47d0-8a21-d01b0232264b	8c510253-f45c-48d2-8a51-3426c93528ad
e4cb5111-b259-47d0-8a21-d01b0232264b	016c1c33-dfbe-43c6-a4c5-0bccbb8c0cee
cd13309d-ade7-4da3-9e23-4578525d91dd	87629e29-6b31-4cd2-8720-7b2f302de0ed
cd13309d-ade7-4da3-9e23-4578525d91dd	e630d52e-827f-4ef0-a687-c91997c294c6
\.


--
-- TOC entry 4198 (class 0 OID 16775)
-- Dependencies: 290
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- TOC entry 4199 (class 0 OID 16778)
-- Dependencies: 291
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- TOC entry 4200 (class 0 OID 16784)
-- Dependencies: 292
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- TOC entry 4201 (class 0 OID 16789)
-- Dependencies: 293
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- TOC entry 4202 (class 0 OID 16792)
-- Dependencies: 294
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
a2bb7ed6-3c86-4ce7-b99c-da576722bacc	\N	524072b5-b7e1-43f6-8403-179b8bf20d8b	f	t	\N	\N	\N	dc1c3aeb-f2c9-4169-8e69-2ff1dec73576	admin	1706106535554	\N	0
91f3d9dd-236d-4499-aa80-e93784b3ccbc	\N	89d00f9a-0031-4f2a-9a44-bedbcbfcc9c6	f	t	\N	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	service-account-flask-client	1706197514710	d3610fe9-5387-4fb2-b30c-ee6309fe5742	0
b5a139fc-02ea-401a-95d9-38b512f8ecc5	\N	7ce9f562-b7ba-40a7-b138-8a2011661b7f	f	t	\N	\N	\N	e79a028c-615a-4cf7-8850-e49274b70888	root	1707829251792	\N	0
\.


--
-- TOC entry 4203 (class 0 OID 16800)
-- Dependencies: 295
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- TOC entry 4204 (class 0 OID 16805)
-- Dependencies: 296
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- TOC entry 4205 (class 0 OID 16810)
-- Dependencies: 297
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- TOC entry 4206 (class 0 OID 16815)
-- Dependencies: 298
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- TOC entry 4207 (class 0 OID 16820)
-- Dependencies: 299
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- TOC entry 4208 (class 0 OID 16823)
-- Dependencies: 300
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- TOC entry 4209 (class 0 OID 16827)
-- Dependencies: 301
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
c204f9da-6bb1-4b9b-aa8f-4460a3ac701f	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
1d572f60-f5b8-4335-8067-971c475d93d5	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
e4518591-f183-4be5-a398-98bb5825fc1e	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
3cb506d8-7e3b-4e3c-8baa-bd1fc94dbc66	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
d2c9a7c7-121a-4e33-a9e2-15c569a65168	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
79fcfe2a-b5ae-4761-9514-989c565c07c5	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
3e2608c5-407e-473a-9f9e-2ff09f8f86af	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
780722bb-ba0a-4109-9f70-3a72d865f81a	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
67d2513a-7005-4fff-9bec-b00d1e859249	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
44462235-46aa-45d1-b6e7-5aa2a88c5097	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
ad632e39-368e-4524-b9aa-3f017a77d641	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
c920f101-ed3c-49a0-b1d0-8382b74a8d18	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
4ffe19fc-5eb5-470c-beba-9cfc8f70e4cf	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
47cc9b6b-0780-4a9c-84ec-fbf8034000cc	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
28a15137-da57-4c20-94d4-16a604adb7da	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
ea320088-9324-4000-9be7-33b4f25d8a36	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
cc4f01c6-2f45-4c32-bc5e-296ce9633060	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
5bdb8d51-1457-4846-88cb-f7007d8df3cc	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
d8a29dd6-02bd-4e79-9bad-9209b9108ccf	a2bb7ed6-3c86-4ce7-b99c-da576722bacc
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	91f3d9dd-236d-4499-aa80-e93784b3ccbc
6cea12f3-72b2-4068-beff-5a5730c8bb71	91f3d9dd-236d-4499-aa80-e93784b3ccbc
f8ff5799-8892-4dd8-b47c-ef64503ea65f	91f3d9dd-236d-4499-aa80-e93784b3ccbc
ab226d01-2182-4485-bb16-9a315ad73764	91f3d9dd-236d-4499-aa80-e93784b3ccbc
a5915248-941b-4582-9bd1-2cc75d9247c7	91f3d9dd-236d-4499-aa80-e93784b3ccbc
d5f6a469-96d1-447a-8414-52a8d4bbecae	91f3d9dd-236d-4499-aa80-e93784b3ccbc
a9437a80-ec92-44b6-b370-9e60f0146293	91f3d9dd-236d-4499-aa80-e93784b3ccbc
402ea37a-9556-43f1-b637-70848b6e78b5	91f3d9dd-236d-4499-aa80-e93784b3ccbc
f8fd5bb7-a40d-4da3-baae-3134fbef99ff	91f3d9dd-236d-4499-aa80-e93784b3ccbc
e9fa9980-32db-451d-8a6d-4e3b75842a1a	91f3d9dd-236d-4499-aa80-e93784b3ccbc
616e40eb-c5f3-4de8-9398-007ddaf4232e	91f3d9dd-236d-4499-aa80-e93784b3ccbc
bc6e3568-7869-4db2-a0fb-e2cae05e9905	91f3d9dd-236d-4499-aa80-e93784b3ccbc
72f39e11-9bc0-4ca2-98e1-e284c0987a1f	91f3d9dd-236d-4499-aa80-e93784b3ccbc
b2ad0f81-cab4-4f5c-b031-9b3a1cabf038	91f3d9dd-236d-4499-aa80-e93784b3ccbc
e8575252-c396-4027-8da4-348e772f8eb6	91f3d9dd-236d-4499-aa80-e93784b3ccbc
425b96a1-eb8a-4e88-b290-cca59628d5a3	91f3d9dd-236d-4499-aa80-e93784b3ccbc
0d740c34-f50d-48ef-a821-2f1bccb14e6d	91f3d9dd-236d-4499-aa80-e93784b3ccbc
89d16664-6760-40e7-aa1d-19e9a59ffdf4	91f3d9dd-236d-4499-aa80-e93784b3ccbc
a2a40099-624b-4157-ad2d-28f5ed7f7066	91f3d9dd-236d-4499-aa80-e93784b3ccbc
0da2709f-a0b7-488d-84b4-8b404da55049	91f3d9dd-236d-4499-aa80-e93784b3ccbc
54015ee2-002c-43bb-82b8-ef5ca99ba2c4	b5a139fc-02ea-401a-95d9-38b512f8ecc5
\.


--
-- TOC entry 4210 (class 0 OID 16830)
-- Dependencies: 302
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- TOC entry 4211 (class 0 OID 16836)
-- Dependencies: 303
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- TOC entry 4212 (class 0 OID 16841)
-- Dependencies: 304
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- TOC entry 4213 (class 0 OID 16846)
-- Dependencies: 305
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: keycloak
--

COPY public.web_origins (client_id, value) FROM stdin;
8440c4a7-5a73-4acb-a398-6e9aa49dfd9c	+
046748c7-389d-4b7f-8c0d-858f48da46f8	+
d3610fe9-5387-4fb2-b30c-ee6309fe5742	/*
5b02e86c-bc91-4cdd-938f-b1d6549db7b1	/*
e8cbcfbc-caa1-482e-a719-599f9ea03e88	http://localhost:8081
\.


--
-- TOC entry 3902 (class 2606 OID 16850)
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- TOC entry 3755 (class 2606 OID 16852)
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- TOC entry 3641 (class 2606 OID 16854)
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- TOC entry 3656 (class 2606 OID 16856)
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- TOC entry 3643 (class 2606 OID 16858)
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- TOC entry 3790 (class 2606 OID 16860)
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- TOC entry 3632 (class 2606 OID 16862)
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- TOC entry 3675 (class 2606 OID 16864)
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- TOC entry 3681 (class 2606 OID 16866)
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- TOC entry 3677 (class 2606 OID 16868)
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- TOC entry 3718 (class 2606 OID 16870)
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- TOC entry 3700 (class 2606 OID 16872)
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- TOC entry 3703 (class 2606 OID 16874)
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- TOC entry 3710 (class 2606 OID 16876)
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- TOC entry 3714 (class 2606 OID 16878)
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- TOC entry 3722 (class 2606 OID 16880)
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- TOC entry 3730 (class 2606 OID 16882)
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- TOC entry 3792 (class 2606 OID 16884)
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- TOC entry 3795 (class 2606 OID 16886)
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- TOC entry 3798 (class 2606 OID 16888)
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- TOC entry 3807 (class 2606 OID 16890)
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- TOC entry 3739 (class 2606 OID 16892)
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- TOC entry 3639 (class 2606 OID 16894)
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- TOC entry 3697 (class 2606 OID 16896)
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- TOC entry 3726 (class 2606 OID 16898)
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- TOC entry 3782 (class 2606 OID 16900)
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- TOC entry 3673 (class 2606 OID 16902)
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- TOC entry 3898 (class 2606 OID 16904)
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- TOC entry 3886 (class 2606 OID 16906)
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- TOC entry 3669 (class 2606 OID 16908)
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- TOC entry 3634 (class 2606 OID 16910)
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- TOC entry 3664 (class 2606 OID 16912)
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- TOC entry 3852 (class 2606 OID 16914)
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- TOC entry 3646 (class 2606 OID 16916)
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- TOC entry 3787 (class 2606 OID 16918)
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- TOC entry 3803 (class 2606 OID 16920)
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- TOC entry 3757 (class 2606 OID 16922)
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- TOC entry 3614 (class 2606 OID 16924)
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- TOC entry 3630 (class 2606 OID 16926)
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- TOC entry 3620 (class 2606 OID 16928)
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- TOC entry 3624 (class 2606 OID 16930)
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- TOC entry 3627 (class 2606 OID 16932)
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- TOC entry 3667 (class 2606 OID 16934)
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- TOC entry 3895 (class 2606 OID 16936)
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- TOC entry 3684 (class 2606 OID 16938)
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- TOC entry 3671 (class 2606 OID 16940)
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- TOC entry 3744 (class 2606 OID 16942)
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- TOC entry 3774 (class 2606 OID 16944)
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- TOC entry 3805 (class 2606 OID 16946)
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- TOC entry 3688 (class 2606 OID 16948)
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- TOC entry 3878 (class 2606 OID 16950)
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- TOC entry 3828 (class 2606 OID 16952)
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- TOC entry 3837 (class 2606 OID 16954)
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- TOC entry 3832 (class 2606 OID 16956)
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- TOC entry 3617 (class 2606 OID 16958)
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- TOC entry 3820 (class 2606 OID 16960)
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- TOC entry 3842 (class 2606 OID 16962)
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- TOC entry 3823 (class 2606 OID 16964)
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- TOC entry 3855 (class 2606 OID 16966)
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- TOC entry 3870 (class 2606 OID 16968)
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- TOC entry 3884 (class 2606 OID 16970)
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- TOC entry 3880 (class 2606 OID 16972)
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- TOC entry 3708 (class 2606 OID 16974)
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- TOC entry 3867 (class 2606 OID 16976)
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- TOC entry 3862 (class 2606 OID 16978)
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- TOC entry 3751 (class 2606 OID 16980)
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- TOC entry 3732 (class 2606 OID 16982)
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3736 (class 2606 OID 16984)
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- TOC entry 3746 (class 2606 OID 16986)
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- TOC entry 3749 (class 2606 OID 16988)
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- TOC entry 3761 (class 2606 OID 16990)
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- TOC entry 3764 (class 2606 OID 16992)
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- TOC entry 3768 (class 2606 OID 16994)
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- TOC entry 3776 (class 2606 OID 16996)
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- TOC entry 3780 (class 2606 OID 16998)
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- TOC entry 3810 (class 2606 OID 17000)
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- TOC entry 3813 (class 2606 OID 17002)
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- TOC entry 3815 (class 2606 OID 17004)
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- TOC entry 3892 (class 2606 OID 17006)
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- TOC entry 3847 (class 2606 OID 17008)
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- TOC entry 3849 (class 2606 OID 17010)
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3858 (class 2606 OID 17012)
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- TOC entry 3889 (class 2606 OID 17014)
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- TOC entry 3900 (class 2606 OID 17016)
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- TOC entry 3904 (class 2606 OID 17018)
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- TOC entry 3691 (class 2606 OID 17020)
-- Name: databasechangeloglock databasechangeloglock_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT databasechangeloglock_pkey PRIMARY KEY (id);


--
-- TOC entry 3654 (class 2606 OID 17022)
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- TOC entry 3649 (class 2606 OID 17024)
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- TOC entry 3826 (class 2606 OID 17026)
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- TOC entry 3662 (class 2606 OID 17028)
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- TOC entry 3695 (class 2606 OID 17030)
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- TOC entry 3801 (class 2606 OID 17032)
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- TOC entry 3818 (class 2606 OID 17034)
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- TOC entry 3753 (class 2606 OID 17036)
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- TOC entry 3742 (class 2606 OID 17038)
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- TOC entry 3637 (class 2606 OID 17040)
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- TOC entry 3651 (class 2606 OID 17042)
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- TOC entry 3874 (class 2606 OID 17044)
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- TOC entry 3840 (class 2606 OID 17046)
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- TOC entry 3830 (class 2606 OID 17048)
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- TOC entry 3835 (class 2606 OID 17050)
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- TOC entry 3845 (class 2606 OID 17052)
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- TOC entry 3865 (class 2606 OID 17054)
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- TOC entry 3785 (class 2606 OID 17056)
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- TOC entry 3876 (class 2606 OID 17058)
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- TOC entry 3615 (class 1259 OID 17059)
-- Name: idx_admin_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_admin_event_time ON public.admin_event_entity USING btree (realm_id, admin_event_time);


--
-- TOC entry 3618 (class 1259 OID 17060)
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- TOC entry 3628 (class 1259 OID 17061)
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- TOC entry 3621 (class 1259 OID 17062)
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- TOC entry 3622 (class 1259 OID 17063)
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- TOC entry 3625 (class 1259 OID 17064)
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- TOC entry 3657 (class 1259 OID 17065)
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- TOC entry 3635 (class 1259 OID 17066)
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- TOC entry 3644 (class 1259 OID 17067)
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- TOC entry 3665 (class 1259 OID 17068)
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- TOC entry 3652 (class 1259 OID 17069)
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- TOC entry 3658 (class 1259 OID 17070)
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- TOC entry 3777 (class 1259 OID 17071)
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- TOC entry 3659 (class 1259 OID 17072)
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- TOC entry 3682 (class 1259 OID 17073)
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- TOC entry 3678 (class 1259 OID 17074)
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- TOC entry 3679 (class 1259 OID 17075)
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- TOC entry 3685 (class 1259 OID 17076)
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- TOC entry 3686 (class 1259 OID 17077)
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- TOC entry 3692 (class 1259 OID 17078)
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- TOC entry 3693 (class 1259 OID 17079)
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- TOC entry 3698 (class 1259 OID 17080)
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- TOC entry 3727 (class 1259 OID 17081)
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- TOC entry 3728 (class 1259 OID 17082)
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- TOC entry 3701 (class 1259 OID 17083)
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- TOC entry 3704 (class 1259 OID 17084)
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- TOC entry 3705 (class 1259 OID 17085)
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- TOC entry 3706 (class 1259 OID 17086)
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- TOC entry 3711 (class 1259 OID 17087)
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- TOC entry 3712 (class 1259 OID 17088)
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- TOC entry 3715 (class 1259 OID 17089)
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- TOC entry 3716 (class 1259 OID 17090)
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- TOC entry 3719 (class 1259 OID 17091)
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- TOC entry 3720 (class 1259 OID 17092)
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- TOC entry 3723 (class 1259 OID 17093)
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- TOC entry 3724 (class 1259 OID 17094)
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- TOC entry 3733 (class 1259 OID 17095)
-- Name: idx_group_att_by_name_value; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_att_by_name_value ON public.group_attribute USING btree (name, ((value)::character varying(250)));


--
-- TOC entry 3734 (class 1259 OID 17096)
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- TOC entry 3737 (class 1259 OID 17097)
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- TOC entry 3747 (class 1259 OID 17098)
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- TOC entry 3740 (class 1259 OID 17099)
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- TOC entry 3758 (class 1259 OID 17100)
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- TOC entry 3759 (class 1259 OID 17101)
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- TOC entry 3765 (class 1259 OID 17102)
-- Name: idx_offline_css_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_css_preload ON public.offline_client_session USING btree (client_id, offline_flag);


--
-- TOC entry 3769 (class 1259 OID 17103)
-- Name: idx_offline_uss_by_user; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_user ON public.offline_user_session USING btree (user_id, realm_id, offline_flag);


--
-- TOC entry 3770 (class 1259 OID 17104)
-- Name: idx_offline_uss_by_usersess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_by_usersess ON public.offline_user_session USING btree (realm_id, offline_flag, user_session_id);


--
-- TOC entry 3771 (class 1259 OID 17105)
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- TOC entry 3772 (class 1259 OID 17106)
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- TOC entry 3778 (class 1259 OID 17107)
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- TOC entry 3788 (class 1259 OID 17108)
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- TOC entry 3647 (class 1259 OID 17109)
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- TOC entry 3793 (class 1259 OID 17110)
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- TOC entry 3799 (class 1259 OID 17111)
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- TOC entry 3796 (class 1259 OID 17112)
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- TOC entry 3783 (class 1259 OID 17113)
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- TOC entry 3808 (class 1259 OID 17114)
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- TOC entry 3811 (class 1259 OID 17115)
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- TOC entry 3816 (class 1259 OID 17116)
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- TOC entry 3821 (class 1259 OID 17117)
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- TOC entry 3824 (class 1259 OID 17118)
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- TOC entry 3833 (class 1259 OID 17119)
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- TOC entry 3838 (class 1259 OID 17120)
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- TOC entry 3843 (class 1259 OID 17121)
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- TOC entry 3850 (class 1259 OID 17122)
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- TOC entry 3660 (class 1259 OID 17123)
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- TOC entry 3853 (class 1259 OID 17124)
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- TOC entry 3856 (class 1259 OID 17125)
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- TOC entry 3762 (class 1259 OID 17126)
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- TOC entry 3766 (class 1259 OID 17127)
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- TOC entry 3868 (class 1259 OID 17128)
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- TOC entry 3859 (class 1259 OID 17129)
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- TOC entry 3860 (class 1259 OID 17130)
-- Name: idx_user_attribute_name; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_attribute_name ON public.user_attribute USING btree (name, value);


--
-- TOC entry 3863 (class 1259 OID 17131)
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- TOC entry 3689 (class 1259 OID 17132)
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- TOC entry 3871 (class 1259 OID 17133)
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- TOC entry 3890 (class 1259 OID 17134)
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- TOC entry 3893 (class 1259 OID 17135)
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- TOC entry 3896 (class 1259 OID 17136)
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- TOC entry 3872 (class 1259 OID 17137)
-- Name: idx_user_service_account; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_user_service_account ON public.user_entity USING btree (realm_id, service_account_client_link);


--
-- TOC entry 3881 (class 1259 OID 17138)
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- TOC entry 3882 (class 1259 OID 17139)
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- TOC entry 3887 (class 1259 OID 17140)
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- TOC entry 3905 (class 1259 OID 17141)
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: keycloak
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- TOC entry 3918 (class 2606 OID 17142)
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3932 (class 2606 OID 17147)
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3912 (class 2606 OID 17152)
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3929 (class 2606 OID 17157)
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3914 (class 2606 OID 17162)
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3919 (class 2606 OID 17167)
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3978 (class 2606 OID 17172)
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- TOC entry 3921 (class 2606 OID 17177)
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3948 (class 2606 OID 17182)
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3974 (class 2606 OID 17187)
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3920 (class 2606 OID 17192)
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3945 (class 2606 OID 17197)
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3950 (class 2606 OID 17202)
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3967 (class 2606 OID 17207)
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3976 (class 2606 OID 17212)
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3936 (class 2606 OID 17217)
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- TOC entry 3946 (class 2606 OID 17222)
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3941 (class 2606 OID 17227)
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3925 (class 2606 OID 17232)
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- TOC entry 3908 (class 2606 OID 17237)
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- TOC entry 3909 (class 2606 OID 17242)
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3910 (class 2606 OID 17247)
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3911 (class 2606 OID 17252)
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3917 (class 2606 OID 17257)
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- TOC entry 3977 (class 2606 OID 17262)
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3915 (class 2606 OID 17267)
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- TOC entry 3916 (class 2606 OID 17272)
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- TOC entry 3922 (class 2606 OID 17277)
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- TOC entry 3938 (class 2606 OID 17282)
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- TOC entry 3913 (class 2606 OID 17287)
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3924 (class 2606 OID 17292)
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- TOC entry 3923 (class 2606 OID 17297)
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3942 (class 2606 OID 17302)
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3973 (class 2606 OID 17307)
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- TOC entry 3971 (class 2606 OID 17312)
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- TOC entry 3972 (class 2606 OID 17317)
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3906 (class 2606 OID 17322)
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3965 (class 2606 OID 17327)
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3955 (class 2606 OID 17332)
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3960 (class 2606 OID 17337)
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3956 (class 2606 OID 17342)
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3957 (class 2606 OID 17347)
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- TOC entry 3907 (class 2606 OID 17352)
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3966 (class 2606 OID 17357)
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- TOC entry 3958 (class 2606 OID 17362)
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3959 (class 2606 OID 17367)
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3953 (class 2606 OID 17372)
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3951 (class 2606 OID 17377)
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3952 (class 2606 OID 17382)
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3954 (class 2606 OID 17387)
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- TOC entry 3961 (class 2606 OID 17392)
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- TOC entry 3926 (class 2606 OID 17397)
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- TOC entry 3969 (class 2606 OID 17402)
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- TOC entry 3968 (class 2606 OID 17407)
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3930 (class 2606 OID 17412)
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- TOC entry 3931 (class 2606 OID 17417)
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- TOC entry 3943 (class 2606 OID 17422)
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3944 (class 2606 OID 17427)
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3934 (class 2606 OID 17432)
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3935 (class 2606 OID 17437)
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- TOC entry 3979 (class 2606 OID 17442)
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3964 (class 2606 OID 17447)
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3939 (class 2606 OID 17452)
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- TOC entry 3927 (class 2606 OID 17457)
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3940 (class 2606 OID 17462)
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- TOC entry 3928 (class 2606 OID 17467)
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3949 (class 2606 OID 17472)
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3962 (class 2606 OID 17477)
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- TOC entry 3963 (class 2606 OID 17482)
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- TOC entry 3947 (class 2606 OID 17487)
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- TOC entry 3970 (class 2606 OID 17492)
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- TOC entry 3975 (class 2606 OID 17497)
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- TOC entry 3937 (class 2606 OID 17502)
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- TOC entry 3933 (class 2606 OID 17507)
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: keycloak
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


-- Completed on 2024-04-04 11:59:05

--
-- PostgreSQL database dump complete
--

