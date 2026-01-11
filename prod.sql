-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.chat_members (
  chat_id uuid NOT NULL,
  profile_id uuid NOT NULL,
  joined_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT chat_members_pkey PRIMARY KEY (chat_id, profile_id),
  CONSTRAINT chat_members_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id),
  CONSTRAINT chat_members_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.chats (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text,
  config jsonb NOT NULL DEFAULT '{}'::jsonb,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT chats_pkey PRIMARY KEY (id)
);
CREATE TABLE public.cities (
  id smallint NOT NULL,
  name text NOT NULL,
  country_id smallint NOT NULL,
  latitude numeric,
  longitude numeric,
  CONSTRAINT cities_pkey PRIMARY KEY (id),
  CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id)
);
CREATE TABLE public.countries (
  id smallint NOT NULL,
  name text NOT NULL,
  code text NOT NULL UNIQUE,
  latitude numeric,
  longitude numeric,
  emoji text UNIQUE,
  translations jsonb,
  is_supported boolean NOT NULL DEFAULT false,
  CONSTRAINT countries_pkey PRIMARY KEY (id)
);
CREATE TABLE public.feedback_tickets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  related_module USER-DEFINED NOT NULL,
  recommendation text NOT NULL,
  created_by uuid,
  CONSTRAINT feedback_tickets_pkey PRIMARY KEY (id),
  CONSTRAINT feedback_tickets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id)
);
CREATE TABLE public.individual_profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  profile_id uuid NOT NULL UNIQUE,
  first_name text NOT NULL,
  last_name text NOT NULL,
  username text NOT NULL UNIQUE,
  email text NOT NULL UNIQUE,
  image_url text NOT NULL,
  gender text NOT NULL CHECK (gender = ANY (ARRAY['male'::text, 'female'::text, 'other'::text])),
  date_of_birth date NOT NULL,
  primary_sport_id uuid NOT NULL,
  sport_role USER-DEFINED NOT NULL,
  sport_goal text CHECK (sport_goal = ANY (ARRAY['official'::text, 'for_fun'::text])),
  sport_category text CHECK (sport_category = ANY (ARRAY['adult'::text, 'academy'::text])),
  academy_category text,
  sport_entity_id uuid,
  field_position text,
  strong_foot text CHECK (strong_foot = ANY (ARRAY['left'::text, 'right'::text, 'both'::text])),
  height_cm integer,
  player_status text,
  coach_role text,
  coach_certifications jsonb CHECK (jsonb_matches_schema('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true

            }'::json, coach_certifications)),
  referee_categories jsonb CHECK (jsonb_matches_schema('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, referee_categories)),
  referee_match_types jsonb CHECK (jsonb_matches_schema('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, referee_match_types)),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  updated_at timestamp with time zone NOT NULL DEFAULT now(),
  country_id smallint NOT NULL,
  city_id smallint,
  coach_supervisions jsonb,
  CONSTRAINT individual_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT individual_profiles_primary_sport_id_fkey FOREIGN KEY (primary_sport_id) REFERENCES public.sports(id),
  CONSTRAINT individual_profiles_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id),
  CONSTRAINT individual_profiles_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id),
  CONSTRAINT individual_profiles_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id),
  CONSTRAINT individual_profiles_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id)
);
CREATE TABLE public.medical_reports (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  team_id uuid NOT NULL,
  member_id uuid NOT NULL,
  severity USER-DEFINED NOT NULL,
  cause USER-DEFINED NOT NULL,
  injury_date timestamp with time zone NOT NULL,
  recovery_date timestamp with time zone,
  report text NOT NULL DEFAULT ''::text,
  CONSTRAINT medical_reports_pkey PRIMARY KEY (id),
  CONSTRAINT medical_reports_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id),
  CONSTRAINT medical_reports_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.team_members(id)
);
CREATE TABLE public.members_evaluations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  member_id uuid NOT NULL,
  text text,
  last_updated timestamp with time zone NOT NULL DEFAULT now(),
  profile_id uuid NOT NULL,
  team_id uuid NOT NULL,
  CONSTRAINT members_evaluations_pkey PRIMARY KEY (id),
  CONSTRAINT members_evaluations_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.team_members(id),
  CONSTRAINT members_evaluations_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id),
  CONSTRAINT members_evaluations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id)
);
CREATE TABLE public.message_attachments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  message_id uuid NOT NULL,
  name text NOT NULL,
  type USER-DEFINED NOT NULL,
  url text NOT NULL,
  mime_type text NOT NULL,
  size integer NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT message_attachments_pkey PRIMARY KEY (id),
  CONSTRAINT message_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id)
);
CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  chat_id uuid NOT NULL,
  created_by uuid NOT NULL DEFAULT profile_id(),
  content text NOT NULL DEFAULT ''::text,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id),
  CONSTRAINT messages_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id)
);
CREATE TABLE public.notify_me (
  id text NOT NULL DEFAULT uid(),
  data json NOT NULL,
  CONSTRAINT notify_me_pkey PRIMARY KEY (id)
);
CREATE TABLE public.opportunities (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title text NOT NULL,
  description text NOT NULL,
  category USER-DEFINED NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'published'::opportunity_status,
  deadline timestamp with time zone NOT NULL,
  created_by uuid NOT NULL,
  latitude real NOT NULL,
  longitude real NOT NULL,
  address text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  updated_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT opportunities_pkey PRIMARY KEY (id),
  CONSTRAINT opportunities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id)
);
CREATE TABLE public.opportunity_applications (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  opportunity_id uuid NOT NULL,
  applicant_id uuid NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::application_status,
  answers jsonb NOT NULL DEFAULT '{}'::jsonb,
  applied_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT opportunity_applications_pkey PRIMARY KEY (id),
  CONSTRAINT opportunity_applications_opportunity_id_fkey FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id),
  CONSTRAINT opportunity_applications_applicant_id_fkey FOREIGN KEY (applicant_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.opportunity_requirements (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  opportunity_id uuid NOT NULL,
  min_age smallint NOT NULL,
  max_age smallint NOT NULL,
  min_experience_years smallint NOT NULL,
  availability_date timestamp with time zone NOT NULL,
  languages jsonb NOT NULL CHECK (jsonb_matches_schema('{
            "type": "array",
            "items": {
                "type": "string",
                "enum": ["Dutch", "French", "English"]
            },
            "uniqueItems": true,
            "maxItems": 10
        }'::json, languages)),
  questions jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_matches_schema('{
            "type": "array", 
            "items": {
                "type": "string",
                "minLength": 1,
                "maxLength": 500
            },
            "maxItems": 20
        }'::json, questions)),
  CONSTRAINT opportunity_requirements_pkey PRIMARY KEY (id),
  CONSTRAINT opportunity_requirements_opportunity_id_fkey FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id)
);
CREATE TABLE public.profile_experiences (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  sport_role USER-DEFINED NOT NULL,
  sport_entity_id uuid NOT NULL,
  season_id uuid,
  category text,
  coach_role text,
  start_date date,
  end_date date,
  owner_id uuid NOT NULL DEFAULT profile_id(),
  CONSTRAINT profile_experiences_pkey PRIMARY KEY (id),
  CONSTRAINT profile_experiences_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id),
  CONSTRAINT profile_experiences_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.profiles(id),
  CONSTRAINT profile_experiences_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id)
);
CREATE TABLE public.profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id text NOT NULL DEFAULT uid(),
  user_type USER-DEFINED NOT NULL,
  display_name text NOT NULL DEFAULT ''''''::text,
  bio text,
  avatar_url text,
  preferred_language text NOT NULL DEFAULT 'en'::text,
  country_id smallint NOT NULL,
  city_id smallint,
  username text NOT NULL UNIQUE,
  opt_in_contact boolean DEFAULT false,
  fcm_token text,
  CONSTRAINT profiles_pkey PRIMARY KEY (id),
  CONSTRAINT profiles_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id),
  CONSTRAINT profiles_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id)
);
CREATE TABLE public.saved_opportunities (
  profile_id uuid NOT NULL DEFAULT profile_id(),
  opportunity_id uuid NOT NULL,
  CONSTRAINT saved_opportunities_pkey PRIMARY KEY (profile_id, opportunity_id),
  CONSTRAINT saved_opportunities_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id),
  CONSTRAINT saved_opportunities_opportunity_id_fkey FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id)
);
CREATE TABLE public.schema_migrations (
  version character varying NOT NULL,
  CONSTRAINT schema_migrations_pkey PRIMARY KEY (version)
);
CREATE TABLE public.seasons (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  start_date date NOT NULL,
  end_date date NOT NULL,
  name text NOT NULL UNIQUE,
  CONSTRAINT seasons_pkey PRIMARY KEY (id)
);
CREATE TABLE public.session_invitations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL,
  member_id uuid NOT NULL,
  team_id uuid NOT NULL,
  status USER-DEFINED NOT NULL DEFAULT 'pending'::session_invitation_status,
  updated_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  created_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT session_invitations_pkey PRIMARY KEY (id),
  CONSTRAINT session_invitations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.team_sessions(id),
  CONSTRAINT session_invitations_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.team_members(id),
  CONSTRAINT session_invitations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id)
);
CREATE TABLE public.session_report_attendance (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL,
  member_id uuid NOT NULL,
  status USER-DEFINED NOT NULL,
  CONSTRAINT session_report_attendance_pkey PRIMARY KEY (id),
  CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id),
  CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES public.team_members(id)
);
CREATE TABLE public.session_report_comments (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL UNIQUE,
  comment text NOT NULL,
  CONSTRAINT session_report_comments_pkey PRIMARY KEY (id),
  CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id)
);
CREATE TABLE public.session_report_composition (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL,
  substitutes ARRAY NOT NULL,
  positions jsonb NOT NULL,
  formation_name text NOT NULL DEFAULT ''::text,
  CONSTRAINT session_report_composition_pkey PRIMARY KEY (id),
  CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id)
);
CREATE TABLE public.session_report_game_stats (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL,
  events jsonb NOT NULL DEFAULT '[]'::jsonb,
  CONSTRAINT session_report_game_stats_pkey PRIMARY KEY (id),
  CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id)
);
CREATE TABLE public.session_report_ratings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  report_id uuid NOT NULL,
  member_id uuid NOT NULL,
  rating numeric NOT NULL CHECK (rating >= 0::numeric AND rating <= 10::numeric),
  CONSTRAINT session_report_ratings_pkey PRIMARY KEY (id),
  CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id),
  CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES public.team_members(id)
);
CREATE TABLE public.session_reports (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL,
  is_completed boolean NOT NULL DEFAULT false,
  CONSTRAINT session_reports_pkey PRIMARY KEY (id),
  CONSTRAINT fk_session FOREIGN KEY (session_id) REFERENCES public.team_sessions(id)
);
CREATE TABLE public.sport_entity_profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  profile_id uuid NOT NULL UNIQUE,
  entity_type USER-DEFINED NOT NULL,
  entity_name text NOT NULL,
  username text NOT NULL UNIQUE,
  image_url text NOT NULL,
  address jsonb NOT NULL CHECK (jsonb_matches_schema('{
                "type": "object",
                "properties": {
                    "street": {"type": "string"},
                    "city": {"type": "string", "minLength": 1},
                    "postal_code": {"type": "string"},
                    "country": {"type": "string", "minLength": 1},
                    "countryId": {"type": "integer"}
                },
                "required": ["city", "country", "countryId"],
                "additionalProperties": false
            }'::json, address)),
  primary_sport_id uuid NOT NULL,
  contact_first_name text NOT NULL,
  contact_last_name text NOT NULL,
  contact_email text NOT NULL,
  contact_phone text NOT NULL,
  contact_website text,
  club_categories jsonb CHECK (jsonb_matches_schema('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, club_categories)),
  federation_category text,
  country_id smallint NOT NULL,
  city_id smallint,
  youth_leagues jsonb,
  adult_men_divisions jsonb,
  adult_women_divisions jsonb,
  CONSTRAINT sport_entity_profiles_pkey PRIMARY KEY (id),
  CONSTRAINT sport_entity_profiles_primary_sport_id_fkey FOREIGN KEY (primary_sport_id) REFERENCES public.sports(id),
  CONSTRAINT sport_entity_profiles_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id),
  CONSTRAINT sport_entity_profiles_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id),
  CONSTRAINT sport_entity_profiles_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id)
);
CREATE TABLE public.sports (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  code text UNIQUE,
  category text,
  is_team_sport boolean DEFAULT true,
  min_players_per_team smallint,
  max_players_per_team smallint,
  is_supported boolean NOT NULL DEFAULT false,
  icon_url text,
  CONSTRAINT sports_pkey PRIMARY KEY (id)
);
CREATE TABLE public.support_tickets (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  subject text NOT NULL,
  message text NOT NULL,
  created_by uuid,
  CONSTRAINT support_tickets_pkey PRIMARY KEY (id),
  CONSTRAINT support_tickets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id)
);
CREATE TABLE public.team_members (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  team_id uuid NOT NULL,
  member_id uuid NOT NULL,
  is_admin boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT team_members_pkey PRIMARY KEY (id),
  CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id),
  CONSTRAINT team_members_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.profiles(id)
);
CREATE TABLE public.team_sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  team_id uuid NOT NULL,
  opponent_team_id uuid,
  turf USER-DEFINED,
  type USER-DEFINED NOT NULL,
  name text NOT NULL,
  appointment_datetime timestamp with time zone NOT NULL,
  start_time timestamp with time zone NOT NULL,
  end_time timestamp with time zone NOT NULL,
  description text NOT NULL DEFAULT ''::text,
  location jsonb NOT NULL,
  invitation_status USER-DEFINED,
  attendance_hidden boolean DEFAULT false,
  CONSTRAINT team_sessions_pkey PRIMARY KEY (id),
  CONSTRAINT team_sessions_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id),
  CONSTRAINT team_sessions_opponent_team_id_fkey FOREIGN KEY (opponent_team_id) REFERENCES public.teams(id)
);
CREATE TABLE public.teams (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name text NOT NULL,
  logo_url text NOT NULL,
  created_by uuid NOT NULL DEFAULT profile_id(),
  associated_club uuid,
  created_at timestamp with time zone NOT NULL DEFAULT (now() AT TIME ZONE 'utc'::text),
  CONSTRAINT teams_pkey PRIMARY KEY (id),
  CONSTRAINT teams_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id),
  CONSTRAINT teams_associated_club_fkey FOREIGN KEY (associated_club) REFERENCES public.sport_entity_profiles(id)
);
