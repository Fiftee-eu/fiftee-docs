--
-- PostgreSQL database dump
--

\restrict yacrkcAppHFahcHE3yXhJp52BUb3VXnzVQanGfxeRCvkKfOAqaHLp7qxdPXl4Ej

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7 (Ubuntu 17.7-3.pgdg24.04+1)

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

DROP POLICY IF EXISTS "enable update based on user_id" ON "public"."profiles";
DROP POLICY IF EXISTS "enable read access for members inside team" ON "public"."team_sessions";
DROP POLICY IF EXISTS "allows insertion if team admin" ON "public"."team_sessions";
DROP POLICY IF EXISTS "allow team member to create his own report" ON "public"."medical_reports";
DROP POLICY IF EXISTS "allow read when authenticated" ON "public"."profiles";
DROP POLICY IF EXISTS "allow read access for members in team" ON "public"."session_invitations";
DROP POLICY IF EXISTS "allow for team members to see" ON "public"."medical_reports";
DROP POLICY IF EXISTS "allow admins to create session invitations" ON "public"."session_invitations";
DROP POLICY IF EXISTS "allow Update Opportunity Join Table by Creator" ON "public"."opportunity_requirements";
DROP POLICY IF EXISTS "Users can view session reports for their team sessions" ON "public"."session_reports";
DROP POLICY IF EXISTS "Users can view messages in chats they belong to" ON "public"."messages";
DROP POLICY IF EXISTS "Users can view members of chats they belong to" ON "public"."chat_members";
DROP POLICY IF EXISTS "Users can view chats they are members of" ON "public"."chats";
DROP POLICY IF EXISTS "Users can view attachments for messages they can see" ON "public"."message_attachments";
DROP POLICY IF EXISTS "Users can update their own messages" ON "public"."messages";
DROP POLICY IF EXISTS "Users can update their own membership" ON "public"."chat_members";
DROP POLICY IF EXISTS "Users can update session reports for their team sessions" ON "public"."session_reports";
DROP POLICY IF EXISTS "Users can update chats they are members of" ON "public"."chats";
DROP POLICY IF EXISTS "Users can update attachments for their own messages" ON "public"."message_attachments";
DROP POLICY IF EXISTS "Users can remove themselves from chats" ON "public"."chat_members";
DROP POLICY IF EXISTS "Users can delete their own messages" ON "public"."messages";
DROP POLICY IF EXISTS "Users can delete chats they are members of" ON "public"."chats";
DROP POLICY IF EXISTS "Users can delete attachments for their own messages" ON "public"."message_attachments";
DROP POLICY IF EXISTS "Users can create session reports for their team sessions" ON "public"."session_reports";
DROP POLICY IF EXISTS "Users can create messages in chats they belong to" ON "public"."messages";
DROP POLICY IF EXISTS "Users can create chats" ON "public"."chats";
DROP POLICY IF EXISTS "Users can create attachments for their own messages" ON "public"."message_attachments";
DROP POLICY IF EXISTS "Users can add themselves to chats" ON "public"."chat_members";
DROP POLICY IF EXISTS "Users can add members to chats they belong to" ON "public"."chat_members";
DROP POLICY IF EXISTS "Enable users to view their own data only" ON "public"."saved_opportunities";
DROP POLICY IF EXISTS "Enable users to view their own data only" ON "public"."opportunity_applications";
DROP POLICY IF EXISTS "Enable update for users based on profile_id" ON "public"."opportunities";
DROP POLICY IF EXISTS "Enable read access for all users" ON "public"."sports";
DROP POLICY IF EXISTS "Enable read access for all users" ON "public"."sport_entity_profiles";
DROP POLICY IF EXISTS "Enable read access for all users" ON "public"."individual_profiles";
DROP POLICY IF EXISTS "Enable read access for all users" ON "public"."countries";
DROP POLICY IF EXISTS "Enable read access for all users" ON "public"."cities";
DROP POLICY IF EXISTS "Enable read access for all authenticated users" ON "public"."teams";
DROP POLICY IF EXISTS "Enable read access for all authenticated users" ON "public"."team_members";
DROP POLICY IF EXISTS "Enable read access for all authenticated users" ON "public"."opportunity_requirements";
DROP POLICY IF EXISTS "Enable read access for all authenticated users" ON "public"."opportunities";
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON "public"."teams";
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON "public"."saved_opportunities";
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON "public"."profiles";
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON "public"."opportunity_applications";
DROP POLICY IF EXISTS "Enable insert for authenticated users only" ON "public"."opportunities";
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON "public"."saved_opportunities";
DROP POLICY IF EXISTS "Enable delete for users based on user_id" ON "public"."profiles";
DROP POLICY IF EXISTS "Allow update by team admins only" ON "public"."team_members";
DROP POLICY IF EXISTS "Allow team update by admin members only" ON "public"."teams";
DROP POLICY IF EXISTS "Allow team members to update their own reports" ON "public"."medical_reports";
DROP POLICY IF EXISTS "Allow team members to delete their own reports" ON "public"."medical_reports";
DROP POLICY IF EXISTS "Allow team admin to have full access on reports" ON "public"."medical_reports";
DROP POLICY IF EXISTS "Allow insertions by team admins or team creators only" ON "public"."team_members";
DROP POLICY IF EXISTS "Allow delete by team admins only" ON "public"."teams";
DROP POLICY IF EXISTS "Allow authenticated users to read their own support tickets" ON "public"."support_tickets";
DROP POLICY IF EXISTS "Allow authenticated users to read their own support tickets" ON "public"."feedback_tickets";
DROP POLICY IF EXISTS "Allow authenticated users to create their own support tickets" ON "public"."support_tickets";
DROP POLICY IF EXISTS "Allow authenticated users to create their own support tickets" ON "public"."feedback_tickets";
ALTER TABLE IF EXISTS ONLY "public"."teams" DROP CONSTRAINT IF EXISTS "teams_created_by_fkey";
ALTER TABLE IF EXISTS ONLY "public"."teams" DROP CONSTRAINT IF EXISTS "teams_associated_club_fkey";
ALTER TABLE IF EXISTS ONLY "public"."team_sessions" DROP CONSTRAINT IF EXISTS "team_sessions_team_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."team_sessions" DROP CONSTRAINT IF EXISTS "team_sessions_opponent_team_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."team_members" DROP CONSTRAINT IF EXISTS "team_members_team_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."team_members" DROP CONSTRAINT IF EXISTS "team_members_member_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."support_tickets" DROP CONSTRAINT IF EXISTS "support_tickets_created_by_fkey";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_profile_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_primary_sport_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_country_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_city_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."session_invitations" DROP CONSTRAINT IF EXISTS "session_invitations_team_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."session_invitations" DROP CONSTRAINT IF EXISTS "session_invitations_session_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."session_invitations" DROP CONSTRAINT IF EXISTS "session_invitations_member_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."saved_opportunities" DROP CONSTRAINT IF EXISTS "saved_opportunities_profile_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."saved_opportunities" DROP CONSTRAINT IF EXISTS "saved_opportunities_opportunity_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_country_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_city_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunity_requirements" DROP CONSTRAINT IF EXISTS "opportunity_requirements_opportunity_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunity_applications" DROP CONSTRAINT IF EXISTS "opportunity_applications_opportunity_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunity_applications" DROP CONSTRAINT IF EXISTS "opportunity_applications_applicant_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunities" DROP CONSTRAINT IF EXISTS "opportunities_created_by_fkey";
ALTER TABLE IF EXISTS ONLY "public"."messages" DROP CONSTRAINT IF EXISTS "messages_created_by_fkey";
ALTER TABLE IF EXISTS ONLY "public"."messages" DROP CONSTRAINT IF EXISTS "messages_chat_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."message_attachments" DROP CONSTRAINT IF EXISTS "message_attachments_message_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."members_evaluations" DROP CONSTRAINT IF EXISTS "members_evaluations_team_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."members_evaluations" DROP CONSTRAINT IF EXISTS "members_evaluations_profile_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."members_evaluations" DROP CONSTRAINT IF EXISTS "members_evaluations_member_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."medical_reports" DROP CONSTRAINT IF EXISTS "medical_reports_team_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."medical_reports" DROP CONSTRAINT IF EXISTS "medical_reports_member_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_sport_entity_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_profile_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_primary_sport_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_country_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_city_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."session_report_ratings" DROP CONSTRAINT IF EXISTS "fk_session_report";
ALTER TABLE IF EXISTS ONLY "public"."session_report_game_stats" DROP CONSTRAINT IF EXISTS "fk_session_report";
ALTER TABLE IF EXISTS ONLY "public"."session_report_composition" DROP CONSTRAINT IF EXISTS "fk_session_report";
ALTER TABLE IF EXISTS ONLY "public"."session_report_comments" DROP CONSTRAINT IF EXISTS "fk_session_report";
ALTER TABLE IF EXISTS ONLY "public"."session_report_attendance" DROP CONSTRAINT IF EXISTS "fk_session_report";
ALTER TABLE IF EXISTS ONLY "public"."session_reports" DROP CONSTRAINT IF EXISTS "fk_session";
ALTER TABLE IF EXISTS ONLY "public"."session_report_ratings" DROP CONSTRAINT IF EXISTS "fk_member";
ALTER TABLE IF EXISTS ONLY "public"."session_report_attendance" DROP CONSTRAINT IF EXISTS "fk_member";
ALTER TABLE IF EXISTS ONLY "public"."feedback_tickets" DROP CONSTRAINT IF EXISTS "feedback_tickets_created_by_fkey";
ALTER TABLE IF EXISTS ONLY "public"."cities" DROP CONSTRAINT IF EXISTS "cities_country_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."chat_members" DROP CONSTRAINT IF EXISTS "chat_members_profile_id_fkey";
ALTER TABLE IF EXISTS ONLY "public"."chat_members" DROP CONSTRAINT IF EXISTS "chat_members_chat_id_fkey";
DROP TRIGGER IF EXISTS "update_evaluation_last_updated" ON "public"."members_evaluations";
DROP TRIGGER IF EXISTS "trigger_update_sport_entity_profile_generated" ON "public"."sport_entity_profiles";
DROP TRIGGER IF EXISTS "trigger_update_individual_profile_generated" ON "public"."individual_profiles";
DROP TRIGGER IF EXISTS "trigger_broadcast_new_message" ON "public"."messages";
DROP TRIGGER IF EXISTS "trg_validate_composition" ON "public"."session_report_composition";
DROP INDEX IF EXISTS "public"."idx_messages_created_by";
DROP INDEX IF EXISTS "public"."idx_messages_created_at";
DROP INDEX IF EXISTS "public"."idx_messages_chat_id";
DROP INDEX IF EXISTS "public"."idx_message_attachments_message_id";
DROP INDEX IF EXISTS "public"."idx_countries_translations";
DROP INDEX IF EXISTS "public"."idx_countries_location";
DROP INDEX IF EXISTS "public"."idx_cities_name";
DROP INDEX IF EXISTS "public"."idx_cities_location";
DROP INDEX IF EXISTS "public"."idx_cities_country_id";
DROP INDEX IF EXISTS "public"."idx_chat_members_profile_id";
DROP INDEX IF EXISTS "public"."idx_chat_members_chat_id";
ALTER TABLE IF EXISTS ONLY "public"."opportunity_applications" DROP CONSTRAINT IF EXISTS "uq_opportunity_applications_user_opportunity";
ALTER TABLE IF EXISTS ONLY "public"."session_report_comments" DROP CONSTRAINT IF EXISTS "unique_report_id";
ALTER TABLE IF EXISTS ONLY "public"."teams" DROP CONSTRAINT IF EXISTS "teams_pkey";
ALTER TABLE IF EXISTS ONLY "public"."team_sessions" DROP CONSTRAINT IF EXISTS "team_sessions_pkey";
ALTER TABLE IF EXISTS ONLY "public"."team_members" DROP CONSTRAINT IF EXISTS "team_members_pkey";
ALTER TABLE IF EXISTS ONLY "public"."support_tickets" DROP CONSTRAINT IF EXISTS "support_tickets_pkey";
ALTER TABLE IF EXISTS ONLY "public"."sports" DROP CONSTRAINT IF EXISTS "sports_pkey";
ALTER TABLE IF EXISTS ONLY "public"."sports" DROP CONSTRAINT IF EXISTS "sports_code_key";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_username_key";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_profile_id_key";
ALTER TABLE IF EXISTS ONLY "public"."sport_entity_profiles" DROP CONSTRAINT IF EXISTS "sport_entity_profiles_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_reports" DROP CONSTRAINT IF EXISTS "session_reports_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_report_ratings" DROP CONSTRAINT IF EXISTS "session_report_ratings_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_report_game_stats" DROP CONSTRAINT IF EXISTS "session_report_game_stats_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_report_composition" DROP CONSTRAINT IF EXISTS "session_report_composition_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_report_comments" DROP CONSTRAINT IF EXISTS "session_report_comments_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_report_attendance" DROP CONSTRAINT IF EXISTS "session_report_attendance_unique_report_member";
ALTER TABLE IF EXISTS ONLY "public"."session_report_attendance" DROP CONSTRAINT IF EXISTS "session_report_attendance_pkey";
ALTER TABLE IF EXISTS ONLY "public"."session_invitations" DROP CONSTRAINT IF EXISTS "session_invitations_pkey";
ALTER TABLE IF EXISTS ONLY "public"."saved_opportunities" DROP CONSTRAINT IF EXISTS "saved_opportunities_pkey";
ALTER TABLE IF EXISTS ONLY "public"."profiles" DROP CONSTRAINT IF EXISTS "profiles_pkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunity_requirements" DROP CONSTRAINT IF EXISTS "opportunity_requirements_pkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunity_applications" DROP CONSTRAINT IF EXISTS "opportunity_applications_pkey";
ALTER TABLE IF EXISTS ONLY "public"."opportunities" DROP CONSTRAINT IF EXISTS "opportunities_pkey";
ALTER TABLE IF EXISTS ONLY "public"."messages" DROP CONSTRAINT IF EXISTS "messages_pkey";
ALTER TABLE IF EXISTS ONLY "public"."message_attachments" DROP CONSTRAINT IF EXISTS "message_attachments_pkey";
ALTER TABLE IF EXISTS ONLY "public"."members_evaluations" DROP CONSTRAINT IF EXISTS "members_evaluations_pkey";
ALTER TABLE IF EXISTS ONLY "public"."medical_reports" DROP CONSTRAINT IF EXISTS "medical_reports_pkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_username_key";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_profile_id_key";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_pkey";
ALTER TABLE IF EXISTS ONLY "public"."individual_profiles" DROP CONSTRAINT IF EXISTS "individual_profiles_email_key";
ALTER TABLE IF EXISTS ONLY "public"."feedback_tickets" DROP CONSTRAINT IF EXISTS "feedback_tickets_pkey";
ALTER TABLE IF EXISTS ONLY "public"."countries" DROP CONSTRAINT IF EXISTS "countries_pkey";
ALTER TABLE IF EXISTS ONLY "public"."countries" DROP CONSTRAINT IF EXISTS "countries_emoji_key";
ALTER TABLE IF EXISTS ONLY "public"."countries" DROP CONSTRAINT IF EXISTS "countries_code_key";
ALTER TABLE IF EXISTS ONLY "public"."cities" DROP CONSTRAINT IF EXISTS "cities_pkey";
ALTER TABLE IF EXISTS ONLY "public"."chats" DROP CONSTRAINT IF EXISTS "chats_pkey";
ALTER TABLE IF EXISTS ONLY "public"."chat_members" DROP CONSTRAINT IF EXISTS "chat_members_pkey";
DROP TABLE IF EXISTS "public"."team_sessions";
DROP TABLE IF EXISTS "public"."support_tickets";
DROP TABLE IF EXISTS "public"."sports";
DROP TABLE IF EXISTS "public"."sport_entity_profiles";
DROP TABLE IF EXISTS "public"."session_reports";
DROP TABLE IF EXISTS "public"."session_report_ratings";
DROP TABLE IF EXISTS "public"."session_report_game_stats";
DROP TABLE IF EXISTS "public"."session_report_composition";
DROP TABLE IF EXISTS "public"."session_report_comments";
DROP TABLE IF EXISTS "public"."session_report_attendance";
DROP TABLE IF EXISTS "public"."session_invitations";
DROP TABLE IF EXISTS "public"."messages";
DROP TABLE IF EXISTS "public"."message_attachments";
DROP TABLE IF EXISTS "public"."members_evaluations";
DROP TABLE IF EXISTS "public"."medical_reports";
DROP TABLE IF EXISTS "public"."individual_profiles";
DROP TABLE IF EXISTS "public"."feedback_tickets";
DROP TABLE IF EXISTS "public"."countries";
DROP TABLE IF EXISTS "public"."cities";
DROP VIEW IF EXISTS "public"."chats_with_config";
DROP TABLE IF EXISTS "public"."teams";
DROP TABLE IF EXISTS "public"."team_members";
DROP TABLE IF EXISTS "public"."chats";
DROP TABLE IF EXISTS "public"."chat_members";
DROP FUNCTION IF EXISTS "public"."validate_composition"();
DROP FUNCTION IF EXISTS "public"."update_profile_generated_columns"();
DROP FUNCTION IF EXISTS "public"."update_last_updated"();
DROP FUNCTION IF EXISTS "public"."toggle_save_opportunity"("p_opportunity_id" "uuid");
DROP FUNCTION IF EXISTS "public"."is_user_team_admin"("p_team_id" "uuid", "p_profile_id" "uuid");
DROP FUNCTION IF EXISTS "public"."is_user_in_team"("p_team_id" "uuid", "p_profile_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_teams"("p_profile_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_team_statistics"("p_team_id" "uuid", "p_matches_limit" integer, "p_order_descending" boolean);
DROP FUNCTION IF EXISTS "public"."get_team_profile"("p_team_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_team_members"("p_team_id" "uuid", "q" "text");
DROP FUNCTION IF EXISTS "public"."get_sport_entity_profile"("p_profile_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_session_details_for_user"("p_session_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_saved_opportunities"();
DROP FUNCTION IF EXISTS "public"."get_reports"("p_session_type" "text", "p_team_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_report_by_id"("p_report_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_ratings_by_session_id"("p_session_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_profile_id_by_team_member"("team_member_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_profile_experiences"("p_sport_role" "public"."individual_role", "p_profile_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_profile_display_name"("p_profile_id" "uuid", "user_type_val" "public"."user_type");
DROP FUNCTION IF EXISTS "public"."get_profile_avatar_url"("p_profile_id" "uuid", "user_type_val" "public"."user_type");
DROP FUNCTION IF EXISTS "public"."get_opportunities_by_applicant"();
DROP VIEW IF EXISTS "public"."opportunity_view";
DROP TABLE IF EXISTS "public"."saved_opportunities";
DROP TABLE IF EXISTS "public"."profiles";
DROP TABLE IF EXISTS "public"."opportunity_requirements";
DROP TABLE IF EXISTS "public"."opportunity_applications";
DROP TABLE IF EXISTS "public"."opportunities";
DROP FUNCTION IF EXISTS "public"."uid"();
DROP FUNCTION IF EXISTS "public"."profile_id"();
DROP FUNCTION IF EXISTS "public"."get_medical_reports"("p_team_id" "uuid", "q" "text");
DROP FUNCTION IF EXISTS "public"."get_invited_members"("p_session_id" "uuid", "q" "text", "q_status" "public"."session_invitation_status");
DROP FUNCTION IF EXISTS "public"."get_individual_profile"("p_profile_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_game_events_by_session_id"("session_id" "uuid");
DROP FUNCTION IF EXISTS "public"."get_composition_by_session_id"("p_session_id" "uuid");
DROP FUNCTION IF EXISTS "public"."create_team"("p_team_id" "uuid", "p_team_name" "text", "p_logo_url" "text", "p_associated_club" "uuid", "p_members" "jsonb");
DROP FUNCTION IF EXISTS "public"."create_support_ticket"("p_subject" "text", "p_message" "text");
DROP FUNCTION IF EXISTS "public"."create_session"("p_team_id" "uuid", "p_session_type" "public"."session_type", "p_appointment_date" timestamp without time zone, "p_start_time" timestamp without time zone, "p_end_time" timestamp without time zone, "p_location" "jsonb", "p_description" "text", "p_invited_members" "uuid"[], "p_attendance_hidden" boolean, "p_session_name" "text", "p_opponent_team_id" "uuid", "p_turf" "public"."turf");
DROP FUNCTION IF EXISTS "public"."create_profile_after_onboarding"("p_user_type" "public"."user_type", "p_bio" "text", "p_country_id" smallint, "p_city_id" smallint, "p_preferred_language" "text", "p_first_name" "text", "p_last_name" "text", "p_username" "text", "p_email" "text", "p_image_url" "text", "p_gender" "text", "p_date_of_birth" "date", "p_primary_sport_id" "uuid", "p_sport_role" "public"."individual_role", "p_sport_goal" "text", "p_sport_category" "text", "p_academy_category" "text", "p_sport_entity_id" "uuid", "p_field_position" "text", "p_strong_foot" "text", "p_height_cm" integer, "p_player_status" "text", "p_coach_role" "text", "p_coach_certifications" "jsonb", "p_referee_categories" "jsonb", "p_referee_match_types" "jsonb", "p_entity_type" "public"."sport_entity_type", "p_entity_name" "text", "p_entity_username" "text", "p_entity_image_url" "text", "p_address" "jsonb", "p_entity_primary_sport_id" "uuid", "p_contact_first_name" "text", "p_contact_last_name" "text", "p_contact_email" "text", "p_contact_phone" "text", "p_contact_website" "text", "p_club_categories" "jsonb", "p_youth_leagues" "jsonb", "p_adult_men_divisions" "jsonb", "p_adult_women_divisions" "jsonb", "p_federation_category" "text");
DROP FUNCTION IF EXISTS "public"."create_opportunity"("p_title" "text", "p_description" "text", "p_category" "text", "p_deadline" timestamp with time zone, "p_latitude" real, "p_longitude" real, "p_address" "text", "p_min_age" smallint, "p_max_age" smallint, "p_languages" "jsonb", "p_availability_date" timestamp with time zone, "p_min_experience_years" smallint, "p_questions" "jsonb");
DROP FUNCTION IF EXISTS "public"."create_feedback_ticket"("p_related_module" "public"."app_module", "p_recommendation" "text");
DROP FUNCTION IF EXISTS "public"."broadcast_with_profile_id"("payload" "jsonb", "event_name" "text", "topic" "text", "is_private" boolean);
DROP FUNCTION IF EXISTS "public"."broadcast_new_message"();
DROP FUNCTION IF EXISTS "public"."accept_session_invitation"("p_session_id" "uuid", "p_status" "public"."session_invitation_status");
DROP TYPE IF EXISTS "public"."user_type";
DROP TYPE IF EXISTS "public"."turf";
DROP TYPE IF EXISTS "public"."sport_entity_type";
DROP TYPE IF EXISTS "public"."session_type";
DROP TYPE IF EXISTS "public"."session_invitation_status";
DROP TYPE IF EXISTS "public"."profile_creation_result";
DROP TYPE IF EXISTS "public"."opportunity_status";
DROP TYPE IF EXISTS "public"."opportunity_category";
DROP TYPE IF EXISTS "public"."medical_severity";
DROP TYPE IF EXISTS "public"."individual_role";
DROP TYPE IF EXISTS "public"."attendance_report_status";
DROP TYPE IF EXISTS "public"."attachment_type";
DROP TYPE IF EXISTS "public"."application_status";
DROP TYPE IF EXISTS "public"."app_module";
DROP SCHEMA IF EXISTS "public";
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "public";


--
-- Name: SCHEMA "public"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA "public" IS 'standard public schema';


--
-- Name: app_module; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."app_module" AS ENUM (
    'onboarding',
    'home',
    'opportunity',
    'my_teams',
    'my_zone',
    'profile',
    'messaging',
    'search_engine'
);


--
-- Name: TYPE "app_module"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE "public"."app_module" IS 'This Enum contains the app modules (features)';


--
-- Name: application_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."application_status" AS ENUM (
    'pending',
    'accepted',
    'rejected'
);


--
-- Name: TYPE "application_status"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE "public"."application_status" IS 'Status tracking for user applications to opportunities throughout the review process';


--
-- Name: attachment_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."attachment_type" AS ENUM (
    'image',
    'video',
    'document',
    'audio',
    'binary'
);


--
-- Name: attendance_report_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."attendance_report_status" AS ENUM (
    'justified_absence',
    'unjustified_absence',
    'justified_lateness',
    'unjustified_lateness'
);


--
-- Name: individual_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."individual_role" AS ENUM (
    'player',
    'coach',
    'referee',
    'fan'
);


--
-- Name: medical_severity; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."medical_severity" AS ENUM (
    'minor',
    'moderate',
    'severe'
);


--
-- Name: opportunity_category; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."opportunity_category" AS ENUM (
    'meet_and_play',
    'recruitments',
    'tests',
    'internships',
    'tournaments',
    'volunteering',
    'student_opportunities',
    'professional_opportunities'
);


--
-- Name: TYPE "opportunity_category"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE "public"."opportunity_category" IS 'Categories defining the type and purpose of opportunities available on the platform';


--
-- Name: opportunity_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."opportunity_status" AS ENUM (
    'published',
    'closed',
    'expired',
    'cancelled'
);


--
-- Name: TYPE "opportunity_status"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE "public"."opportunity_status" IS 'Current lifecycle status of an opportunity from creation to completion';


--
-- Name: profile_creation_result; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."profile_creation_result" AS (
	"success" boolean,
	"profile_id" "uuid",
	"error_code" "text",
	"error_message" "text"
);


--
-- Name: TYPE "profile_creation_result"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE "public"."profile_creation_result" IS 'Return type for profile creation functions with success status and error details';


--
-- Name: session_invitation_status; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."session_invitation_status" AS ENUM (
    'pending',
    'accepted',
    'rejected'
);


--
-- Name: session_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."session_type" AS ENUM (
    'training',
    'game',
    'other'
);


--
-- Name: sport_entity_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."sport_entity_type" AS ENUM (
    'club',
    'federation'
);


--
-- Name: turf; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."turf" AS ENUM (
    'home',
    'away',
    'neutral'
);


--
-- Name: user_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE "public"."user_type" AS ENUM (
    'private_profile',
    'sport_entity',
    'media',
    'company'
);


--
-- Name: TYPE "user_type"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TYPE "public"."user_type" IS 'User Types Enum';


--
-- Name: accept_session_invitation("uuid", "public"."session_invitation_status"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."accept_session_invitation"("p_session_id" "uuid", "p_status" "public"."session_invitation_status") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
v_team_id uuid;
v_member_id uuid;
BEGIN

    -- Get the team_id from the session
    SELECT team_id INTO v_team_id
    FROM team_sessions
    WHERE id = p_session_id;
    
    -- Check if team_id was found
    IF v_team_id IS NULL THEN
        RAISE EXCEPTION 'Session not found or has no associated team';
    END IF;

    -- select member id by using profile_id()
    SELECT id INTO v_member_id
    FROM team_members
    WHERE member_id = (SELECT profile_id())
      AND team_id = v_team_id;
    
    -- Check if member_id was found
    IF v_member_id IS NULL THEN
        RAISE EXCEPTION 'User is not a member of this team';
    END IF;

    -- Update the session invitation status to accepted
    UPDATE session_invitations
    SET status = p_status,
        updated_at = NOW()
    WHERE session_id = p_session_id
      AND member_id = v_member_id;
    
    -- Check if the invitation was actually updated
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No pending invitation found for this session and user';
    END IF;

END;
$$;


--
-- Name: broadcast_new_message(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."broadcast_new_message"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$DECLARE
  message_payload JSONB;
  attachments_json JSONB;
  attachment_count INTEGER;
BEGIN
  -- Log function start
  RAISE LOG 'new_message trigger started for message_id: %', NEW.id;
  RAISE LOG 'Message details - chat_id: %, created_by: %, content length: %', 
    NEW.chat_id, NEW.created_by, LENGTH(NEW.content);

  -- Aggregate attachments for the message
  SELECT COALESCE(
    jsonb_agg(
      jsonb_build_object(
        'name', ma.name,
        'type', ma.type,
        'url', ma.url,
        'mime_type', ma.mime_type,
        'size', ma.size
      )
    ) FILTER (WHERE ma.id IS NOT NULL),
    '[]'::jsonb
  ) INTO attachments_json
  FROM message_attachments ma
  WHERE ma.message_id = NEW.id;

  -- Log attachments info
  attachment_count := jsonb_array_length(attachments_json);
  RAISE LOG 'Found % attachments for message_id: %', attachment_count, NEW.id;
  RAISE LOG 'Attachments JSON: %', attachments_json;

  -- Build the message payload matching the query structure
  message_payload := jsonb_build_object(
    'id', NEW.id,
    'chat_id', NEW.chat_id,
    'created_by', NEW.created_by,
    'content', NEW.content,
    'created_at', NEW.created_at,
    'attachments', attachments_json
  );

  -- Log the complete payload
  RAISE LOG 'Message payload built: %', message_payload;

  -- Log before realtime.send
  RAISE LOG 'Attempting to send realtime message to topic: chat:%', NEW.chat_id;

  -- Broadcast the message using realtime.send
  PERFORM realtime.send(
    message_payload,           -- JSONB Payload
    'new_message',             -- Event name
    'chat:' || NEW.chat_id::text, -- Topic (chat-specific channel)
    TRUE                      -- Private flag
  );

  -- Log success
  RAISE LOG 'Successfully sent realtime message for message_id: %', NEW.id;

  RETURN NEW;
EXCEPTION
  WHEN OTHERS THEN
    -- Log any errors
    RAISE LOG 'ERROR in new_message trigger for message_id: % - SQLSTATE: %, SQLERRM: %', 
      NEW.id, SQLSTATE, SQLERRM;
    -- Re-raise the exception
    RAISE;
END;$$;


--
-- Name: FUNCTION "broadcast_new_message"(); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION "public"."broadcast_new_message"() IS 'Broadcasts new messages to realtime subscribers when a message is inserted';


--
-- Name: broadcast_with_profile_id("jsonb", "text", "text", boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."broadcast_with_profile_id"("payload" "jsonb", "event_name" "text", "topic" "text", "is_private" boolean DEFAULT true) RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  payload := payload || jsonb_build_object('profile_id', profile_id());

  PERFORM realtime.send(
    payload,
    event_name,
    topic,
    is_private
  );
END;
$$;


--
-- Name: create_feedback_ticket("public"."app_module", "text"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."create_feedback_ticket"("p_related_module" "public"."app_module", "p_recommendation" "text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_id uuid;
BEGIN
  INSERT INTO public.feedback_tickets (
    created_by,
    related_module,
    recommendation
  )
  VALUES (
    (SELECT profile_id()),   -- authenticated user
    p_related_module,
    p_recommendation
  )
  RETURNING id INTO v_id;

  RETURN v_id; 
END;
$$;


--
-- Name: create_opportunity("text", "text", "text", timestamp with time zone, real, real, "text", smallint, smallint, "jsonb", timestamp with time zone, smallint, "jsonb"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."create_opportunity"("p_title" "text", "p_description" "text", "p_category" "text", "p_deadline" timestamp with time zone, "p_latitude" real, "p_longitude" real, "p_address" "text", "p_min_age" smallint DEFAULT NULL::smallint, "p_max_age" smallint DEFAULT NULL::smallint, "p_languages" "jsonb" DEFAULT '[]'::"jsonb", "p_availability_date" timestamp with time zone DEFAULT NULL::timestamp with time zone, "p_min_experience_years" smallint DEFAULT NULL::smallint, "p_questions" "jsonb" DEFAULT '[]'::"jsonb") RETURNS "uuid"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
    v_opportunity_id UUID;
    v_profile_id UUID;
    v_user_id TEXT;
    v_requirements_id UUID;
BEGIN
    -- Get the current user's ID from auth context
    v_user_id := public.uid();
    
    -- Validate that user is authenticated
    IF v_user_id IS NULL THEN
        RAISE EXCEPTION 'User must be authenticated to create opportunities';
    END IF;
    
    -- Get the profile ID for the current user
    SELECT id INTO v_profile_id
    FROM public.profiles
    WHERE user_id = v_user_id;
    
    -- Validate that profile exists
    IF v_profile_id IS NULL THEN
        RAISE EXCEPTION 'Profile not found for user: %', v_user_id;
    END IF;
    
    -- Validate required fields
    IF p_title IS NULL OR trim(p_title) = '' THEN
        RAISE EXCEPTION 'Title is required';
    END IF;
    
    IF p_description IS NULL OR trim(p_description) = '' THEN
        RAISE EXCEPTION 'Description is required';
    END IF;
    
    IF p_category IS NULL THEN
        RAISE EXCEPTION 'Category is required';
    END IF;
    
    IF p_deadline IS NULL THEN
        RAISE EXCEPTION 'Deadline is required';
    END IF;
    
    IF p_deadline <= CURRENT_TIMESTAMP THEN
        RAISE EXCEPTION 'Deadline must be in the future';
    END IF;
    
    IF p_latitude IS NULL OR p_longitude IS NULL THEN
        RAISE EXCEPTION 'Location coordinates are required';
    END IF;
    
    IF p_address IS NULL OR trim(p_address) = '' THEN
        RAISE EXCEPTION 'Address is required';
    END IF;
    
    -- Validate languages JSON structure if provided
    IF p_languages IS NOT NULL AND NOT jsonb_matches_schema('{
        "type": "array",
        "items": {
            "type": "string",
            "enum": ["Dutch", "French", "English"]
        },
        "uniqueItems": true,
        "maxItems": 10
    }'::json, p_languages) THEN
        RAISE EXCEPTION 'Invalid languages format. Must be array of supported languages';
    END IF;
    
    -- Validate questions JSON structure if provided
    IF p_questions IS NOT NULL AND NOT jsonb_matches_schema('{
        "type": "array", 
        "items": {
            "type": "string",
            "minLength": 1,
            "maxLength": 500
        },
        "maxItems": 20
    }'::json, p_questions) THEN
        RAISE EXCEPTION 'Invalid questions format. Must be array of strings (max 20 items, 500 chars each)';
    END IF;
    
    -- Validate age ranges if provided
    IF p_min_age IS NOT NULL AND (p_min_age < 0 OR p_min_age > 100) THEN
        RAISE EXCEPTION 'Minimum age must be between 0 and 100';
    END IF;
    
    IF p_max_age IS NOT NULL AND (p_max_age < 0 OR p_max_age > 100) THEN
        RAISE EXCEPTION 'Maximum age must be between 0 and 100';
    END IF;
    
    IF p_min_age IS NOT NULL AND p_max_age IS NOT NULL AND p_min_age > p_max_age THEN
        RAISE EXCEPTION 'Minimum age cannot be greater than maximum age';
    END IF;
    
    -- Validate experience years if provided
    IF p_min_experience_years IS NOT NULL AND (p_min_experience_years < 0 OR p_min_experience_years > 50) THEN
        RAISE EXCEPTION 'Minimum experience years must be between 0 and 50';
    END IF;
    
    -- Start transaction
    BEGIN
        -- Insert the opportunity
        INSERT INTO public.opportunities (
            title,
            description,
            category,
            deadline,
            created_by,
            latitude,
            longitude,
            address,
            status
        ) VALUES (
            p_title,
            p_description,
            p_category::opportunity_category,
            p_deadline,
            v_profile_id,
            p_latitude,
            p_longitude,
            p_address,
            'published'::opportunity_status
        ) RETURNING id INTO v_opportunity_id;
        
        -- Insert requirements if any are provided
        IF p_min_age IS NOT NULL OR 
           p_max_age IS NOT NULL OR 
           (p_languages IS NOT NULL AND jsonb_array_length(p_languages) > 0) OR
           p_availability_date IS NOT NULL OR 
           p_min_experience_years IS NOT NULL OR 
           (p_questions IS NOT NULL AND jsonb_array_length(p_questions) > 0) THEN
            
            INSERT INTO public.opportunity_requirements (
                opportunity_id,
                min_age,
                max_age,
                min_experience_years,
                availability_date,
                languages,
                questions
            ) VALUES (
                v_opportunity_id,
                COALESCE(p_min_age, 0),
                COALESCE(p_max_age, 100),
                COALESCE(p_min_experience_years, 0),
                COALESCE(p_availability_date, p_deadline),
                COALESCE(p_languages, '[]'::jsonb),
                COALESCE(p_questions, '[]'::jsonb)
            ) RETURNING id INTO v_requirements_id;
        END IF;
        
        -- Return the opportunity ID
        RETURN v_opportunity_id;
        
    EXCEPTION WHEN OTHERS THEN
        -- Rollback and re-raise the exception
        RAISE;
    END;
END;
$$;


--
-- Name: create_profile_after_onboarding("public"."user_type", "text", smallint, smallint, "text", "text", "text", "text", "text", "text", "text", "date", "uuid", "public"."individual_role", "text", "text", "text", "uuid", "text", "text", integer, "text", "text", "jsonb", "jsonb", "jsonb", "public"."sport_entity_type", "text", "text", "text", "jsonb", "uuid", "text", "text", "text", "text", "text", "jsonb", "jsonb", "jsonb", "jsonb", "text"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."create_profile_after_onboarding"("p_user_type" "public"."user_type", "p_bio" "text" DEFAULT NULL::"text", "p_country_id" smallint DEFAULT NULL::smallint, "p_city_id" smallint DEFAULT NULL::smallint, "p_preferred_language" "text" DEFAULT 'en'::"text", "p_first_name" "text" DEFAULT NULL::"text", "p_last_name" "text" DEFAULT NULL::"text", "p_username" "text" DEFAULT NULL::"text", "p_email" "text" DEFAULT NULL::"text", "p_image_url" "text" DEFAULT NULL::"text", "p_gender" "text" DEFAULT NULL::"text", "p_date_of_birth" "date" DEFAULT NULL::"date", "p_primary_sport_id" "uuid" DEFAULT NULL::"uuid", "p_sport_role" "public"."individual_role" DEFAULT NULL::"public"."individual_role", "p_sport_goal" "text" DEFAULT NULL::"text", "p_sport_category" "text" DEFAULT NULL::"text", "p_academy_category" "text" DEFAULT NULL::"text", "p_sport_entity_id" "uuid" DEFAULT NULL::"uuid", "p_field_position" "text" DEFAULT NULL::"text", "p_strong_foot" "text" DEFAULT NULL::"text", "p_height_cm" integer DEFAULT NULL::integer, "p_player_status" "text" DEFAULT NULL::"text", "p_coach_role" "text" DEFAULT NULL::"text", "p_coach_certifications" "jsonb" DEFAULT NULL::"jsonb", "p_referee_categories" "jsonb" DEFAULT NULL::"jsonb", "p_referee_match_types" "jsonb" DEFAULT NULL::"jsonb", "p_entity_type" "public"."sport_entity_type" DEFAULT NULL::"public"."sport_entity_type", "p_entity_name" "text" DEFAULT NULL::"text", "p_entity_username" "text" DEFAULT NULL::"text", "p_entity_image_url" "text" DEFAULT NULL::"text", "p_address" "jsonb" DEFAULT NULL::"jsonb", "p_entity_primary_sport_id" "uuid" DEFAULT NULL::"uuid", "p_contact_first_name" "text" DEFAULT NULL::"text", "p_contact_last_name" "text" DEFAULT NULL::"text", "p_contact_email" "text" DEFAULT NULL::"text", "p_contact_phone" "text" DEFAULT NULL::"text", "p_contact_website" "text" DEFAULT NULL::"text", "p_club_categories" "jsonb" DEFAULT NULL::"jsonb", "p_youth_leagues" "jsonb" DEFAULT NULL::"jsonb", "p_adult_men_divisions" "jsonb" DEFAULT NULL::"jsonb", "p_adult_women_divisions" "jsonb" DEFAULT NULL::"jsonb", "p_federation_category" "text" DEFAULT NULL::"text") RETURNS "public"."profile_creation_result"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $_$
DECLARE
    v_profile_id UUID;
    v_individual_profile_id UUID;
    v_entity_profile_id UUID;
    v_result profile_creation_result;
    v_existing_profile_count INTEGER;
    p_user_id TEXT;
BEGIN
    p_user_id := public.uid();

    -- Initialize result
    v_result.success := FALSE;
    v_result.profile_id := NULL;
    v_result.error_code := NULL;
    v_result.error_message := NULL;
    
    -- Input validation
    IF p_user_id IS NULL THEN
        v_result.error_code := 'UNAUTHORISED';
        v_result.error_message := 'User ID cannot be null';
        RETURN v_result;
    END IF;
    
    IF p_user_type IS NULL THEN
        v_result.error_code := 'INVALID_USER_TYPE';
        v_result.error_message := 'User type cannot be null';
        RETURN v_result;
    END IF;
        
    -- Start transaction
    BEGIN
        -- Validate user type specific required fields
        IF p_user_type = 'private_profile' THEN
            IF p_first_name IS NULL OR p_last_name IS NULL OR p_username IS NULL OR p_email IS NULL THEN
                v_result.error_code := 'MISSING_INDIVIDUAL_FIELDS';
                v_result.error_message := 'Required fields missing for individual profile: first_name, last_name, username, email';
                RETURN v_result;
            END IF;
            
            -- Validate username format (alphanumeric and underscore only, 3-30 chars)
            IF NOT p_username ~ '^[a-zA-Z0-9_.@]{3,30}$' THEN
                v_result.error_code := 'INVALID_USERNAME';
                v_result.error_message := 'Username must be 3-30 characters, alphanumeric, underscore and dots only';
                RETURN v_result;
            END IF;
            
            -- Validate email format
            IF NOT p_email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
                v_result.error_code := 'INVALID_EMAIL';
                v_result.error_message := 'Invalid email format';
                RETURN v_result;
            END IF;
            
        ELSIF p_user_type = 'sport_entity' THEN
            IF p_entity_type IS NULL OR p_entity_name IS NULL OR p_entity_username IS NULL OR 
               p_address IS NULL OR p_contact_first_name IS NULL OR p_contact_last_name IS NULL OR 
               p_contact_email IS NULL THEN
                v_result.error_code := 'MISSING_ENTITY_FIELDS';
                v_result.error_message := 'Required fields missing for sport entity profile';
                RETURN v_result;
            END IF;
            
            -- Validate entity username format
            IF NOT p_entity_username ~ '^[a-zA-Z0-9_.@]{3,30}$' THEN
                v_result.error_code := 'INVALID_ENTITY_USERNAME';
                v_result.error_message := 'Entity username must be 3-50 characters, alphanumeric and underscore only';
                RETURN v_result;
            END IF;
            
            -- Validate contact email format
            IF NOT p_contact_email ~ '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' THEN
                v_result.error_code := 'INVALID_CONTACT_EMAIL';
                v_result.error_message := 'Invalid contact email format';
                RETURN v_result;
            END IF;
        END IF;
        
        -- Create main profile record
        INSERT INTO public.profiles (
            user_id,
            user_type,
            bio,
            country_id,
            city_id,
            preferred_language
        ) VALUES (
            p_user_id,
            p_user_type,
            p_bio,
            p_country_id,
            p_city_id,
            p_preferred_language
        ) RETURNING public.profiles.id INTO v_profile_id;
        
        -- Create type-specific profile
        IF p_user_type = 'private_profile' THEN
            INSERT INTO public.individual_profiles (
                profile_id,
                first_name,
                last_name,
                username,
                email,
                image_url,
                gender,
                date_of_birth,
                country_id,
                city_id,
                primary_sport_id,
                sport_role,
                sport_goal,
                sport_category,
                academy_category,
                sport_entity_id,
                field_position,
                strong_foot,
                height_cm,
                player_status,
                coach_role,
                coach_certifications,
                referee_categories,
                referee_match_types
            ) VALUES (
                v_profile_id,
                p_first_name,
                p_last_name,
                p_username,
                p_email,
                p_image_url,
                p_gender,
                p_date_of_birth,
                p_country_id,
                p_city_id,
                p_primary_sport_id,
                p_sport_role,
                p_sport_goal,
                p_sport_category,
                p_academy_category,
                p_sport_entity_id,
                p_field_position,
                p_strong_foot,
                p_height_cm,
                p_player_status,
                p_coach_role,
                p_coach_certifications,
                p_referee_categories,
                p_referee_match_types
            ) RETURNING public.individual_profiles.id INTO v_individual_profile_id;
            
        ELSIF p_user_type = 'sport_entity' THEN
            INSERT INTO public.sport_entity_profiles (
                country_id,
                city_id,
                profile_id,
                entity_type,
                entity_name,
                username,
                image_url,
                address,
                primary_sport_id,
                contact_first_name,
                contact_last_name,
                contact_email,
                contact_phone,
                contact_website,
                club_categories,
                youth_leagues,
                adult_men_divisions,
                adult_women_divisions,
                federation_category
            ) VALUES (
                p_country_id,
                p_city_id,
                v_profile_id,
                p_entity_type,
                p_entity_name,
                p_entity_username,
                p_entity_image_url,
                p_address,
                p_entity_primary_sport_id,
                p_contact_first_name,
                p_contact_last_name,
                p_contact_email,
                p_contact_phone,
                p_contact_website,
                p_club_categories,
                p_youth_leagues,
                p_adult_men_divisions,
                p_adult_women_divisions,
                p_federation_category
            ) RETURNING public.sport_entity_profiles.id INTO v_entity_profile_id;
        END IF;
        
        -- Success
        v_result.success := TRUE;
        v_result.profile_id := v_profile_id;
        v_result.error_code := NULL;
        v_result.error_message := NULL;
        
        -- Log successful profile creation
        RAISE NOTICE 'Profile created successfully. Profile ID: %, User ID: %, Type: %', 
            v_profile_id, p_user_id, p_user_type;
        
    EXCEPTION
        WHEN unique_violation THEN
            GET STACKED DIAGNOSTICS v_result.error_message = MESSAGE_TEXT;
            
            -- Handle specific unique constraint violations
            IF v_result.error_message LIKE '%username%' THEN
                v_result.error_code := 'USERNAME_EXISTS';
                v_result.error_message := 'Username already exists';
            ELSIF v_result.error_message LIKE '%email%' THEN
                v_result.error_code := 'EMAIL_EXISTS';
                v_result.error_message := 'Email already exists';
            ELSE
                v_result.error_code := 'UNIQUE_VIOLATION';
                v_result.error_message := 'Duplicate value detected';
            END IF;
            
            RAISE WARNING 'Profile creation failed - unique violation: %', v_result.error_message;
            
        WHEN check_violation THEN
            GET STACKED DIAGNOSTICS v_result.error_message = MESSAGE_TEXT;
            v_result.error_code := 'VALIDATION_ERROR';
            v_result.error_message := 'Data validation failed: ' || v_result.error_message;
            
            RAISE WARNING 'Profile creation failed - validation error: %', v_result.error_message;
            
        WHEN foreign_key_violation THEN
            GET STACKED DIAGNOSTICS v_result.error_message = MESSAGE_TEXT;
            v_result.error_code := 'FOREIGN_KEY_ERROR';
            v_result.error_message := 'Invalid reference to related data: ' || v_result.error_message;
            
            RAISE WARNING 'Profile creation failed - foreign key error: %', v_result.error_message;
            
        WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS v_result.error_message = MESSAGE_TEXT;
            v_result.error_code := 'UNKNOWN_ERROR';
            v_result.error_message := 'Unexpected error: ' || v_result.error_message;

            RAISE WARNING 'Profile creation failed - unknown error: %', v_result.error_message;
    END;
    
    RETURN v_result;
END;
$_$;


--
-- Name: create_session("uuid", "public"."session_type", timestamp without time zone, timestamp without time zone, timestamp without time zone, "jsonb", "text", "uuid"[], boolean, "text", "uuid", "public"."turf"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."create_session"("p_team_id" "uuid", "p_session_type" "public"."session_type", "p_appointment_date" timestamp without time zone, "p_start_time" timestamp without time zone, "p_end_time" timestamp without time zone, "p_location" "jsonb", "p_description" "text", "p_invited_members" "uuid"[], "p_attendance_hidden" boolean DEFAULT false, "p_session_name" "text" DEFAULT NULL::"text", "p_opponent_team_id" "uuid" DEFAULT NULL::"uuid", "p_turf" "public"."turf" DEFAULT NULL::"public"."turf") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_team_session_id UUID;
BEGIN 

  CASE
    WHEN (p_session_type = 'training') THEN 
      INSERT INTO team_sessions (
        team_id,
        type,
        name,
        appointment_datetime,
        start_time,
        end_time,
        description,
        location,
        attendance_hidden
      )
      VALUES (
        p_team_id,
        p_session_type,
        'Training Session',
        p_appointment_date,
        p_start_time,
        p_end_time,
        p_description,
        p_location,
        p_attendance_hidden
      ) RETURNING id INTO v_team_session_id;
    WHEN (p_session_type = 'game') THEN 
      INSERT INTO team_sessions (
        team_id,
        opponent_team_id,
        turf,
        type,
        name,
        appointment_datetime,
        start_time,
        end_time,
        description,
        location,
        invitation_status,
        attendance_hidden
      )
      VALUES (
        p_team_id,
        p_opponent_team_id,
        p_turf,
        p_session_type,
        'Official Game',
        p_appointment_date,
        p_start_time,
        p_end_time,
        p_description,
        p_location,
        'pending',
        p_attendance_hidden
      ) RETURNING id INTO v_team_session_id;
    WHEN (p_session_type = 'other') THEN 
      INSERT INTO team_sessions (
        team_id,
        type,
        name,
        appointment_datetime,
        start_time,
        end_time,
        description,
        location,
        attendance_hidden
      )
      VALUES (
        p_team_id,
        p_session_type,
        p_session_name,
        p_appointment_date,
        p_start_time,
        p_end_time,
        p_description,
        p_location,
        p_attendance_hidden
      ) RETURNING id INTO v_team_session_id;
    ELSE
      RAISE EXCEPTION 'Invalid session type';
  END CASE;

  INSERT INTO session_invitations (
    session_id,
    member_id,
    team_id,
    status
  )
  SELECT 
    v_team_session_id,
    UNNEST(p_invited_members),
    p_team_id,
    'pending'::session_invitation_status;
  
  INSERT INTO session_reports (
    session_id,
    is_completed
  )
  VALUES (
    v_team_session_id,
    false
  );

END
$$;


--
-- Name: create_support_ticket("text", "text"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."create_support_ticket"("p_subject" "text", "p_message" "text") RETURNS "uuid"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_id uuid;
BEGIN
  INSERT INTO public.support_tickets (
    created_by,
    subject,
    message
  )
  VALUES (
    (SELECT profile_id()),   -- authenticated user
    p_subject,
    p_message
  )
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;


--
-- Name: create_team("uuid", "text", "text", "uuid", "jsonb"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."create_team"("p_team_id" "uuid", "p_team_name" "text", "p_logo_url" "text", "p_associated_club" "uuid" DEFAULT NULL::"uuid", "p_members" "jsonb" DEFAULT '[]'::"jsonb") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
DECLARE
  v_chat_id UUID;
  v_team_config JSONB;
  v_member JSONB;
  v_member_id UUID;
  v_is_admin BOOLEAN;
BEGIN
  -- Validate that members array is not empty
  IF jsonb_array_length(p_members) = 0 THEN
    RAISE EXCEPTION 'Members are required, at least the team owner should be added';
  END IF;

  -- Insert team
  INSERT INTO teams (
    id,
    name,
    logo_url,
    associated_club
  ) VALUES (
    p_team_id,
    p_team_name,
    p_logo_url,
    p_associated_club
  );

  -- Insert team members
  -- Note: Column names may be 'profile_id' instead of 'member_id' depending on your schema
  FOR v_member IN SELECT * FROM jsonb_array_elements(p_members)
  LOOP
    v_member_id := (v_member->>'id')::UUID;
    v_is_admin := COALESCE((v_member->>'is_admin')::BOOLEAN, false);
    
    INSERT INTO team_members (
      team_id,
      member_id,
      is_admin
    ) VALUES (
      p_team_id,
      v_member_id,
      v_is_admin
    );
  END LOOP;

  -- Build team chat config JSONB
  v_team_config := jsonb_build_object(
    'chat_type', 'team',
    'team_id', p_team_id,
    'team_name', p_team_name,
    'team_logo_url', p_logo_url
  );

  -- Create chat with team config
  INSERT INTO chats (
    name,
    config
  ) VALUES (
    p_team_name,
    v_team_config
  )
  RETURNING id INTO v_chat_id;

  -- Insert chat members (all team members get added to the chat)
  FOR v_member IN SELECT * FROM jsonb_array_elements(p_members)
  LOOP
    v_member_id := (v_member->>'id')::UUID;
    
    INSERT INTO chat_members (
      chat_id,
      profile_id
    ) VALUES (
      v_chat_id,
      v_member_id
    );
  END LOOP;
END;
$$;


--
-- Name: FUNCTION "create_team"("p_team_id" "uuid", "p_team_name" "text", "p_logo_url" "text", "p_associated_club" "uuid", "p_members" "jsonb"); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION "public"."create_team"("p_team_id" "uuid", "p_team_name" "text", "p_logo_url" "text", "p_associated_club" "uuid", "p_members" "jsonb") IS 'Creates a team, inserts team members, creates a team chat, and adds all team members to the chat. Returns team_id and chat_id.';


--
-- Name: get_composition_by_session_id("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_composition_by_session_id"("p_session_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_report_id uuid;
  v_composition jsonb;
begin
  -- ✅ Guard: handle null input early
  if p_session_id is null then
    return null;
  end if;

  -- ✅ Step 1: find the report ID for the given session
  select sr.id
  into v_report_id
  from session_reports sr
  where sr.session_id = p_session_id
  limit 1;

  if v_report_id is null then
    return null;
  end if;

  -- ✅ Step 2: fetch composition safely
  select to_jsonb(src)
  into v_composition
  from session_report_composition src
  where src.report_id = v_report_id
  limit 1;

  return v_composition; -- null automatically if no row found
end;
$$;


--
-- Name: get_game_events_by_session_id("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_game_events_by_session_id"("session_id" "uuid") RETURNS TABLE("id" "uuid", "report_id" "uuid", "events" "jsonb")
    LANGUAGE "sql"
    AS $$
  select 
    gs.id, 
    gs.report_id, 
    gs.events
  from session_report_game_stats gs
  join session_reports r on gs.report_id = r.id
  where r.session_id = get_game_events_by_session_id.session_id;
$$;


--
-- Name: get_individual_profile("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_individual_profile"("p_profile_id" "uuid") RETURNS TABLE("profile_id" "uuid", "sport_role" "public"."individual_role", "sport_goal" "text", "image_url" "text", "first_name" "text", "last_name" "text", "username" "text", "country_name" "text", "city_name" "text", "age" integer, "primary_sport_id" "uuid", "primary_sport_name" "text", "primary_sport_icon" "text", "field_position" "text", "strong_foot" "text", "height_cm" integer, "player_status" "text", "coach_certifications" "jsonb", "referee_match_types" "jsonb")
    LANGUAGE "plpgsql" STABLE
    AS $$
BEGIN
  -- If p_profile_id is NULL, use profile_id() helper
  p_profile_id := COALESCE(p_profile_id, (SELECT profile_id()));

  RETURN QUERY
    SELECT
      profile.profile_id,
      profile.sport_role,
      profile.sport_goal,
      profile.image_url,
      profile.first_name,
      profile.last_name,
      profile.username,
      country.name AS country_name,
      city.name AS city_name,
      DATE_PART('year', AGE(profile.date_of_birth))::int AS age,
      profile.primary_sport_id,
      sport.name AS primary_sport_name,
      sport.icon_url AS primary_sport_icon,
      profile.field_position,
      profile.strong_foot,
      profile.height_cm,
      profile.player_status,
      profile.coach_certifications,
      profile.referee_match_types
    FROM
      public.individual_profiles AS profile
    LEFT JOIN
      public.countries AS country ON country.id = profile.country_id
    LEFT JOIN
      public.cities AS city ON city.id = profile.city_id
    LEFT JOIN
      public.sports AS sport ON sport.id = profile.primary_sport_id
    WHERE
      profile.profile_id = p_profile_id;
END;
$$;


--
-- Name: get_invited_members("uuid", "text", "public"."session_invitation_status"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_invited_members"("p_session_id" "uuid", "q" "text" DEFAULT ''::"text", "q_status" "public"."session_invitation_status" DEFAULT NULL::"public"."session_invitation_status") RETURNS TABLE("id" "uuid", "name" "text", "avatar_url" "text", "is_admin" boolean, "profile_id" "uuid", "status" "public"."session_invitation_status")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    si.member_id AS id,
    CONCAT(ip.first_name, ' ', ip.last_name) AS name,
    p.avatar_url,
    tm.is_admin,
    p.id AS profile_id,
    si.status
  FROM 
    session_invitations si
  INNER JOIN 
    team_members tm ON si.member_id = tm.id
  INNER JOIN 
    profiles p ON tm.member_id = p.id
  INNER JOIN 
    individual_profiles ip ON p.id = ip.profile_id
  WHERE 
    si.session_id = p_session_id
    AND CONCAT(ip.first_name, ' ', ip.last_name) ILIKE '%' || q || '%'
    AND (q_status IS NULL OR si.status = q_status)
  ORDER BY 
    ip.first_name, ip.last_name;
END;
$$;


--
-- Name: get_medical_reports("uuid", "text"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_medical_reports"("p_team_id" "uuid", "q" "text" DEFAULT ''::"text") RETURNS TABLE("id" "uuid", "member" "jsonb", "severity" "public"."medical_severity", "cause" "public"."session_type", "injury_date" timestamp with time zone, "estimated_recovery_date" timestamp with time zone, "report" "text")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    mr.id,
    jsonb_build_object(
      'id', tm.id,
      'name', p.display_name,
      'avatar_url', p.avatar_url,
      'profile_id', tm.member_id
    ) AS member,
    mr.severity,
    mr.cause,
    mr.injury_date,
    mr.recovery_date AS estimated_recovery_date,
    mr.report
  FROM medical_reports mr
  JOIN team_members tm ON tm.id = mr.member_id
  JOIN profiles p ON p.id = tm.member_id
  WHERE mr.team_id = p_team_id
    AND (q = '' OR p.display_name ILIKE '%' || q || '%')
  ORDER BY mr.injury_date DESC;
END;
$$;


--
-- Name: profile_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."profile_id"() RETURNS "uuid"
    LANGUAGE "sql" STABLE
    AS $$SELECT id FROM public.profiles WHERE profiles.user_id = public.uid()$$;


--
-- Name: uid(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."uid"() RETURNS "text"
    LANGUAGE "sql" STABLE
    AS $$ 
   select  
   	coalesce( 
 		current_setting('request.jwt.claim.sub', true), 
 		(current_setting('request.jwt.claims', true)::jsonb ->> 'sub') 
 	)::text 
 $$;


SET default_tablespace = '';

SET default_table_access_method = "heap";

--
-- Name: opportunities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."opportunities" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "title" "text" NOT NULL,
    "description" "text" NOT NULL,
    "category" "public"."opportunity_category" NOT NULL,
    "status" "public"."opportunity_status" DEFAULT 'published'::"public"."opportunity_status" NOT NULL,
    "deadline" timestamp with time zone NOT NULL,
    "created_by" "uuid" NOT NULL,
    "latitude" real NOT NULL,
    "longitude" real NOT NULL,
    "address" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL
);


--
-- Name: TABLE "opportunities"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."opportunities" IS 'Main opportunities table with basic information';


--
-- Name: opportunity_applications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."opportunity_applications" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "opportunity_id" "uuid" NOT NULL,
    "applicant_id" "uuid" NOT NULL,
    "status" "public"."application_status" DEFAULT 'pending'::"public"."application_status" NOT NULL,
    "answers" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "applied_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL
);


--
-- Name: TABLE "opportunity_applications"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."opportunity_applications" IS 'Answers to opportunity questions from applicants';


--
-- Name: opportunity_requirements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."opportunity_requirements" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "opportunity_id" "uuid" NOT NULL,
    "min_age" smallint NOT NULL,
    "max_age" smallint NOT NULL,
    "min_experience_years" smallint NOT NULL,
    "availability_date" timestamp with time zone NOT NULL,
    "languages" "jsonb" NOT NULL,
    "questions" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL,
    CONSTRAINT "check_languages_schema" CHECK ("extensions"."jsonb_matches_schema"('{
            "type": "array",
            "items": {
                "type": "string",
                "enum": ["Dutch", "French", "English"]
            },
            "uniqueItems": true,
            "maxItems": 10
        }'::json, "languages")),
    CONSTRAINT "check_questions_schema" CHECK ("extensions"."jsonb_matches_schema"('{
            "type": "array", 
            "items": {
                "type": "string",
                "minLength": 1,
                "maxLength": 500
            },
            "maxItems": 20
        }'::json, "questions"))
);


--
-- Name: TABLE "opportunity_requirements"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."opportunity_requirements" IS 'Age, experience and availability requirements for opportunities';


--
-- Name: COLUMN "opportunity_requirements"."languages"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."opportunity_requirements"."languages" IS 'JSONB array of required languages for the opportunity';


--
-- Name: COLUMN "opportunity_requirements"."questions"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."opportunity_requirements"."questions" IS 'JSONB array of yes/no questions for applicants';


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "text" DEFAULT "public"."uid"() NOT NULL,
    "user_type" "public"."user_type" NOT NULL,
    "display_name" "text" DEFAULT ''''''::"text" NOT NULL,
    "bio" "text",
    "avatar_url" "text",
    "preferred_language" "text" DEFAULT 'en'::"text" NOT NULL,
    "country_id" smallint NOT NULL,
    "city_id" smallint
);


--
-- Name: TABLE "profiles"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."profiles" IS 'Main profile information for all user types';


--
-- Name: COLUMN "profiles"."display_name"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."profiles"."display_name" IS 'Generated column based on user_type and name from extended profile tables';


--
-- Name: COLUMN "profiles"."avatar_url"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."profiles"."avatar_url" IS 'Generated column based on image_url from extended profile tables';


--
-- Name: saved_opportunities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."saved_opportunities" (
    "profile_id" "uuid" DEFAULT "public"."profile_id"() NOT NULL,
    "opportunity_id" "uuid" NOT NULL
);


--
-- Name: opportunity_view; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "public"."opportunity_view" WITH ("security_invoker"='on') AS
 SELECT "o"."id",
    "o"."title",
    "o"."description",
    "o"."category",
    "o"."status",
    "o"."deadline",
    "o"."created_by",
    "o"."latitude",
    "o"."longitude",
    "o"."address",
    "jsonb_build_object"('latitude', "o"."latitude", 'longitude', "o"."longitude", 'address', "o"."address") AS "location",
    "jsonb_build_object"('minAge', COALESCE(("req"."min_age")::integer, 0), 'maxAge', COALESCE(("req"."max_age")::integer, 100), 'languages', COALESCE("req"."languages", '[]'::"jsonb"), 'availability', COALESCE("req"."availability_date", "o"."deadline"), 'minExperience', COALESCE(("req"."min_experience_years")::integer, 0), 'qandA', COALESCE("req"."questions", '[]'::"jsonb")) AS "requirements",
    COALESCE(( SELECT "jsonb_agg"("jsonb_build_object"('id', "app"."id", 'applicant', "app"."applicant_id", 'status', "app"."status", 'answers', "app"."answers", 'applied_at', "app"."applied_at")) AS "jsonb_agg"
           FROM "public"."opportunity_applications" "app"
          WHERE ("app"."opportunity_id" = "o"."id")), '[]'::"jsonb") AS "applicants",
    "creator_profile"."avatar_url" AS "image",
    "creator_profile"."display_name" AS "creator_name",
    "creator_profile"."user_type" AS "creator_type",
    "o"."created_at",
    "o"."updated_at",
    (EXISTS ( SELECT 1
           FROM "public"."saved_opportunities"
          WHERE (("saved_opportunities"."opportunity_id" = "o"."id") AND ("saved_opportunities"."profile_id" = "public"."profile_id"())))) AS "is_saved"
   FROM (("public"."opportunities" "o"
     LEFT JOIN "public"."opportunity_requirements" "req" ON (("req"."opportunity_id" = "o"."id")))
     LEFT JOIN "public"."profiles" "creator_profile" ON (("creator_profile"."id" = "o"."created_by")));


--
-- Name: get_opportunities_by_applicant(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_opportunities_by_applicant"() RETURNS SETOF "public"."opportunity_view"
    LANGUAGE "sql"
    AS $$

 SELECT * FROM public.opportunity_view v WHERE v.applicants @> format('[{"applicant":"%s"}]', 
 (SELECT id FROM public.profiles WHERE profiles.user_id = public.uid()))::jsonb;  

$$;


--
-- Name: get_profile_avatar_url("uuid", "public"."user_type"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_profile_avatar_url"("p_profile_id" "uuid", "user_type_val" "public"."user_type") RETURNS "text"
    LANGUAGE "plpgsql" STABLE
    AS $$
DECLARE
    avatar_url TEXT;
BEGIN
    CASE user_type_val
        WHEN 'private_profile' THEN
            SELECT image_url INTO avatar_url
            FROM individual_profiles WHERE individual_profiles.profile_id = p_profile_id;
            
        WHEN 'sport_entity' THEN
            SELECT image_url INTO avatar_url
            FROM sport_entity_profiles WHERE sport_entity_profiles.profile_id = p_profile_id;
    END CASE;
    
    RETURN avatar_url;
END;
$$;


--
-- Name: get_profile_display_name("uuid", "public"."user_type"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_profile_display_name"("p_profile_id" "uuid", "user_type_val" "public"."user_type") RETURNS "text"
    LANGUAGE "plpgsql" STABLE
    AS $$
DECLARE
    display_name TEXT;
BEGIN
    CASE user_type_val
        WHEN 'private_profile' THEN
            SELECT CONCAT(first_name, ' ', last_name) INTO display_name
            FROM individual_profiles WHERE individual_profiles.profile_id = p_profile_id;
            
        WHEN 'sport_entity' THEN
            SELECT entity_name INTO display_name
            FROM sport_entity_profiles WHERE sport_entity_profiles.profile_id = p_profile_id;
    END CASE;
    
    RETURN COALESCE(display_name, 'Unknown User');
END;
$$;


--
-- Name: get_profile_experiences("public"."individual_role", "uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_profile_experiences"("p_sport_role" "public"."individual_role" DEFAULT NULL::"public"."individual_role", "p_profile_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("sport_role" "public"."individual_role", "image_url" "text", "title" "text", "category" "text", "season" "text", "start_date" timestamp with time zone, "end_date" timestamp with time zone, "role" "text")
    LANGUAGE "plpgsql" STABLE
    AS $$
BEGIN
  p_profile_id := COALESCE(p_profile_id, (SELECT profile_id()));

  RETURN QUERY
  SELECT
    ip.sport_role,
    sep.image_url,
    sep.entity_name AS title,
    CASE
      WHEN ip.sport_role = 'player'::public.individual_role THEN 'U23'
      WHEN ip.sport_role = 'coach'::public.individual_role THEN 'Adult Men'
      ELSE NULL
    END AS category,
    CASE
      WHEN ip.sport_role = 'player'::public.individual_role THEN 'Season 2024/2025'
      ELSE NULL
    END AS season,
    CASE
      WHEN ip.sport_role IN ('coach'::public.individual_role, 'referee'::public.individual_role)
        THEN TIMESTAMPTZ '2024-01-01T00:00:00+00:00'
      ELSE NULL
    END AS start_date,
    CASE
      WHEN ip.sport_role IN ('coach'::public.individual_role, 'referee'::public.individual_role)
        THEN now()
      ELSE NULL
    END AS end_date,
    CASE
      WHEN ip.sport_role = 'coach'::public.individual_role THEN ip.coach_role
      ELSE NULL
    END AS role
  FROM public.individual_profiles ip
  LEFT JOIN public.sport_entity_profiles sep
    ON ip.sport_entity_id = sep.id
  WHERE ip.profile_id = p_profile_id;
END;
$$;


--
-- Name: get_profile_id_by_team_member("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_profile_id_by_team_member"("team_member_id" "uuid") RETURNS "uuid"
    LANGUAGE "sql" STABLE
    AS $$
  SELECT tm.member_id
  FROM public.team_members tm
  WHERE tm.id = team_member_id
  LIMIT 1;
$$;


--
-- Name: get_ratings_by_session_id("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_ratings_by_session_id"("p_session_id" "uuid") RETURNS SETOF "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_report_id uuid;
begin
  -- ✅ Guard: no input
  if p_session_id is null then
    return;
  end if;

  -- ✅ Step 1: get report ID
  select sr.id
  into v_report_id
  from session_reports sr
  where sr.session_id = p_session_id
  limit 1;

  if v_report_id is null then
    return;
  end if;

  -- ✅ Step 2: return all ratings as JSONB
  return query
  select to_jsonb(r)
  from session_report_ratings r
  where r.report_id = v_report_id;
end;
$$;


--
-- Name: get_report_by_id("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_report_by_id"("p_report_id" "uuid") RETURNS TABLE("id" "uuid", "is_completed" boolean, "session" "jsonb")
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    
    return QUERY
    SELECT 
        sr.id,
        sr.is_completed,
        to_jsonb(ts.*) || jsonb_build_object(
            'my_team', to_jsonb(mt.*),
            'opponent_team', to_jsonb(ot.*)
        ) as session
    FROM session_reports sr
    LEFT JOIN team_sessions ts ON sr.session_id = ts.id
    LEFT JOIN teams mt ON ts.team_id = mt.id
    LEFT JOIN teams ot ON ts.opponent_team_id = ot.id
    WHERE sr.id = p_report_id;
END;
$$;


--
-- Name: get_reports("text", "uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_reports"("p_session_type" "text", "p_team_id" "uuid") RETURNS SETOF "jsonb"
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        jsonb_build_object(
            'id', sr.id,
            'is_completed', sr.is_completed,
            'session', 
                to_jsonb(ts.*) ||
                jsonb_build_object(
                    'my_team', to_jsonb(mt.*),
                    'opponent_team', to_jsonb(ot.*)
                )
        )
    FROM session_reports sr
    LEFT JOIN team_sessions ts ON sr.session_id = ts.id
    LEFT JOIN teams mt ON ts.team_id = mt.id
    LEFT JOIN teams ot ON ts.opponent_team_id = ot.id
    WHERE 
        ts.type = p_session_type::session_type  -- <--- IMPORTANT FIX
        AND ts.team_id = p_team_id;             -- <--- only your team's reports
END;
$$;


--
-- Name: get_saved_opportunities(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_saved_opportunities"() RETURNS SETOF "public"."opportunity_view"
    LANGUAGE "sql"
    AS $$
SELECT ov.* 
FROM public.opportunity_view ov
INNER JOIN public.saved_opportunities so ON so.opportunity_id = ov.id
WHERE so.profile_id = (select public.profile_id());
$$;


--
-- Name: get_session_details_for_user("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_session_details_for_user"("p_session_id" "uuid") RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $$
declare
  v_session record;
  v_my_profile record;
  v_my_team record;
  v_opponent_team record;
  v_my_team_member record;
  v_invitation record;
  v_opponent_results jsonb := '[]'::jsonb;
  v_result jsonb := '{}'::jsonb;
begin

  -- load team_session (must exist)
  select *
  from team_sessions
  where id = p_session_id
  into v_session;

  if not found then
    raise exception 'session not found: %', p_session_id;
  end if;

  -- load caller's profile (by user_id)
  select *
  from profiles
  where id = (SELECT profile_id())
  into v_my_profile;

  if not found then
    raise exception 'profile not found for logged in user: %', (SELECT profile_id());
  end if;

  -- load my team
  select *
  from teams
  where id = v_session.team_id
  into v_my_team;

  if not found then
    raise exception 'team not found: %', v_session.team_id;
  end if;

  -- load my team_member row (team_members.member_id references profiles.id)
  select *
  from team_members
  where team_id = v_my_team.id
    and member_id = v_my_profile.id
  limit 1
  into v_my_team_member;

  if not found then
    RAISE EXCEPTION 'user is not a part of this team: %', v_my_team.id;
  end if;

  -- load invitation (may be null)
    select *
    from session_invitations
    where session_id = p_session_id
      and member_id = v_my_team_member.id
    limit 1
    into v_invitation;
 

  -- load opponent team if present
  if v_session.opponent_team_id is not null then
    select *
    from teams
    where id = v_session.opponent_team_id::uuid
    into v_opponent_team;

    -- compute last 5 completed game results for the opponent team
    -- For each recent session where team_id = opponent_team_id, type = 'game', is_completed = true:
    --    count goals in session.events (jsonb array) where 
    --    event.type = 'goal' and event.team_id = opponent_team.id -> scored
    --    count goals in session.events where 
    --    event.type = 'goal' and event.team_id != opponent_team.id -> conceded
    --    map scored>conceded -> 'win', scored<conceded -> 'lose', else 'tie'
    with 
    recent_events as (
      select grep.events as events
      from session_report_game_stats grep
      INNER JOIN session_reports srep on srep.id = grep.report_id
      INNER JOIN team_sessions ts ON ts.id = srep.session_id
      where ts.team_id = v_session.opponent_team_id::uuid
        and ts.type = 'game'::session_type
        and coalesce(srep.is_completed, false) = true
      order by ts.appointment_datetime desc
      limit 5
    ),
    goals_counted as (
      select
        -- count goals scored by opponent_team in that session
        (
          select count(*)
          from jsonb_array_elements(r.events) evt
          where (evt->>'type') = 'goal'
            and (evt->>'team_id') = v_session.opponent_team_id::text
        )::int as scored,
        -- count goals conceded (goals by other team)
        (
          select count(*)
          from jsonb_array_elements(r.events) evt
          where (evt->>'type') = 'goal'
            and (evt->>'team_id') IS NOT NULL
            and (evt->>'team_id') <> v_session.opponent_team_id::text
        )::int as conceded
      from recent_events r
    )
    select jsonb_agg(
             case
               when scored > conceded then to_jsonb('win'::text)
               when scored < conceded then to_jsonb('lose'::text)
               else to_jsonb('tie'::text)
             end
           ) into v_opponent_results
    from goals_counted;
    -- if no rows, ensure it's an empty array not null
    if v_opponent_results is null then
      v_opponent_results := '[]'::jsonb;
    end if;
  else
    v_opponent_team := null;
    v_opponent_results := '[]'::jsonb;
  end if;

  v_result := jsonb_build_object(
    -- direct fields from team_sessions
    'id', v_session.id::text,
    'location', coalesce(v_session.location, '{}'::jsonb),
    'description', coalesce(v_session.description, '')::text,
    'appointment_datetime', coalesce(v_session.appointment_datetime::timestamptz::text, '')::text,
    'end_time', coalesce(v_session.end_time::timestamptz::text, '')::text,
    'start_time', coalesce(v_session.start_time::timestamptz::text, '')::text,
    'name', coalesce(v_session.name, '')::text,
    'type', coalesce(v_session.type::text, '')::session_type,
    'team_id', v_session.team_id::text,
    'attendance_hidden', v_session.attendance_hidden
  );

  -- add game-specific fields if it's a game
  if v_session.type = 'game'::session_type then
    v_result := v_result || jsonb_build_object(
      'turf', v_session.turf,
      'opponent_team_last_results', v_opponent_results,
      'opponent_team', jsonb_build_object(
        'id', v_opponent_team.id::text,
        'name', coalesce(v_opponent_team.name, '')::text,
        'logo_url', coalesce(v_opponent_team.logo_url, '')::text,
        'im_admin', false
      )
    );
  end if;

  -- add my_team nested object
  v_result := v_result || jsonb_build_object(
    'my_team',
      jsonb_build_object(
        'id', v_my_team.id::text,
        'name', coalesce(v_my_team.name, '')::text,
        'logo_url', coalesce(v_my_team.logo_url, '')::text,
        'im_admin', coalesce(v_my_team_member.is_admin, false)
      )
  );


  -- add invitation_status (default pending)
  v_result := v_result || jsonb_build_object(
    'invitation_status', coalesce(v_invitation.status, 'pending')::text
  );

  return v_result;
end;$$;


--
-- Name: get_sport_entity_profile("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_sport_entity_profile"("p_profile_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("profile_id" "uuid", "entity_type" "public"."sport_entity_type", "image_url" "text", "name" "text", "username" "text", "number_of_opportunities" integer, "primary_sport_name" "text", "primary_sport_icon" "text", "contact_phone" "text", "contact_email" "text", "contact_website" "text", "location" "jsonb", "number_of_teams" integer, "youth_leagues" "jsonb", "adult_men_divisions" "jsonb", "adult_women_divisions" "jsonb", "number_of_clubs" integer)
    LANGUAGE "sql"
    AS $$
  SELECT
    sep.profile_id AS profile_id,
    sep.entity_type AS entity_type,
    sep.image_url AS image_url,
    sep.entity_name AS name,
    sep.username AS username,
    -- count opportunities created by this profile (integer)
    COALESCE((
      SELECT COUNT(*)::integer FROM public.opportunities o
      WHERE o.created_by = sep.profile_id
    ), 0) AS number_of_opportunities,
    s.name AS primary_sport_name,
    s.icon_url AS primary_sport_icon,
    sep.contact_phone AS contact_phone,
    sep.contact_email AS contact_email,
    sep.contact_website AS contact_website,
    -- static lat/lon and composed address from jsonb address
    jsonb_build_object(
      'latitude', 50.498393,
      'longitude', 4.673234,
      'address',
        trim(
          COALESCE((sep.address ->> 'postal_code') || ' ', '') ||
          COALESCE((sep.address ->> 'city') || ' ', '') ||
          COALESCE((sep.address ->> 'street') || ' ', '') ||
          COALESCE((sep.address ->> 'country') , '')
        )
    ) AS location,
    -- number_of_teams only for clubs (integer)
    CASE
      WHEN sep.entity_type = 'club'::public.sport_entity_type THEN COALESCE((
        SELECT COUNT(*)::integer FROM public.teams t WHERE t.associated_club = sep.id
      ), 0)
      ELSE NULL
    END AS number_of_teams,
    -- youth_leagues only for clubs
    CASE
      WHEN sep.entity_type = 'club'::public.sport_entity_type THEN sep.youth_leagues
      ELSE NULL
    END AS youth_leagues,
    -- adult_men_divisions only for clubs
    CASE
      WHEN sep.entity_type = 'club'::public.sport_entity_type THEN sep.adult_men_divisions
      ELSE NULL
    END AS adult_men_divisions,
    -- adult_women_divisions only for clubs
    CASE
      WHEN sep.entity_type = 'club'::public.sport_entity_type THEN sep.adult_women_divisions
      ELSE NULL
    END AS adult_women_divisions,
    -- number_of_clubs only for federation
    CASE
      WHEN sep.entity_type = 'federation'::public.sport_entity_type THEN 25
      ELSE NULL
    END AS number_of_clubs
  FROM public.sport_entity_profiles sep
  LEFT JOIN public.sports s ON s.id = sep.primary_sport_id
  WHERE sep.profile_id = COALESCE(p_profile_id, (SELECT profile_id()));
$$;


--
-- Name: get_team_members("uuid", "text"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_team_members"("p_team_id" "uuid", "q" "text" DEFAULT ''::"text") RETURNS TABLE("id" "uuid", "profile_id" "uuid", "name" "text", "avatar_url" "text", "is_admin" boolean)
    LANGUAGE "plpgsql"
    AS $$

BEGIN 
    RETURN QUERY SELECT 
        team_members.id,
        team_members.member_id,
        profiles.display_name,
        profiles.avatar_url,
        team_members.is_admin
    FROM team_members
    INNER JOIN profiles ON team_members.member_id = profiles.id
    WHERE team_members.team_id = p_team_id
    AND (profiles.display_name ILIKE '%' || q || '%');
END;
$$;


--
-- Name: get_team_profile("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_team_profile"("p_team_id" "uuid") RETURNS TABLE("id" "uuid", "name" "text", "image_url" "text", "notifications_count" integer, "recent_sessions" "jsonb", "next_sessions" "jsonb", "im_admin" boolean)
    LANGUAGE "plpgsql"
    AS $$
DECLARE
  v_team_name text;
  v_logo_url text;
  v_im_admin boolean;
BEGIN

  SELECT EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = p_team_id
      AND tm.member_id = (select profile_id())
      AND tm.is_admin
  ) INTO v_im_admin;

  -- Get team basic info
  SELECT t.name, t.logo_url
  INTO v_team_name, v_logo_url
  FROM teams t
  WHERE t.id = p_team_id;

  -- Return the team profile with sessions
  RETURN QUERY
  SELECT 
    p_team_id as id,
    v_team_name as name,
    v_logo_url as image_url,
    0 as notifications_count,
    COALESCE(
      (
        SELECT jsonb_agg(
          to_jsonb(ts.*) || jsonb_build_object(
            'my_team', to_jsonb(mt.*),
            'opponent_team', to_jsonb(ot.*)
          )
          ORDER BY ts.appointment_datetime
        )
        FROM team_sessions ts
        LEFT JOIN teams ot ON ot.id = ts.opponent_team_id
        LEFT JOIN teams mt ON mt.id = ts.team_id
        WHERE ts.team_id = p_team_id
          AND ts.appointment_datetime::date IN (
            SELECT generate_series(
              current_date - INTERVAL '3 days',
              current_date + INTERVAL '3 days',
              INTERVAL '1 day'
            )::date
          )
      ),
      '[]'::jsonb
    ) as recent_sessions,
    CASE 
      WHEN v_im_admin THEN '[]'::jsonb
      ELSE COALESCE(
        (
          SELECT jsonb_agg(
            to_jsonb(ts.*) || jsonb_build_object(
              'my_team', to_jsonb(mt.*),
              'opponent_team', to_jsonb(ot.*)
            )
            ORDER BY ts.appointment_datetime
          )
          FROM team_sessions ts
          LEFT JOIN teams ot ON ot.id = ts.opponent_team_id
          LEFT JOIN teams mt ON mt.id = ts.team_id
          WHERE ts.team_id = p_team_id
          AND ts.appointment_datetime > current_timestamp
        ),
        '[]'::jsonb
      )
    END as next_sessions,
    v_im_admin as im_admin;
END;
$$;


--
-- Name: get_team_statistics("uuid", integer, boolean); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_team_statistics"("p_team_id" "uuid", "p_matches_limit" integer DEFAULT NULL::integer, "p_order_descending" boolean DEFAULT true) RETURNS "jsonb"
    LANGUAGE "plpgsql"
    AS $_$declare
    v_members jsonb;
    v_matches jsonb := '{}'::jsonb;
    v_order text := case when p_order_descending then 'DESC' else 'ASC' end;
    r record;
begin
    -------------------------------------------------------------------
    -- 1. Fetch TEAM MEMBERS
    -------------------------------------------------------------------
    select jsonb_agg(
        jsonb_build_object(
            'id', tm.id,                    -- team_members.id
            'profile_id', tm.member_id,     -- team_members.member_id -> profiles.id
            'avatar_url', p.avatar_url,     -- profiles.avatar_url
            'name', p.display_name,         -- profiles.display_name
            'is_admin', tm.is_admin
        )
    )
    into v_members
    from team_members tm
    left join profiles p on p.id = tm.member_id
    where tm.team_id = p_team_id;

    if v_members is null then
        v_members := '[]'::jsonb;
    end if;

    -------------------------------------------------------------------
    -- 2. Loop through MATCHES (team_sessions + session_reports)
    -------------------------------------------------------------------
    for r in
        execute format(
            $sql$
            select
                sr.id as report_id,
                sr.is_completed,
                ts.id as session_id,
                ts.location,
                ts.description,
                ts.appointment_datetime,
                ts.start_time,
                ts.end_time,
                ts.name,
                ts.type,
                ts.turf,
                my_team.id as my_team_id,
                my_team.name as my_team_name,
                my_team.logo_url as my_team_logo_url,
                op_team.id as op_team_id,
                op_team.name as op_team_name,
                op_team.logo_url as op_team_logo_url
            from session_reports sr
            join team_sessions ts on ts.id = sr.session_id
            join teams my_team on my_team.id = ts.team_id
            join teams op_team on op_team.id = ts.opponent_team_id
            where ts.team_id = %L
              and sr.is_completed = true
              and ts.type = 'game'
            order by ts.appointment_datetime %s
            limit %s
            $sql$, p_team_id, v_order, coalesce(p_matches_limit::text, 'ALL')
        )
    loop
        ---------------------------------------------------------------
        -- 2A - Build report object
        ---------------------------------------------------------------
        declare
            v_report jsonb;
            v_stats jsonb;
            v_composition jsonb;
            v_attendance jsonb;
            v_ratings jsonb; 
        begin
            -- REPORT object
            v_report := jsonb_build_object(
                'id', r.report_id,
                'is_completed', r.is_completed,
                'session', jsonb_build_object(
                    'id', r.session_id,
                    'location', r.location,
                    'description', r.description,
                    'appointment_datetime', r.appointment_datetime,
                    'start_time', r.start_time,
                    'end_time', r.end_time,
                    'name', r.name,
                    'type', r.type,
                    'turf', r.turf,
                    'my_team', jsonb_build_object(
                        'id', r.my_team_id,
                        'name', r.my_team_name,
                        'logo_url', r.my_team_logo_url,
                        'im_admin', false
                    ),
                    'opponent_team', jsonb_build_object(
                        'id', r.op_team_id,
                        'name', r.op_team_name,
                        'logo_url', r.op_team_logo_url,
                        'im_admin', false
                    )
                )
            );

            -----------------------------------------------------------
            -- 2B - Match STATS
            -----------------------------------------------------------
            select jsonb_build_object(
                'id', gs.id,
                'report_id', gs.report_id,
                'events', gs.events
            )
            into v_stats
            from session_report_game_stats gs
            where gs.report_id = r.report_id
            limit 1;

            if v_stats is null then
                v_stats := jsonb_build_object('stats', null) -> 'stats';
            end if;

            -----------------------------------------------------------
            -- 2C - Composition
            -----------------------------------------------------------
            select jsonb_build_object(
                'id', c.id,
                'report_id', c.report_id,
                'substitutes', c.substitutes,
                'positions', c.positions,
                'formation_name', c.formation_name
            )
            into v_composition
            from session_report_composition c
            where c.report_id = r.report_id
            limit 1;

            if v_composition is null then
                v_composition := jsonb_build_object('composition', null) -> 'composition';
            end if;
            -----------------------------------------------------------
            -- 2D - Attendance
            -----------------------------------------------------------
            select jsonb_agg(
                jsonb_build_object(
                    'id', a.id,
                    'member_id', a.member_id,
                    'status', a.status,
                    'report_id', a.report_id
                )
            )
            into v_attendance
            from session_report_attendance a
            where a.report_id = r.report_id;

            if v_attendance is null then
                v_attendance := '[]'::jsonb;
            end if;
            -----------------------------------------------------------
            -- 2E - Ratings
            -----------------------------------------------------------
            select jsonb_agg(
                jsonb_build_object(
                    'id', r2.id,
                    'report_id', r2.report_id,
                    'member_id', r2.member_id,
                    'rating', r2.rating
                )
            )
            into v_ratings
            from session_report_ratings r2
            where r2.report_id = r.report_id;

            if v_ratings is null then
                v_ratings := '[]'::jsonb;
            end if;
            -----------------------------------------------------------
            -- 2F - Add match block
            -----------------------------------------------------------
            v_matches := v_matches || jsonb_build_object(
                r.report_id::text,
                jsonb_build_object(
                    'report', v_report,
                    'stats', v_stats,
                    'composition', v_composition,
                    'attendance', v_attendance,
                    'ratings', v_ratings
                )
            );
        end;
    end loop;
    -----------------------------------------------------------------
    -- 3. RETURN FULL DATASET
    -----------------------------------------------------------------
    return jsonb_build_object(
        'members', v_members,
        'matches', v_matches
    );
end;$_$;


--
-- Name: get_teams("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."get_teams"("p_profile_id" "uuid" DEFAULT NULL::"uuid") RETURNS TABLE("id" "uuid", "name" "text", "logo_url" "text", "im_admin" boolean)
    LANGUAGE "sql" STABLE
    AS $$
  SELECT
    t.id,
    t.name,
    t.logo_url,
    EXISTS (
      SELECT 1
      FROM public.team_members m
      WHERE m.member_id = COALESCE(p_profile_id, (SELECT profile_id()))
        AND m.team_id = t.id
        AND m.is_admin = true
    ) AS im_admin
  FROM public.teams t
  WHERE EXISTS (
      SELECT 1
      FROM public.team_members m
      WHERE m.member_id = COALESCE(p_profile_id, (SELECT profile_id()))
        AND m.team_id = t.id
    )
  ;
$$;


--
-- Name: is_user_in_team("uuid", "uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."is_user_in_team"("p_team_id" "uuid", "p_profile_id" "uuid" DEFAULT NULL::"uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    p_profile_id = COALESCE(p_profile_id, (SELECT profile_id()));
    IF p_profile_id IS NULL THEN
        RAISE EXCEPTION 'profile id is required';
    END IF;
    RETURN EXISTS (
        SELECT 1
        FROM team_members
        WHERE member_id = p_profile_id
          AND team_id = p_team_id
    );
END;
$$;


--
-- Name: FUNCTION "is_user_in_team"("p_team_id" "uuid", "p_profile_id" "uuid"); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION "public"."is_user_in_team"("p_team_id" "uuid", "p_profile_id" "uuid") IS 'Checks if a user is in a team';


--
-- Name: is_user_team_admin("uuid", "uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."is_user_team_admin"("p_team_id" "uuid", "p_profile_id" "uuid" DEFAULT NULL::"uuid") RETURNS boolean
    LANGUAGE "plpgsql"
    AS $$
BEGIN
    p_profile_id = COALESCE(p_profile_id, (SELECT profile_id()));
    IF p_profile_id IS NULL THEN
        RAISE EXCEPTION 'profile id is required';
    END IF;
    RETURN EXISTS (
        SELECT 1
        FROM team_members
        WHERE member_id = p_profile_id
          AND team_id = p_team_id
          AND is_admin = true
    );
END;
$$;


--
-- Name: FUNCTION "is_user_team_admin"("p_team_id" "uuid", "p_profile_id" "uuid"); Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON FUNCTION "public"."is_user_team_admin"("p_team_id" "uuid", "p_profile_id" "uuid") IS 'Checks if a user is a team admin';


--
-- Name: toggle_save_opportunity("uuid"); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."toggle_save_opportunity"("p_opportunity_id" "uuid") RETURNS "void"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_profile_id UUID;
BEGIN
    v_profile_id = profile_id();
    IF EXISTS (SELECT 1 FROM saved_opportunities WHERE opportunity_id = p_opportunity_id AND profile_id = v_profile_id) THEN
        DELETE FROM saved_opportunities WHERE opportunity_id = p_opportunity_id;
    ELSE
        INSERT INTO saved_opportunities (opportunity_id, profile_id) VALUES (p_opportunity_id, v_profile_id);
    END IF;
END;
$$;


--
-- Name: update_last_updated(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."update_last_updated"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  new.last_updated = now();
  return new;
end;
$$;


--
-- Name: update_profile_generated_columns(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."update_profile_generated_columns"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$DECLARE
    v_user_type user_type;
    v_profile_id UUID;
BEGIN
  -- Use TG_TABLE_NAME to determine which table triggered this
    IF TG_TABLE_NAME = 'individual_profiles' THEN
        v_profile_id := (NEW).profile_id;  -- Cast NEW to remove ambiguity
    ELSIF TG_TABLE_NAME = 'sport_entity_profiles' THEN
        v_profile_id := (NEW).profile_id;  -- Cast NEW to remove ambiguity
    END IF;
    
    SELECT p.user_type INTO v_user_type 
    FROM profiles p
    WHERE p.id = v_profile_id;
    
    -- Update display_name and avatar_url in profiles table
    UPDATE profiles p
    SET 
        display_name = get_profile_display_name(v_profile_id, v_user_type),
        avatar_url = get_profile_avatar_url(v_profile_id, v_user_type)
    WHERE p.id = v_profile_id;
    
    RETURN NEW;
END;$$;


--
-- Name: validate_composition(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION "public"."validate_composition"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
DECLARE
    v_team_id UUID;
    v_team_members UUID[];
BEGIN
    -- Get team_id
    SELECT team_id INTO v_team_id 
    FROM team_sessions 
    WHERE id = (SELECT session_id FROM session_reports WHERE id = NEW.report_id);

    IF v_team_id IS NULL THEN
        RAISE EXCEPTION 'Unable to find team for report';
    END IF;

    -- Get team members
    SELECT array_agg(id) INTO v_team_members 
    FROM team_members 
    WHERE team_id = v_team_id;

    IF v_team_members IS NULL THEN
        RAISE EXCEPTION 'No team members found for team';
    END IF;

    -- Check substitutes are valid team members
    IF EXISTS (
        SELECT 1 FROM unnest(NEW.substitutes) AS sub
        WHERE sub != ALL(v_team_members)
    ) THEN
        RAISE EXCEPTION 'Invalid substitute member ID';
    END IF;
    
    -- Check positions structure and member IDs
    IF jsonb_typeof(NEW.positions) != 'object' THEN
        RAISE EXCEPTION 'Positions must be a JSON object';
    END IF;

    -- Check if positions map length is 11
    IF (SELECT COUNT(*) FROM jsonb_each_text(NEW.positions)) != 11 THEN
        RAISE EXCEPTION 'Positions must be a map of 11 elements';
    END IF;
    
    IF EXISTS (
        SELECT 1 FROM jsonb_each_text(NEW.positions) AS kv(key, value)
        WHERE value::uuid != ALL(v_team_members)
    ) THEN
        RAISE EXCEPTION 'Invalid position member ID';
    END IF;
    
    RETURN NEW;
END;
$$;


--
-- Name: chat_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."chat_members" (
    "chat_id" "uuid" NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- Name: TABLE "chat_members"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."chat_members" IS 'Stores members participating in each chat';


--
-- Name: chats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."chats" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text",
    "config" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- Name: TABLE "chats"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."chats" IS 'Stores chat conversations';


--
-- Name: COLUMN "chats"."config"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."chats"."config" IS 'JSON configuration for chat settings (e.g., permissions, settings)';


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."team_members" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "team_id" "uuid" NOT NULL,
    "member_id" "uuid" NOT NULL,
    "is_admin" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- Name: teams; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."teams" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "logo_url" "text" NOT NULL,
    "created_by" "uuid" DEFAULT "public"."profile_id"() NOT NULL,
    "associated_club" "uuid",
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL
);


--
-- Name: chats_with_config; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW "public"."chats_with_config" WITH ("security_invoker"='on') AS
 SELECT "id",
    "name",
    "created_at",
        CASE
            WHEN (("config" ->> 'chat_type'::"text") = 'direct'::"text") THEN "jsonb_build_object"('chat_type', 'direct', 'participants', ("config" -> 'participants'::"text"), 'other_user_id', ( SELECT ("p"."id")::"text" AS "id"
               FROM ("jsonb_array_elements_text"(("c"."config" -> 'participants'::"text")) "participant_id"("value")
                 LEFT JOIN "public"."profiles" "p" ON ((("p"."id")::"text" = "participant_id"."value")))
              WHERE ("participant_id"."value" <> ("public"."profile_id"())::"text")
             LIMIT 1), 'other_user_name', ( SELECT "p"."display_name"
               FROM ("jsonb_array_elements_text"(("c"."config" -> 'participants'::"text")) "participant_id"("value")
                 LEFT JOIN "public"."profiles" "p" ON ((("p"."id")::"text" = "participant_id"."value")))
              WHERE ("participant_id"."value" <> ("public"."profile_id"())::"text")
             LIMIT 1), 'other_user_avatar_url', ( SELECT "p"."avatar_url"
               FROM ("jsonb_array_elements_text"(("c"."config" -> 'participants'::"text")) "participant_id"("value")
                 LEFT JOIN "public"."profiles" "p" ON ((("p"."id")::"text" = "participant_id"."value")))
              WHERE ("participant_id"."value" <> ("public"."profile_id"())::"text")
             LIMIT 1), 'last_message', ("config" ->> 'last_message'::"text"), 'last_message_time', ("config" ->> 'last_message_time'::"text"))
            WHEN (("config" ->> 'chat_type'::"text") = 'team'::"text") THEN "jsonb_build_object"('chat_type', 'team', 'team_id', ("config" ->> 'team_id'::"text"), 'team_name', ( SELECT "t"."name"
               FROM "public"."teams" "t"
              WHERE (("t"."id")::"text" = ("c"."config" ->> 'team_id'::"text"))
             LIMIT 1), 'team_logo_url', ( SELECT "t"."logo_url"
               FROM "public"."teams" "t"
              WHERE (("t"."id")::"text" = ("c"."config" ->> 'team_id'::"text"))
             LIMIT 1), 'last_message', ("config" ->> 'last_message'::"text"), 'last_message_time', ("config" ->> 'last_message_time'::"text"))
            WHEN (("config" ->> 'chat_type'::"text") = 'channel'::"text") THEN "jsonb_build_object"('chat_type', 'channel', 'channel_name', ("config" ->> 'channel_name'::"text"), 'channel_logo_url', ("config" ->> 'channel_logo_url'::"text"), 'sender_id', ("config" ->> 'sender_id'::"text"), 'is_read_only', COALESCE((("config" ->> 'is_read_only'::"text"))::boolean, true), 'last_message', ("config" ->> 'last_message'::"text"), 'last_message_time', ("config" ->> 'last_message_time'::"text"))
            ELSE COALESCE("config", '{}'::"jsonb")
        END AS "config"
   FROM "public"."chats" "c"
  WHERE ((( SELECT ("public"."profile_id"())::"text" AS "profile_id") IN ( SELECT "jsonb_array_elements_text"(("c"."config" -> 'participants'::"text")) AS "jsonb_array_elements_text")) OR (EXISTS ( SELECT 1
           FROM ("public"."teams" "t"
             JOIN "public"."team_members" "tm" ON (("tm"."team_id" = "t"."id")))
          WHERE ((("t"."id")::"text" = ("c"."config" ->> 'team_id'::"text")) AND ("tm"."member_id" = "public"."profile_id"()))
        UNION ALL
         SELECT 1
          WHERE (("c"."config" ->> 'chat_type'::"text") = 'channel'::"text"))));


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."cities" (
    "id" smallint NOT NULL,
    "name" "text" NOT NULL,
    "country_id" smallint NOT NULL,
    "latitude" numeric(10,8),
    "longitude" numeric(11,8)
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."countries" (
    "id" smallint NOT NULL,
    "name" "text" NOT NULL,
    "code" "text" NOT NULL,
    "latitude" numeric(10,8),
    "longitude" numeric(11,8),
    "emoji" "text",
    "translations" "jsonb",
    "is_supported" boolean DEFAULT false NOT NULL
);


--
-- Name: feedback_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."feedback_tickets" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "related_module" "public"."app_module" NOT NULL,
    "recommendation" "text" NOT NULL,
    "created_by" "uuid"
);


--
-- Name: TABLE "feedback_tickets"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."feedback_tickets" IS 'This table holds the tickets for Feedback & Ideas module';


--
-- Name: individual_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."individual_profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "first_name" "text" NOT NULL,
    "last_name" "text" NOT NULL,
    "username" "text" NOT NULL,
    "email" "text" NOT NULL,
    "image_url" "text" NOT NULL,
    "gender" "text" NOT NULL,
    "date_of_birth" "date" NOT NULL,
    "primary_sport_id" "uuid" NOT NULL,
    "sport_role" "public"."individual_role" NOT NULL,
    "sport_goal" "text",
    "sport_category" "text",
    "academy_category" "text",
    "sport_entity_id" "uuid",
    "field_position" "text",
    "strong_foot" "text",
    "height_cm" integer,
    "player_status" "text",
    "coach_role" "text",
    "coach_certifications" "jsonb",
    "referee_categories" "jsonb",
    "referee_match_types" "jsonb",
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "country_id" smallint NOT NULL,
    "city_id" smallint,
    CONSTRAINT "chk_coach_certifications_schema" CHECK ("extensions"."jsonb_matches_schema"('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true

            }'::json, "coach_certifications")),
    CONSTRAINT "chk_gender" CHECK (("gender" = ANY (ARRAY['male'::"text", 'female'::"text", 'other'::"text"]))),
    CONSTRAINT "chk_player_status" CHECK (("player_status" = ANY (ARRAY['active'::"text", 'pause'::"text", 'injured'::"text", 'looking'::"text", 'suspended'::"text", 'free'::"text"]))),
    CONSTRAINT "chk_referee_categories_schema" CHECK ("extensions"."jsonb_matches_schema"('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, "referee_categories")),
    CONSTRAINT "chk_referee_match_types_schema" CHECK ("extensions"."jsonb_matches_schema"('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, "referee_match_types")),
    CONSTRAINT "chk_sport_category" CHECK (("sport_category" = ANY (ARRAY['adult'::"text", 'academy'::"text"]))),
    CONSTRAINT "chk_sport_goal" CHECK (("sport_goal" = ANY (ARRAY['official'::"text", 'for_fun'::"text"]))),
    CONSTRAINT "chk_strong_foot" CHECK (("strong_foot" = ANY (ARRAY['left'::"text", 'right'::"text", 'both'::"text"])))
);


--
-- Name: TABLE "individual_profiles"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."individual_profiles" IS 'Extended profile for individual users with role-specific data and JSON validation';


--
-- Name: medical_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."medical_reports" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "team_id" "uuid" NOT NULL,
    "member_id" "uuid" NOT NULL,
    "severity" "public"."medical_severity" NOT NULL,
    "cause" "public"."session_type" NOT NULL,
    "injury_date" timestamp with time zone NOT NULL,
    "recovery_date" timestamp with time zone,
    "report" "text" DEFAULT ''::"text" NOT NULL
);


--
-- Name: members_evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."members_evaluations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "member_id" "uuid" NOT NULL,
    "text" "text",
    "last_updated" timestamp with time zone DEFAULT "now"() NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "team_id" "uuid" NOT NULL
);


--
-- Name: message_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."message_attachments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "message_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "type" "public"."attachment_type" NOT NULL,
    "url" "text" NOT NULL,
    "mime_type" "text" NOT NULL,
    "size" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- Name: TABLE "message_attachments"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."message_attachments" IS 'Stores file attachments associated with messages';


--
-- Name: COLUMN "message_attachments"."size"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."message_attachments"."size" IS 'File size in bytes';


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "chat_id" "uuid" NOT NULL,
    "created_by" "uuid" DEFAULT "public"."profile_id"() NOT NULL,
    "content" "text" DEFAULT ''::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


--
-- Name: TABLE "messages"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."messages" IS 'Stores individual messages within chats';


--
-- Name: session_invitations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_invitations" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "session_id" "uuid" NOT NULL,
    "member_id" "uuid" NOT NULL,
    "team_id" "uuid" NOT NULL,
    "status" "public"."session_invitation_status" DEFAULT 'pending'::"public"."session_invitation_status" NOT NULL,
    "updated_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL,
    "created_at" timestamp with time zone DEFAULT ("now"() AT TIME ZONE 'utc'::"text") NOT NULL
);


--
-- Name: TABLE "session_invitations"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."session_invitations" IS 'Tracks session invitations sent to team members';


--
-- Name: COLUMN "session_invitations"."id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."session_invitations"."id" IS 'Unique identifier for the invitation';


--
-- Name: COLUMN "session_invitations"."session_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."session_invitations"."session_id" IS 'Reference to the session';


--
-- Name: COLUMN "session_invitations"."member_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."session_invitations"."member_id" IS 'Reference to the invited team member';


--
-- Name: COLUMN "session_invitations"."team_id"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."session_invitations"."team_id" IS 'Reference to the team';


--
-- Name: COLUMN "session_invitations"."status"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."session_invitations"."status" IS 'Current status of the invitation (pending, accepted, declined)';


--
-- Name: session_report_attendance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_report_attendance" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "report_id" "uuid" NOT NULL,
    "member_id" "uuid" NOT NULL,
    "status" "public"."attendance_report_status" NOT NULL
);


--
-- Name: session_report_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_report_comments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "report_id" "uuid" NOT NULL,
    "comment" "text" NOT NULL
);


--
-- Name: session_report_composition; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_report_composition" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "report_id" "uuid" NOT NULL,
    "substitutes" "uuid"[] NOT NULL,
    "positions" "jsonb" NOT NULL,
    "formation_name" "text" DEFAULT ''::"text" NOT NULL
);


--
-- Name: COLUMN "session_report_composition"."formation_name"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."session_report_composition"."formation_name" IS 'The name of the formation like 4-4-2, to be able to allocate the positioned into it on screen';


--
-- Name: session_report_game_stats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_report_game_stats" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "report_id" "uuid" NOT NULL,
    "events" "jsonb" DEFAULT '[]'::"jsonb" NOT NULL
);


--
-- Name: session_report_ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_report_ratings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "report_id" "uuid" NOT NULL,
    "member_id" "uuid" NOT NULL,
    "rating" numeric(3,1) NOT NULL,
    CONSTRAINT "chk_rating_precision" CHECK ((("rating" % 0.5) = (0)::numeric)),
    CONSTRAINT "chk_rating_range" CHECK ((("rating" >= (0)::numeric) AND ("rating" <= (10)::numeric)))
);


--
-- Name: session_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."session_reports" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "session_id" "uuid" NOT NULL,
    "is_completed" boolean DEFAULT false NOT NULL
);


--
-- Name: sport_entity_profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sport_entity_profiles" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "profile_id" "uuid" NOT NULL,
    "entity_type" "public"."sport_entity_type" NOT NULL,
    "entity_name" "text" NOT NULL,
    "username" "text" NOT NULL,
    "image_url" "text" NOT NULL,
    "address" "jsonb" NOT NULL,
    "primary_sport_id" "uuid" NOT NULL,
    "contact_first_name" "text" NOT NULL,
    "contact_last_name" "text" NOT NULL,
    "contact_email" "text" NOT NULL,
    "contact_phone" "text" NOT NULL,
    "contact_website" "text",
    "club_categories" "jsonb",
    "federation_category" "text",
    "country_id" smallint NOT NULL,
    "city_id" smallint,
    "youth_leagues" "jsonb",
    "adult_men_divisions" "jsonb",
    "adult_women_divisions" "jsonb",
    CONSTRAINT "chk_address_schema" CHECK ("extensions"."jsonb_matches_schema"('{
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
            }'::json, "address")),
    CONSTRAINT "chk_club_categories_schema" CHECK ("extensions"."jsonb_matches_schema"('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, "club_categories"))
);


--
-- Name: TABLE "sport_entity_profiles"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."sport_entity_profiles" IS 'Extended profile for sport entities with type-specific data and JSON validation';


--
-- Name: sports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."sports" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "code" "text",
    "category" "text",
    "is_team_sport" boolean DEFAULT true,
    "min_players_per_team" smallint,
    "max_players_per_team" smallint,
    "is_supported" boolean DEFAULT false NOT NULL,
    "icon_url" "text"
);


--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."support_tickets" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "subject" "text" NOT NULL,
    "message" "text" NOT NULL,
    "created_by" "uuid"
);


--
-- Name: TABLE "support_tickets"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE "public"."support_tickets" IS 'This table holds the tickets for Support & Contact module';


--
-- Name: team_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE "public"."team_sessions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "team_id" "uuid" NOT NULL,
    "opponent_team_id" "uuid",
    "turf" "public"."turf",
    "type" "public"."session_type" NOT NULL,
    "name" "text" NOT NULL,
    "appointment_datetime" timestamp with time zone NOT NULL,
    "start_time" timestamp with time zone NOT NULL,
    "end_time" timestamp with time zone NOT NULL,
    "description" "text" DEFAULT ''::"text" NOT NULL,
    "location" "jsonb" NOT NULL,
    "invitation_status" "public"."session_invitation_status",
    "attendance_hidden" boolean DEFAULT false
);


--
-- Name: COLUMN "team_sessions"."attendance_hidden"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN "public"."team_sessions"."attendance_hidden" IS 'If true, attendance will not be shown to players';


--
-- Name: chat_members chat_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."chat_members"
    ADD CONSTRAINT "chat_members_pkey" PRIMARY KEY ("chat_id", "profile_id");


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."chats"
    ADD CONSTRAINT "chats_pkey" PRIMARY KEY ("id");


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cities"
    ADD CONSTRAINT "cities_pkey" PRIMARY KEY ("id");


--
-- Name: countries countries_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_code_key" UNIQUE ("code");


--
-- Name: countries countries_emoji_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_emoji_key" UNIQUE ("emoji");


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_pkey" PRIMARY KEY ("id");


--
-- Name: feedback_tickets feedback_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."feedback_tickets"
    ADD CONSTRAINT "feedback_tickets_pkey" PRIMARY KEY ("id");


--
-- Name: individual_profiles individual_profiles_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_email_key" UNIQUE ("email");


--
-- Name: individual_profiles individual_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_pkey" PRIMARY KEY ("id");


--
-- Name: individual_profiles individual_profiles_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_profile_id_key" UNIQUE ("profile_id");


--
-- Name: individual_profiles individual_profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_username_key" UNIQUE ("username");


--
-- Name: medical_reports medical_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."medical_reports"
    ADD CONSTRAINT "medical_reports_pkey" PRIMARY KEY ("id");


--
-- Name: members_evaluations members_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."members_evaluations"
    ADD CONSTRAINT "members_evaluations_pkey" PRIMARY KEY ("id");


--
-- Name: message_attachments message_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."message_attachments"
    ADD CONSTRAINT "message_attachments_pkey" PRIMARY KEY ("id");


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_pkey" PRIMARY KEY ("id");


--
-- Name: opportunities opportunities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunities"
    ADD CONSTRAINT "opportunities_pkey" PRIMARY KEY ("id");


--
-- Name: opportunity_applications opportunity_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunity_applications"
    ADD CONSTRAINT "opportunity_applications_pkey" PRIMARY KEY ("id");


--
-- Name: opportunity_requirements opportunity_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunity_requirements"
    ADD CONSTRAINT "opportunity_requirements_pkey" PRIMARY KEY ("id");


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_pkey" PRIMARY KEY ("id");


--
-- Name: saved_opportunities saved_opportunities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."saved_opportunities"
    ADD CONSTRAINT "saved_opportunities_pkey" PRIMARY KEY ("profile_id", "opportunity_id");


--
-- Name: session_invitations session_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_invitations"
    ADD CONSTRAINT "session_invitations_pkey" PRIMARY KEY ("id");


--
-- Name: session_report_attendance session_report_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_attendance"
    ADD CONSTRAINT "session_report_attendance_pkey" PRIMARY KEY ("id");


--
-- Name: session_report_attendance session_report_attendance_unique_report_member; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_attendance"
    ADD CONSTRAINT "session_report_attendance_unique_report_member" UNIQUE ("report_id", "member_id");


--
-- Name: session_report_comments session_report_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_comments"
    ADD CONSTRAINT "session_report_comments_pkey" PRIMARY KEY ("id");


--
-- Name: session_report_composition session_report_composition_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_composition"
    ADD CONSTRAINT "session_report_composition_pkey" PRIMARY KEY ("id");


--
-- Name: session_report_game_stats session_report_game_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_game_stats"
    ADD CONSTRAINT "session_report_game_stats_pkey" PRIMARY KEY ("id");


--
-- Name: session_report_ratings session_report_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_ratings"
    ADD CONSTRAINT "session_report_ratings_pkey" PRIMARY KEY ("id");


--
-- Name: session_reports session_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_reports"
    ADD CONSTRAINT "session_reports_pkey" PRIMARY KEY ("id");


--
-- Name: sport_entity_profiles sport_entity_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_pkey" PRIMARY KEY ("id");


--
-- Name: sport_entity_profiles sport_entity_profiles_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_profile_id_key" UNIQUE ("profile_id");


--
-- Name: sport_entity_profiles sport_entity_profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_username_key" UNIQUE ("username");


--
-- Name: sports sports_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sports"
    ADD CONSTRAINT "sports_code_key" UNIQUE ("code");


--
-- Name: sports sports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sports"
    ADD CONSTRAINT "sports_pkey" PRIMARY KEY ("id");


--
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."support_tickets"
    ADD CONSTRAINT "support_tickets_pkey" PRIMARY KEY ("id");


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."team_members"
    ADD CONSTRAINT "team_members_pkey" PRIMARY KEY ("id");


--
-- Name: team_sessions team_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."team_sessions"
    ADD CONSTRAINT "team_sessions_pkey" PRIMARY KEY ("id");


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."teams"
    ADD CONSTRAINT "teams_pkey" PRIMARY KEY ("id");


--
-- Name: session_report_comments unique_report_id; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_comments"
    ADD CONSTRAINT "unique_report_id" UNIQUE ("report_id");


--
-- Name: opportunity_applications uq_opportunity_applications_user_opportunity; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunity_applications"
    ADD CONSTRAINT "uq_opportunity_applications_user_opportunity" UNIQUE ("opportunity_id", "applicant_id");


--
-- Name: idx_chat_members_chat_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_chat_members_chat_id" ON "public"."chat_members" USING "btree" ("chat_id");


--
-- Name: idx_chat_members_profile_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_chat_members_profile_id" ON "public"."chat_members" USING "btree" ("profile_id");


--
-- Name: idx_cities_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cities_country_id" ON "public"."cities" USING "btree" ("country_id");


--
-- Name: idx_cities_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cities_location" ON "public"."cities" USING "btree" ("latitude", "longitude");


--
-- Name: idx_cities_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_cities_name" ON "public"."cities" USING "btree" ("name");


--
-- Name: idx_countries_location; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_countries_location" ON "public"."countries" USING "btree" ("latitude", "longitude");


--
-- Name: idx_countries_translations; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_countries_translations" ON "public"."countries" USING "gin" ("translations");


--
-- Name: idx_message_attachments_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_message_attachments_message_id" ON "public"."message_attachments" USING "btree" ("message_id");


--
-- Name: idx_messages_chat_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_messages_chat_id" ON "public"."messages" USING "btree" ("chat_id");


--
-- Name: idx_messages_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_messages_created_at" ON "public"."messages" USING "btree" ("created_at" DESC);


--
-- Name: idx_messages_created_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "idx_messages_created_by" ON "public"."messages" USING "btree" ("created_by");


--
-- Name: session_report_composition trg_validate_composition; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "trg_validate_composition" BEFORE INSERT OR UPDATE ON "public"."session_report_composition" FOR EACH ROW EXECUTE FUNCTION "public"."validate_composition"();


--
-- Name: messages trigger_broadcast_new_message; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "trigger_broadcast_new_message" AFTER INSERT ON "public"."messages" FOR EACH ROW EXECUTE FUNCTION "public"."broadcast_new_message"();


--
-- Name: individual_profiles trigger_update_individual_profile_generated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "trigger_update_individual_profile_generated" AFTER INSERT OR UPDATE OF "first_name", "last_name", "image_url" ON "public"."individual_profiles" FOR EACH ROW EXECUTE FUNCTION "public"."update_profile_generated_columns"();


--
-- Name: sport_entity_profiles trigger_update_sport_entity_profile_generated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "trigger_update_sport_entity_profile_generated" AFTER INSERT OR UPDATE OF "entity_name", "image_url" ON "public"."sport_entity_profiles" FOR EACH ROW EXECUTE FUNCTION "public"."update_profile_generated_columns"();


--
-- Name: members_evaluations update_evaluation_last_updated; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER "update_evaluation_last_updated" BEFORE UPDATE ON "public"."members_evaluations" FOR EACH ROW EXECUTE FUNCTION "public"."update_last_updated"();


--
-- Name: chat_members chat_members_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."chat_members"
    ADD CONSTRAINT "chat_members_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "public"."chats"("id") ON DELETE CASCADE;


--
-- Name: chat_members chat_members_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."chat_members"
    ADD CONSTRAINT "chat_members_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cities cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."cities"
    ADD CONSTRAINT "cities_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."countries"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: feedback_tickets feedback_tickets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."feedback_tickets"
    ADD CONSTRAINT "feedback_tickets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: session_report_attendance fk_member; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_attendance"
    ADD CONSTRAINT "fk_member" FOREIGN KEY ("member_id") REFERENCES "public"."team_members"("id") ON DELETE CASCADE;


--
-- Name: session_report_ratings fk_member; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_ratings"
    ADD CONSTRAINT "fk_member" FOREIGN KEY ("member_id") REFERENCES "public"."team_members"("id") ON DELETE CASCADE;


--
-- Name: session_reports fk_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_reports"
    ADD CONSTRAINT "fk_session" FOREIGN KEY ("session_id") REFERENCES "public"."team_sessions"("id") ON DELETE CASCADE;


--
-- Name: session_report_attendance fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_attendance"
    ADD CONSTRAINT "fk_session_report" FOREIGN KEY ("report_id") REFERENCES "public"."session_reports"("id") ON DELETE CASCADE;


--
-- Name: session_report_comments fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_comments"
    ADD CONSTRAINT "fk_session_report" FOREIGN KEY ("report_id") REFERENCES "public"."session_reports"("id") ON DELETE CASCADE;


--
-- Name: session_report_composition fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_composition"
    ADD CONSTRAINT "fk_session_report" FOREIGN KEY ("report_id") REFERENCES "public"."session_reports"("id") ON DELETE CASCADE;


--
-- Name: session_report_game_stats fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_game_stats"
    ADD CONSTRAINT "fk_session_report" FOREIGN KEY ("report_id") REFERENCES "public"."session_reports"("id") ON DELETE CASCADE;


--
-- Name: session_report_ratings fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_report_ratings"
    ADD CONSTRAINT "fk_session_report" FOREIGN KEY ("report_id") REFERENCES "public"."session_reports"("id") ON DELETE CASCADE;


--
-- Name: individual_profiles individual_profiles_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "public"."cities"("id");


--
-- Name: individual_profiles individual_profiles_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."countries"("id") ON UPDATE CASCADE;


--
-- Name: individual_profiles individual_profiles_primary_sport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_primary_sport_id_fkey" FOREIGN KEY ("primary_sport_id") REFERENCES "public"."sports"("id");


--
-- Name: individual_profiles individual_profiles_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: individual_profiles individual_profiles_sport_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."individual_profiles"
    ADD CONSTRAINT "individual_profiles_sport_entity_id_fkey" FOREIGN KEY ("sport_entity_id") REFERENCES "public"."sport_entity_profiles"("id") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: medical_reports medical_reports_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."medical_reports"
    ADD CONSTRAINT "medical_reports_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."team_members"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: medical_reports medical_reports_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."medical_reports"
    ADD CONSTRAINT "medical_reports_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: members_evaluations members_evaluations_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."members_evaluations"
    ADD CONSTRAINT "members_evaluations_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."team_members"("id") ON DELETE CASCADE;


--
-- Name: members_evaluations members_evaluations_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."members_evaluations"
    ADD CONSTRAINT "members_evaluations_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON DELETE CASCADE;


--
-- Name: members_evaluations members_evaluations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."members_evaluations"
    ADD CONSTRAINT "members_evaluations_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON DELETE CASCADE;


--
-- Name: message_attachments message_attachments_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."message_attachments"
    ADD CONSTRAINT "message_attachments_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_chat_id_fkey" FOREIGN KEY ("chat_id") REFERENCES "public"."chats"("id") ON DELETE CASCADE;


--
-- Name: messages messages_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: opportunities opportunities_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunities"
    ADD CONSTRAINT "opportunities_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: opportunity_applications opportunity_applications_applicant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunity_applications"
    ADD CONSTRAINT "opportunity_applications_applicant_id_fkey" FOREIGN KEY ("applicant_id") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: opportunity_applications opportunity_applications_opportunity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunity_applications"
    ADD CONSTRAINT "opportunity_applications_opportunity_id_fkey" FOREIGN KEY ("opportunity_id") REFERENCES "public"."opportunities"("id") ON DELETE CASCADE;


--
-- Name: opportunity_requirements opportunity_requirements_opportunity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."opportunity_requirements"
    ADD CONSTRAINT "opportunity_requirements_opportunity_id_fkey" FOREIGN KEY ("opportunity_id") REFERENCES "public"."opportunities"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profiles profiles_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "public"."cities"("id");


--
-- Name: profiles profiles_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."profiles"
    ADD CONSTRAINT "profiles_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."countries"("id") ON UPDATE CASCADE;


--
-- Name: saved_opportunities saved_opportunities_opportunity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."saved_opportunities"
    ADD CONSTRAINT "saved_opportunities_opportunity_id_fkey" FOREIGN KEY ("opportunity_id") REFERENCES "public"."opportunities"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: saved_opportunities saved_opportunities_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."saved_opportunities"
    ADD CONSTRAINT "saved_opportunities_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: session_invitations session_invitations_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_invitations"
    ADD CONSTRAINT "session_invitations_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."team_members"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: session_invitations session_invitations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_invitations"
    ADD CONSTRAINT "session_invitations_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "public"."team_sessions"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: session_invitations session_invitations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."session_invitations"
    ADD CONSTRAINT "session_invitations_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sport_entity_profiles sport_entity_profiles_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_city_id_fkey" FOREIGN KEY ("city_id") REFERENCES "public"."cities"("id");


--
-- Name: sport_entity_profiles sport_entity_profiles_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."countries"("id") ON UPDATE CASCADE;


--
-- Name: sport_entity_profiles sport_entity_profiles_primary_sport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_primary_sport_id_fkey" FOREIGN KEY ("primary_sport_id") REFERENCES "public"."sports"("id");


--
-- Name: sport_entity_profiles sport_entity_profiles_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."sport_entity_profiles"
    ADD CONSTRAINT "sport_entity_profiles_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: support_tickets support_tickets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."support_tickets"
    ADD CONSTRAINT "support_tickets_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: team_members team_members_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."team_members"
    ADD CONSTRAINT "team_members_member_id_fkey" FOREIGN KEY ("member_id") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: team_members team_members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."team_members"
    ADD CONSTRAINT "team_members_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: team_sessions team_sessions_opponent_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."team_sessions"
    ADD CONSTRAINT "team_sessions_opponent_team_id_fkey" FOREIGN KEY ("opponent_team_id") REFERENCES "public"."teams"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: team_sessions team_sessions_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."team_sessions"
    ADD CONSTRAINT "team_sessions_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id") ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: teams teams_associated_club_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."teams"
    ADD CONSTRAINT "teams_associated_club_fkey" FOREIGN KEY ("associated_club") REFERENCES "public"."sport_entity_profiles"("id") ON UPDATE CASCADE;


--
-- Name: teams teams_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY "public"."teams"
    ADD CONSTRAINT "teams_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."profiles"("id") ON UPDATE CASCADE;


--
-- Name: feedback_tickets Allow authenticated users to create their own support tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to create their own support tickets" ON "public"."feedback_tickets" FOR INSERT TO "authenticated" WITH CHECK (("created_by" = "public"."profile_id"()));


--
-- Name: support_tickets Allow authenticated users to create their own support tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to create their own support tickets" ON "public"."support_tickets" FOR INSERT TO "authenticated" WITH CHECK (("created_by" = ( SELECT "public"."profile_id"() AS "profile_id")));


--
-- Name: feedback_tickets Allow authenticated users to read their own support tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read their own support tickets" ON "public"."feedback_tickets" FOR SELECT TO "authenticated" USING (("created_by" = "public"."profile_id"()));


--
-- Name: support_tickets Allow authenticated users to read their own support tickets; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow authenticated users to read their own support tickets" ON "public"."support_tickets" FOR SELECT TO "authenticated" USING (("created_by" = ( SELECT "public"."profile_id"() AS "profile_id")));


--
-- Name: teams Allow delete by team admins only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow delete by team admins only" ON "public"."teams" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."team_members" "tm"
  WHERE (("tm"."team_id" = "teams"."id") AND ("tm"."member_id" = "public"."profile_id"()) AND ("tm"."is_admin" = true)))));


--
-- Name: team_members Allow insertions by team admins or team creators only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow insertions by team admins or team creators only" ON "public"."team_members" FOR INSERT TO "authenticated" WITH CHECK (((EXISTS ( SELECT 1
   FROM "public"."teams" "t"
  WHERE (("t"."id" = "team_members"."team_id") AND ("t"."created_by" = "public"."profile_id"())))) OR (EXISTS ( SELECT 1
   FROM "public"."team_members" "tm"
  WHERE (("tm"."team_id" = "tm"."team_id") AND ("tm"."is_admin" = true))))));


--
-- Name: medical_reports Allow team admin to have full access on reports; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow team admin to have full access on reports" ON "public"."medical_reports" TO "authenticated" USING (( SELECT "public"."is_user_team_admin"("medical_reports"."team_id") AS "is_user_team_admin")) WITH CHECK (( SELECT "public"."is_user_team_admin"("medical_reports"."team_id") AS "is_user_team_admin"));


--
-- Name: medical_reports Allow team members to delete their own reports; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow team members to delete their own reports" ON "public"."medical_reports" FOR DELETE USING ((( SELECT "public"."is_user_in_team"("medical_reports"."team_id") AS "is_user_in_team") AND (( SELECT "public"."get_profile_id_by_team_member"("medical_reports"."member_id") AS "get_profile_id_by_team_member") = ( SELECT "public"."profile_id"() AS "profile_id"))));


--
-- Name: medical_reports Allow team members to update their own reports; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow team members to update their own reports" ON "public"."medical_reports" FOR UPDATE TO "authenticated" USING ((( SELECT "public"."is_user_in_team"("medical_reports"."team_id") AS "is_user_in_team") AND (( SELECT "public"."get_profile_id_by_team_member"("medical_reports"."member_id") AS "get_profile_id_by_team_member") = ( SELECT "public"."profile_id"() AS "profile_id")))) WITH CHECK ((( SELECT "public"."is_user_in_team"("medical_reports"."team_id") AS "is_user_in_team") AND (( SELECT "public"."get_profile_id_by_team_member"("medical_reports"."member_id") AS "get_profile_id_by_team_member") = ( SELECT "public"."profile_id"() AS "profile_id"))));


--
-- Name: teams Allow team update by admin members only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow team update by admin members only" ON "public"."teams" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."team_members" "tm"
  WHERE (("tm"."team_id" = "teams"."id") AND ("tm"."member_id" = "public"."profile_id"()) AND ("tm"."is_admin" = true))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."team_members" "tm"
  WHERE (("tm"."team_id" = "teams"."id") AND ("tm"."member_id" = "public"."profile_id"()) AND ("tm"."is_admin" = true)))));


--
-- Name: team_members Allow update by team admins only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Allow update by team admins only" ON "public"."team_members" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."team_members" "tm"
  WHERE (("tm"."team_id" = "team_members"."team_id") AND ("tm"."member_id" = "public"."profile_id"()) AND ("tm"."is_admin" = true))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."team_members" "tm"
  WHERE (("tm"."team_id" = "team_members"."team_id") AND ("tm"."member_id" = "public"."profile_id"()) AND ("tm"."is_admin" = true)))));


--
-- Name: profiles Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users based on user_id" ON "public"."profiles" FOR DELETE TO "authenticated" USING ((( SELECT "public"."uid"() AS "uid") = "user_id"));


--
-- Name: saved_opportunities Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users based on user_id" ON "public"."saved_opportunities" FOR DELETE TO "authenticated" USING ((( SELECT "public"."profile_id"() AS "profile_id") = "profile_id"));


--
-- Name: opportunities Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON "public"."opportunities" FOR INSERT TO "authenticated" WITH CHECK (true);


--
-- Name: opportunity_applications Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON "public"."opportunity_applications" FOR INSERT TO "authenticated" WITH CHECK (true);


--
-- Name: profiles Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON "public"."profiles" FOR INSERT TO "authenticated" WITH CHECK (("public"."uid"() IS NOT NULL));


--
-- Name: saved_opportunities Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON "public"."saved_opportunities" FOR INSERT TO "authenticated" WITH CHECK (true);


--
-- Name: teams Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON "public"."teams" FOR INSERT TO "authenticated" WITH CHECK (true);


--
-- Name: opportunities Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all authenticated users" ON "public"."opportunities" FOR SELECT TO "authenticated" USING (true);


--
-- Name: opportunity_requirements Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all authenticated users" ON "public"."opportunity_requirements" FOR SELECT TO "authenticated" USING (true);


--
-- Name: team_members Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all authenticated users" ON "public"."team_members" FOR SELECT TO "authenticated" USING (true);


--
-- Name: teams Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all authenticated users" ON "public"."teams" FOR SELECT TO "authenticated" USING (true);


--
-- Name: cities Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON "public"."cities" FOR SELECT USING (true);


--
-- Name: countries Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON "public"."countries" FOR SELECT USING (true);


--
-- Name: individual_profiles Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON "public"."individual_profiles" FOR SELECT USING (true);


--
-- Name: sport_entity_profiles Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON "public"."sport_entity_profiles" FOR SELECT USING (true);


--
-- Name: sports Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON "public"."sports" FOR SELECT USING (true);


--
-- Name: opportunities Enable update for users based on profile_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users based on profile_id" ON "public"."opportunities" FOR UPDATE TO "authenticated" USING ((( SELECT "public"."profile_id"() AS "profile_id") = "created_by"));


--
-- Name: opportunity_applications Enable users to view their own data only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable users to view their own data only" ON "public"."opportunity_applications" FOR SELECT TO "authenticated" USING (((( SELECT "public"."profile_id"() AS "profile_id") = "applicant_id") OR ( SELECT ("public"."profile_id"() = ( SELECT "opportunities"."created_by"
           FROM "public"."opportunities"
          WHERE ("opportunities"."id" = "opportunity_applications"."opportunity_id"))))));


--
-- Name: saved_opportunities Enable users to view their own data only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable users to view their own data only" ON "public"."saved_opportunities" FOR SELECT TO "authenticated" USING ((( SELECT "public"."profile_id"() AS "profile_id") = "profile_id"));


--
-- Name: chat_members Users can add members to chats they belong to; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can add members to chats they belong to" ON "public"."chat_members" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."chat_members" "cm"
  WHERE (("cm"."chat_id" = "chat_members"."chat_id") AND ("cm"."profile_id" = "public"."profile_id"())))));


--
-- Name: chat_members Users can add themselves to chats; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can add themselves to chats" ON "public"."chat_members" FOR INSERT WITH CHECK (("profile_id" = "public"."profile_id"()));


--
-- Name: message_attachments Users can create attachments for their own messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create attachments for their own messages" ON "public"."message_attachments" FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."messages" "m"
  WHERE (("m"."id" = "message_attachments"."message_id") AND ("m"."created_by" = "public"."profile_id"())))));


--
-- Name: chats Users can create chats; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create chats" ON "public"."chats" FOR INSERT TO "authenticated" WITH CHECK (true);


--
-- Name: messages Users can create messages in chats they belong to; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create messages in chats they belong to" ON "public"."messages" FOR INSERT WITH CHECK ((("created_by" = "public"."profile_id"()) AND (EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "messages"."chat_id") AND ("chat_members"."profile_id" = "public"."profile_id"()))))));


--
-- Name: session_reports Users can create session reports for their team sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create session reports for their team sessions" ON "public"."session_reports" FOR INSERT TO "authenticated" WITH CHECK (("session_id" IN ( SELECT "ts"."id"
   FROM ("public"."team_sessions" "ts"
     JOIN "public"."team_members" "tm" ON (("ts"."team_id" = "tm"."team_id")))
  WHERE ("tm"."member_id" = "public"."profile_id"()))));


--
-- Name: message_attachments Users can delete attachments for their own messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete attachments for their own messages" ON "public"."message_attachments" FOR DELETE USING ((EXISTS ( SELECT 1
   FROM "public"."messages" "m"
  WHERE (("m"."id" = "message_attachments"."message_id") AND ("m"."created_by" = "public"."profile_id"())))));


--
-- Name: chats Users can delete chats they are members of; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete chats they are members of" ON "public"."chats" FOR DELETE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "chats"."id") AND ("chat_members"."profile_id" = "public"."profile_id"())))));


--
-- Name: messages Users can delete their own messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can delete their own messages" ON "public"."messages" FOR DELETE USING (("created_by" = "public"."profile_id"()));


--
-- Name: chat_members Users can remove themselves from chats; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can remove themselves from chats" ON "public"."chat_members" FOR DELETE USING (("profile_id" = "public"."profile_id"()));


--
-- Name: message_attachments Users can update attachments for their own messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update attachments for their own messages" ON "public"."message_attachments" FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM "public"."messages" "m"
  WHERE (("m"."id" = "message_attachments"."message_id") AND ("m"."created_by" = "public"."profile_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."messages" "m"
  WHERE (("m"."id" = "message_attachments"."message_id") AND ("m"."created_by" = "public"."profile_id"())))));


--
-- Name: chats Users can update chats they are members of; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update chats they are members of" ON "public"."chats" FOR UPDATE TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "chats"."id") AND ("chat_members"."profile_id" = "public"."profile_id"()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "chats"."id") AND ("chat_members"."profile_id" = "public"."profile_id"())))));


--
-- Name: session_reports Users can update session reports for their team sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update session reports for their team sessions" ON "public"."session_reports" FOR UPDATE TO "authenticated" USING (("session_id" IN ( SELECT "ts"."id"
   FROM ("public"."team_sessions" "ts"
     JOIN "public"."team_members" "tm" ON (("ts"."team_id" = "tm"."team_id")))
  WHERE ("tm"."member_id" = "public"."profile_id"()))));


--
-- Name: chat_members Users can update their own membership; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own membership" ON "public"."chat_members" FOR UPDATE USING (("profile_id" = "public"."profile_id"())) WITH CHECK (("profile_id" = "public"."profile_id"()));


--
-- Name: messages Users can update their own messages; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their own messages" ON "public"."messages" FOR UPDATE USING (("created_by" = "public"."profile_id"())) WITH CHECK ((("created_by" = "public"."profile_id"()) AND (EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "messages"."chat_id") AND ("chat_members"."profile_id" = "public"."profile_id"()))))));


--
-- Name: message_attachments Users can view attachments for messages they can see; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view attachments for messages they can see" ON "public"."message_attachments" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM ("public"."messages" "m"
     JOIN "public"."chat_members" "cm" ON (("m"."chat_id" = "cm"."chat_id")))
  WHERE (("m"."id" = "message_attachments"."message_id") AND ("cm"."profile_id" = "public"."profile_id"())))));


--
-- Name: chats Users can view chats they are members of; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view chats they are members of" ON "public"."chats" FOR SELECT TO "authenticated" USING ((EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "chats"."id") AND ("chat_members"."profile_id" = "public"."profile_id"())))));


--
-- Name: chat_members Users can view members of chats they belong to; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view members of chats they belong to" ON "public"."chat_members" FOR SELECT TO "authenticated" USING (("profile_id" = "public"."profile_id"()));


--
-- Name: messages Users can view messages in chats they belong to; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view messages in chats they belong to" ON "public"."messages" FOR SELECT USING ((EXISTS ( SELECT 1
   FROM "public"."chat_members"
  WHERE (("chat_members"."chat_id" = "messages"."chat_id") AND ("chat_members"."profile_id" = "public"."profile_id"())))));


--
-- Name: session_reports Users can view session reports for their team sessions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view session reports for their team sessions" ON "public"."session_reports" FOR SELECT USING (("session_id" IN ( SELECT "ts"."id"
   FROM ("public"."team_sessions" "ts"
     JOIN "public"."team_members" "tm" ON (("ts"."team_id" = "tm"."team_id")))
  WHERE ("tm"."member_id" = "public"."profile_id"()))));


--
-- Name: opportunity_requirements allow Update Opportunity Join Table by Creator; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow Update Opportunity Join Table by Creator" ON "public"."opportunity_requirements" FOR UPDATE TO "authenticated" USING ((( SELECT "opportunities"."created_by"
   FROM "public"."opportunities"
  WHERE ("opportunities"."id" = "opportunity_requirements"."opportunity_id")) = ( SELECT "public"."profile_id"() AS "profile_id")));


--
-- Name: session_invitations allow admins to create session invitations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow admins to create session invitations" ON "public"."session_invitations" FOR INSERT TO "authenticated" WITH CHECK (( SELECT "public"."is_user_team_admin"("session_invitations"."team_id") AS "is_user_team_admin"));


--
-- Name: medical_reports allow for team members to see; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow for team members to see" ON "public"."medical_reports" FOR SELECT TO "authenticated" USING (( SELECT "public"."is_user_in_team"("medical_reports"."team_id") AS "is_user_in_team"));


--
-- Name: session_invitations allow read access for members in team; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow read access for members in team" ON "public"."session_invitations" FOR SELECT TO "authenticated" USING (( SELECT "public"."is_user_in_team"("session_invitations"."team_id") AS "is_user_in_team"));


--
-- Name: profiles allow read when authenticated; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow read when authenticated" ON "public"."profiles" FOR SELECT TO "authenticated" USING (("public"."uid"() IS NOT NULL));


--
-- Name: medical_reports allow team member to create his own report; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allow team member to create his own report" ON "public"."medical_reports" FOR INSERT TO "authenticated" WITH CHECK ((( SELECT "public"."is_user_in_team"("medical_reports"."team_id") AS "is_user_in_team") AND (( SELECT "public"."get_profile_id_by_team_member"("medical_reports"."member_id") AS "get_profile_id_by_team_member") = ( SELECT "public"."profile_id"() AS "profile_id"))));


--
-- Name: team_sessions allows insertion if team admin; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "allows insertion if team admin" ON "public"."team_sessions" FOR INSERT TO "authenticated" WITH CHECK (( SELECT "public"."is_user_team_admin"("team_sessions"."team_id") AS "is_user_team_admin"));


--
-- Name: chat_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."chat_members" ENABLE ROW LEVEL SECURITY;

--
-- Name: chats; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."chats" ENABLE ROW LEVEL SECURITY;

--
-- Name: cities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."cities" ENABLE ROW LEVEL SECURITY;

--
-- Name: countries; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."countries" ENABLE ROW LEVEL SECURITY;

--
-- Name: team_sessions enable read access for members inside team; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "enable read access for members inside team" ON "public"."team_sessions" FOR SELECT TO "authenticated" USING (( SELECT "public"."is_user_in_team"("team_sessions"."team_id") AS "is_user_in_team"));


--
-- Name: profiles enable update based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "enable update based on user_id" ON "public"."profiles" FOR UPDATE TO "authenticated" USING (("public"."uid"() = "user_id"));


--
-- Name: feedback_tickets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."feedback_tickets" ENABLE ROW LEVEL SECURITY;

--
-- Name: individual_profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."individual_profiles" ENABLE ROW LEVEL SECURITY;

--
-- Name: medical_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."medical_reports" ENABLE ROW LEVEL SECURITY;

--
-- Name: message_attachments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."message_attachments" ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."messages" ENABLE ROW LEVEL SECURITY;

--
-- Name: opportunities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."opportunities" ENABLE ROW LEVEL SECURITY;

--
-- Name: opportunity_applications; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."opportunity_applications" ENABLE ROW LEVEL SECURITY;

--
-- Name: opportunity_requirements; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."opportunity_requirements" ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."profiles" ENABLE ROW LEVEL SECURITY;

--
-- Name: saved_opportunities; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."saved_opportunities" ENABLE ROW LEVEL SECURITY;

--
-- Name: session_invitations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."session_invitations" ENABLE ROW LEVEL SECURITY;

--
-- Name: session_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."session_reports" ENABLE ROW LEVEL SECURITY;

--
-- Name: sport_entity_profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."sport_entity_profiles" ENABLE ROW LEVEL SECURITY;

--
-- Name: sports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."sports" ENABLE ROW LEVEL SECURITY;

--
-- Name: support_tickets; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."support_tickets" ENABLE ROW LEVEL SECURITY;

--
-- Name: team_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."team_members" ENABLE ROW LEVEL SECURITY;

--
-- Name: team_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."team_sessions" ENABLE ROW LEVEL SECURITY;

--
-- Name: teams; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE "public"."teams" ENABLE ROW LEVEL SECURITY;

--
-- PostgreSQL database dump complete
--

\unrestrict yacrkcAppHFahcHE3yXhJp52BUb3VXnzVQanGfxeRCvkKfOAqaHLp7qxdPXl4Ej
