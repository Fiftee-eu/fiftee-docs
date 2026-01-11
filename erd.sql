--
-- PostgreSQL database dump
--

\restrict 4hlRe2dnLcNjCb9cP55nnMq87Vd81Io1keptP0MnhtcgYfUqDWYZK6idiFmMMkc

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7 (Homebrew)

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
-- Name: notifications; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA notifications;


ALTER SCHEMA notifications OWNER TO postgres;

--
-- Name: profiles; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA profiles;


ALTER SCHEMA profiles OWNER TO postgres;

--
-- Name: SCHEMA profiles; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA profiles IS 'Schema for profile management functions supporting multi-profile and multi-role system';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: channel_type; Type: TYPE; Schema: notifications; Owner: postgres
--

CREATE TYPE notifications.channel_type AS ENUM (
    'email',
    'sms',
    'push'
);


ALTER TYPE notifications.channel_type OWNER TO postgres;

--
-- Name: delivery_type; Type: TYPE; Schema: notifications; Owner: postgres
--

CREATE TYPE notifications.delivery_type AS ENUM (
    'immediate',
    'scheduled',
    'recurring'
);


ALTER TYPE notifications.delivery_type OWNER TO postgres;

--
-- Name: app_module; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.app_module AS ENUM (
    'onboarding',
    'home',
    'opportunity',
    'my_teams',
    'my_zone',
    'profile',
    'messaging',
    'search_engine'
);


ALTER TYPE public.app_module OWNER TO postgres;

--
-- Name: TYPE app_module; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.app_module IS 'This Enum contains the app modules (features)';


--
-- Name: application_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.application_status AS ENUM (
    'pending',
    'accepted',
    'rejected'
);


ALTER TYPE public.application_status OWNER TO postgres;

--
-- Name: TYPE application_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.application_status IS 'Status tracking for user applications to opportunities throughout the review process';


--
-- Name: attachment_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attachment_type AS ENUM (
    'image',
    'video',
    'document',
    'audio',
    'binary'
);


ALTER TYPE public.attachment_type OWNER TO postgres;

--
-- Name: attendance_report_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendance_report_status AS ENUM (
    'justified_absence',
    'unjustified_absence',
    'justified_lateness',
    'unjustified_lateness'
);


ALTER TYPE public.attendance_report_status OWNER TO postgres;

--
-- Name: individual_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.individual_role AS ENUM (
    'player',
    'coach',
    'referee',
    'fan',
    'club_staff'
);


ALTER TYPE public.individual_role OWNER TO postgres;

--
-- Name: medical_severity; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.medical_severity AS ENUM (
    'minor',
    'moderate',
    'severe'
);


ALTER TYPE public.medical_severity OWNER TO postgres;

--
-- Name: opportunity_category; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.opportunity_category AS ENUM (
    'meet_and_play',
    'recruitments',
    'tests',
    'internships',
    'tournaments',
    'volunteering',
    'student_opportunities',
    'professional_opportunities'
);


ALTER TYPE public.opportunity_category OWNER TO postgres;

--
-- Name: TYPE opportunity_category; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.opportunity_category IS 'Categories defining the type and purpose of opportunities available on the platform';


--
-- Name: opportunity_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.opportunity_status AS ENUM (
    'published',
    'closed',
    'expired',
    'cancelled'
);


ALTER TYPE public.opportunity_status OWNER TO postgres;

--
-- Name: TYPE opportunity_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.opportunity_status IS 'Current lifecycle status of an opportunity from creation to completion';


--
-- Name: profile_creation_result; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.profile_creation_result AS (
	success boolean,
	profile_id uuid,
	error_code text,
	error_message text
);


ALTER TYPE public.profile_creation_result OWNER TO postgres;

--
-- Name: TYPE profile_creation_result; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.profile_creation_result IS 'Return type for profile creation functions with success status and error details';


--
-- Name: session_invitation_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.session_invitation_status AS ENUM (
    'pending',
    'accepted',
    'rejected'
);


ALTER TYPE public.session_invitation_status OWNER TO postgres;

--
-- Name: session_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.session_type AS ENUM (
    'training',
    'game',
    'other'
);


ALTER TYPE public.session_type OWNER TO postgres;

--
-- Name: sport_entity_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sport_entity_type AS ENUM (
    'club',
    'federation'
);


ALTER TYPE public.sport_entity_type OWNER TO postgres;

--
-- Name: turf; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.turf AS ENUM (
    'home',
    'away',
    'neutral'
);


ALTER TYPE public.turf OWNER TO postgres;

--
-- Name: user_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_type AS ENUM (
    'private_profile',
    'sport_entity',
    'media',
    'company'
);


ALTER TYPE public.user_type OWNER TO postgres;

--
-- Name: TYPE user_type; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TYPE public.user_type IS 'User Types Enum';


--
-- Name: accepted_session_reminder(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.accepted_session_reminder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_member_preferences jsonb;
    v_session_appointment_datetime timestamp with time zone;
    v_session_start_time timestamp with time zone;
    v_session_name text;
    v_session_location jsonb;
    v_team_id uuid;
    v_member_profile_id uuid;
    v_params jsonb;
    v_schedule_time timestamp;
BEGIN
    -- Only proceed if status changed to 'accepted'
    IF OLD.status = 'accepted'::session_invitation_status OR NEW.status != 'accepted'::session_invitation_status THEN
        RETURN NEW;
    END IF;

    -- Get session details
    SELECT ts.appointment_datetime, ts.start_time, ts.name, ts.location, ts.team_id
    INTO v_session_appointment_datetime, v_session_start_time, v_session_name, v_session_location, v_team_id
    FROM public.team_sessions ts
    WHERE ts.id = NEW.session_id;

    -- If session not found or appointment_datetime is NULL, return early
    IF v_session_appointment_datetime IS NULL THEN
        RETURN NEW;
    END IF;

    -- Calculate schedule time (6 hours before appointment)
    v_schedule_time := (v_session_appointment_datetime - interval '6 hours')::timestamp;

    -- Only schedule if the appointment is at least 6 hours in the future
    IF v_schedule_time <= NOW() THEN
        RETURN NEW;
    END IF;

    -- Get the profile_id for the member who accepted
    SELECT tm.member_id INTO v_member_profile_id
    FROM public.team_members tm
    WHERE tm.id = NEW.member_id;

    -- If member not found, return early
    IF v_member_profile_id IS NULL THEN
        RETURN NEW;
    END IF;

    -- Get notification preferences for the member who accepted
    SELECT notifications.profile_notifications_preferences(v_member_profile_id)
    INTO v_member_preferences;

    -- If no preferences found, return early
    IF v_member_preferences IS NULL THEN
        RETURN NEW;
    END IF;

    -- Build notification parameters
    SELECT jsonb_build_object(
        'SessionName', v_session_name,
        'StartTime', v_session_start_time::time,
        'MeetTime', v_session_appointment_datetime::time,
        'Venue', v_session_location->>'address'
    )
    INTO v_params;

    -- Schedule notification for the member who accepted
    PERFORM notifications.schedule_notification(
        p_template_id := 'session_reminder_accepted',
        p_token := v_member_preferences->>'token',
        p_preferred_language := v_member_preferences->>'preferred_language',
        p_route := '/teams/' || v_team_id || '/planning/' || NEW.session_id,
        p_schedule_time := v_schedule_time,
        p_params := v_params
    );

    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.accepted_session_reminder() OWNER TO postgres;

--
-- Name: application_status_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.application_status_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_applicant_preferences JSONB;
    v_route TEXT := '/opportunities/zone?tabIndex=1';
BEGIN

    SELECT notifications.profile_notifications_preferences(NEW.applicant_id) INTO v_applicant_preferences;

    IF NEW.status = 'accepted' THEN 
        PERFORM notifications.send_notification(
            p_template_id := 'application_accepted',
            p_token := v_applicant_preferences->>'token',
            p_route := v_route,
            p_preferred_language := v_applicant_preferences->>'preferred_language'
        );
    ELSIF NEW.status = 'rejected' THEN
        PERFORM notifications.send_notification(
            p_template_id := 'application_declined',
            p_token := v_applicant_preferences->>'token',
            p_route := v_route,
            p_preferred_language := v_applicant_preferences->>'preferred_language'
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.application_status_notification() OWNER TO postgres;

--
-- Name: member_session_invitation_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.member_session_invitation_notification() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_member_preferences JSONB[];
    v_session_id UUID;
    v_team_id UUID;
    v_invited_member_ids UUID[];
    v_session_record RECORD;
    v_params JSONB;
BEGIN
    RAISE LOG '[DEBUG] Member session invitation notification triggered';

    -- Process all recently created session invitations (within last 5 seconds)
    -- Since FOR EACH STATEMENT trigger fires after all rows are inserted,
    -- we query for recently created pending invitations
    FOR v_session_record IN
        SELECT DISTINCT 
            si.session_id, 
            si.team_id 
        FROM public.session_invitations si
        WHERE si.status = 'pending'::session_invitation_status
        AND si.created_at >= NOW() - INTERVAL '5 seconds'
    LOOP
        v_session_id := v_session_record.session_id;
        v_team_id := v_session_record.team_id;

        RAISE LOG '[DEBUG] Processing session_id: %, team_id: %', v_session_id, v_team_id;

        -- Get all profile IDs for members invited to this session
        -- session_invitations.member_id references team_members.id,
        -- so we need to join to get team_members.member_id (which is the profile_id)
        SELECT ARRAY_AGG(DISTINCT tm.member_id) INTO v_invited_member_ids
        FROM public.session_invitations si
        INNER JOIN public.team_members tm ON si.member_id = tm.id
        WHERE si.session_id = v_session_id
        AND si.status = 'pending'::session_invitation_status
        AND si.created_at >= NOW() - INTERVAL '5 seconds';

        -- If no members found, skip to next session
        IF v_invited_member_ids IS NULL OR array_length(v_invited_member_ids, 1) = 0 THEN
            CONTINUE;
        END IF;

        RAISE LOG '[DEBUG] Found % invited members for session %', array_length(v_invited_member_ids, 1), v_session_id;

        -- Get notification preferences for all invited members (using profile_id)
        SELECT ARRAY_AGG(notifications.profile_notifications_preferences(profile_id))
        INTO v_member_preferences
        FROM UNNEST(v_invited_member_ids) AS profile_id
        WHERE notifications.profile_notifications_preferences(profile_id) IS NOT NULL;

        -- If no preferences found, skip to next session
        IF v_member_preferences IS NULL OR array_length(v_member_preferences, 1) = 0 THEN
            RAISE LOG '[DEBUG] No notification preferences found for invited members in session %', v_session_id;
            CONTINUE;
        END IF;

        SELECT jsonb_build_object(
            'SessionName', ts.name,
            'date', ts.appointment_datetime::date,
            'time', ts.appointment_datetime::time
        )
        INTO v_params
        FROM public.team_sessions ts
        WHERE ts.id = v_session_id;

        RAISE LOG '[DEBUG] Notification parameters: %', v_params;

        -- Send notifications to all invited members for this session
        PERFORM notifications.send_notification(
            p_template_id := 'session_invitation',
            p_targets := v_member_preferences,
            p_route := '/teams/' || v_team_id || '/planning/' || v_session_id,
            p_params := v_params
        );

        RAISE LOG '[DEBUG] Sent session invitation notifications to % members for session %', 
            array_length(v_member_preferences, 1), v_session_id;
    END LOOP;

    RETURN NULL;
END;
$$;


ALTER FUNCTION notifications.member_session_invitation_notification() OWNER TO postgres;

--
-- Name: new_applicant_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.new_applicant_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE 
    v_applicant_token TEXT;
    v_applicant_preferred_language TEXT;
    v_owner_token TEXT;
    v_owner_preferred_language TEXT;
    v_applicants_route TEXT;
BEGIN

    SELECT fcm_token, preferred_language INTO v_applicant_token, v_applicant_preferred_language FROM profiles WHERE id = NEW.applicant_id;
    SELECT fcm_token, preferred_language INTO v_owner_token, v_owner_preferred_language FROM profiles WHERE id = (SELECT created_by FROM opportunities WHERE id = NEW.opportunity_id);
    v_applicants_route := '/opportunities/' || NEW.opportunity_id || '/applicants';

    PERFORM notifications.send_notification('application_under_review', v_applicant_token, '/opportunities/zone', v_applicant_preferred_language);

    PERFORM notifications.send_notification('new_candidate_applied', v_owner_token, v_applicants_route, v_owner_preferred_language);
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.new_applicant_notification() OWNER TO postgres;

--
-- Name: new_chat_message_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.new_chat_message_notification() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_chat_preferences JSONB[];
    v_chat_type TEXT;
BEGIN
    SELECT array_agg(notifications.profile_notifications_preferences(profile_id)) INTO v_chat_preferences
    FROM public.chat_members
    WHERE chat_id = NEW.chat_id AND profile_id != NEW.created_by;

    SELECT config->>'chat_type' INTO v_chat_type
    FROM public.chats
    WHERE id = NEW.chat_id;

    -- Set notification template based on chat type
    CASE v_chat_type
        WHEN 'direct' THEN
            -- For direct messages, use direct message template
            PERFORM notifications.send_notification(
                p_template_id := 'new_direct_message',
                p_targets := v_chat_preferences,
                p_route := '/messages/' || NEW.chat_id,
                p_params := jsonb_build_object(
                    'SenderName', (SELECT display_name FROM profiles WHERE id = NEW.created_by),
                    'MessagePreview', NEW.content
                )
            );
        WHEN 'team' THEN
            -- For team messages, use team message template
            PERFORM notifications.send_notification(
                p_template_id := 'new_team_message',
                p_targets := v_chat_preferences,
                p_route := '/messages/' || NEW.chat_id,
                p_params := jsonb_build_object(
                    'SenderName', (SELECT display_name FROM profiles WHERE id = NEW.created_by),
                    'MessagePreview', NEW.content,
                    'GroupName', (SELECT config->>'team_name' FROM public.chats WHERE id = NEW.chat_id)
                )
            );
        WHEN 'channel' THEN
            -- For channel messages, use channel message template
            PERFORM notifications.send_notification(
                p_template_id := 'new_channel_message',
                p_targets := v_chat_preferences,
                p_route := '/messages/' || NEW.chat_id,
                p_params := jsonb_build_object(
                    'ChannelName', (SELECT config->>'channel_name' FROM public.chats WHERE id = NEW.chat_id),
                    'MessagePreview', NEW.content
                )
            );
        ELSE
            RAISE EXCEPTION 'Unknown chat type: %', v_chat_type;
    END CASE;

    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.new_chat_message_notification() OWNER TO postgres;

--
-- Name: new_medical_report_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.new_medical_report_notification() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_admins_preferences JSONB[];
    v_player_name TEXT;
BEGIN
    SELECT display_name INTO v_player_name
    FROM profiles WHERE
    id = (SELECT member_id FROM public.team_members WHERE id = NEW.member_id);

    SELECT array_agg(notifications.profile_notifications_preferences(member_id)) INTO v_admins_preferences
    FROM public.team_members
    WHERE team_id = NEW.team_id
    AND is_admin = TRUE;

    PERFORM notifications.send_notification(
        p_template_id := 'medical_note_submitted',
        p_targets := v_admins_preferences,
        p_route := '/teams/' || NEW.team_id || '/medical/' || NEW.id,
        p_params := jsonb_build_object(
            'PlayerName', v_player_name
        )
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.new_medical_report_notification() OWNER TO postgres;

--
-- Name: new_member_added_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.new_member_added_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_team_id UUID;
    v_team_name TEXT;
    v_existing_members UUID[];
    v_team_preferences JSONB[];
    v_new_members_count INTEGER;
BEGIN
    SELECT team_id INTO v_team_id FROM inserted_batch LIMIT 1;
    SELECT name INTO v_team_name FROM teams WHERE id = v_team_id;
    SELECT COUNT(*) INTO v_new_members_count FROM inserted_batch;

    RAISE LOG 'New members count: %', v_new_members_count;

    -- 2. Get the IDs of members who were ALREADY in this team 
    -- (Exclude anyone who is in the "inserted_batch")
    SELECT ARRAY_AGG(member_id) INTO v_existing_members 
    FROM public.team_members 
    WHERE team_id = v_team_id 
    AND member_id NOT IN (SELECT member_id FROM inserted_batch);

    -- 3. If there are old members to notify, send it.
    IF v_existing_members IS NOT NULL AND array_length(v_existing_members, 1) > 0 THEN
        
        -- Get preferences for the old members
        SELECT ARRAY_AGG(notifications.profile_notifications_preferences(m_id)) 
        INTO v_team_preferences
        FROM UNNEST(v_existing_members) AS m_id;

        PERFORM notifications.send_notification(
            p_template_id := 'new_member_joined',
            p_targets := v_team_preferences,
            p_route := '/teams/' || v_team_id || '/members',
            p_params := jsonb_build_object(
                'team', v_team_name,
                'number', v_new_members_count
            )
        );
    END IF;

    RETURN NULL;
END;
$$;


ALTER FUNCTION notifications.new_member_added_notification() OWNER TO postgres;

--
-- Name: new_member_evaluation_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.new_member_evaluation_notification() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_member_preferences JSONB;
BEGIN

    SELECT notifications.profile_notifications_preferences(NEW.profile_id)
    INTO v_member_preferences;

    PERFORM notifications.send_notification(
        p_template_id := 'new_coach_evaluation',
        p_token := v_member_preferences->>'token',
        p_preferred_language := v_member_preferences->>'preferred_language',
        p_route := '/teams/' || NEW.team_id || '/evaluations'
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.new_member_evaluation_notification() OWNER TO postgres;

--
-- Name: opportunity_closed_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.opportunity_closed_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_owner_preferences JSONB;
BEGIN
    -- If the opportunity is closed, send a notification to the owner.
    IF NEW.status != 'published' THEN
        SELECT notifications.profile_notifications_preferences(NEW.created_by) INTO v_owner_preferences;
        PERFORM notifications.send_notification(
            p_template_id := 'opportunity_closed',
            p_token := v_owner_preferences->>'token',
            p_route := '/opportunities/' || NEW.id,
            p_preferred_language := v_owner_preferences->>'preferred_language'
        );
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.opportunity_closed_notification() OWNER TO postgres;

--
-- Name: opportunity_ending_reminder(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.opportunity_ending_reminder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_owner_preferences jsonb;
    v_saved_profiles_preferences jsonb;
BEGIN
    SELECT notifications.profile_notifications_preferences(NEW.created_by)
    INTO v_owner_preferences;

    IF NEW.deadline IS NOT NULL THEN
        PERFORM notifications.schedule_notification(
            p_template_id := 'opportunity_ending_soon_creator',
            p_token := v_owner_preferences->>'token',
            p_preferred_language := v_owner_preferences->>'preferred_language',
            p_route := '/opportunities/' || NEW.id,
            p_schedule_time := (NEW.deadline - interval '12 hours')::timestamp
        );
    END IF;

    SELECT notifications.profile_notifications_preferences(profile_id)
    INTO v_saved_profiles_preferences
    FROM public.saved_opportunities
    WHERE opportunity_id = NEW.id;
    
    IF v_saved_profiles_preferences IS NOT NULL OR jsonb_array_length(v_saved_profiles_preferences) > 0 THEN
        PERFORM notifications.schedule_notification(
            p_template_id := 'saved_opportunity_ending_soon',
            p_targets := v_saved_profiles_preferences,
            p_route := '/opportunities/' || NEW.id,
            p_schedule_time := (NEW.deadline - interval '12 hours')::timestamp
        );
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.opportunity_ending_reminder() OWNER TO postgres;

--
-- Name: profile_notifications_preferences(uuid); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.profile_notifications_preferences(p_profile_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_profile public.profiles%ROWTYPE;
BEGIN
    IF p_profile_id IS NULL THEN
        RAISE EXCEPTION 'Profile ID cannot be null';
    END IF;

    SELECT * INTO v_profile FROM public.profiles WHERE id = p_profile_id;
    IF v_profile IS NULL THEN
        RAISE EXCEPTION 'Profile % not found', p_profile_id;
    END IF;

    RETURN jsonb_build_object(
        'token', v_profile.fcm_token,
        'preferred_language', v_profile.preferred_language
    );
END;
$$;


ALTER FUNCTION notifications.profile_notifications_preferences(p_profile_id uuid) OWNER TO postgres;

--
-- Name: saved_opportunity_updated_notification(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.saved_opportunity_updated_notification() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_profile_preferences_list JSONB[];
    v_saved_opportunities_profile_ids UUID[];
    v_profile_id UUID;
BEGIN

    -- If the opportunity change to closed or expired or cancelled, return
    IF NEW.status != 'published' THEN RETURN NEW; END IF;

    SELECT ARRAY_AGG(profile_id) INTO v_saved_opportunities_profile_ids
    FROM public.saved_opportunities
    WHERE opportunity_id = NEW.id;

    IF v_saved_opportunities_profile_ids IS NULL OR array_length(v_saved_opportunities_profile_ids, 1) = 0 THEN RETURN NEW; END IF;

    SELECT ARRAY_AGG(notifications.profile_notifications_preferences(profile_id)) INTO v_profile_preferences_list
    FROM public.saved_opportunities
    WHERE opportunity_id = NEW.id;

    -- If the opportunity got reopened.
    IF OLD.status != 'published' THEN 
            PERFORM notifications.send_notification(
                p_template_id := 'saved_opportunity_reopened',
                p_targets := v_profile_preferences_list,
                p_route := '/opportunities/' || NEW.id
            );

        RETURN NEW;
    END IF;

    PERFORM notifications.send_notification(
        p_template_id := 'saved_opportunity_updated',
        p_targets := v_profile_preferences_list,
        p_route := '/opportunities/' || NEW.id
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.saved_opportunity_updated_notification() OWNER TO postgres;

--
-- Name: schedule_notification(text, jsonb[], timestamp without time zone, text, jsonb); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.schedule_notification(p_template_id text, p_targets jsonb[], p_schedule_time timestamp without time zone, p_route text DEFAULT NULL::text, p_params jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_template notifications.communication_templates%ROWTYPE;
BEGIN
   RAISE LOG '[DEBUG] Sending notification to % targets', array_length(p_targets, 1);
    RAISE LOG '[DEBUG] Template ID: %', p_template_id;
    RAISE LOG '[DEBUG] Route: %', p_route;

    IF p_targets IS NULL OR array_length(p_targets, 1) = 0 THEN
        RAISE EXCEPTION 'Targets cannot be null or empty';
    END IF;

    SELECT * INTO v_template FROM notifications.communication_templates WHERE id = p_template_id;
    IF v_template IS NULL THEN
        RAISE EXCEPTION 'Template % not found', p_template_id;
    END IF;

    if v_template.channel = 'push'::notifications.channel_type THEN
        perform net.http_post(
            url := 'https://processsendschedulednotification-z2hztgdgeq-ew.a.run.app',
            body := jsonb_build_object(
                'targets', p_targets,
                'body_key', v_template.body_key,
                'title_key', v_template.title_key,
                'route', p_route,
                'params', p_params,
                'schedule_time', p_schedule_time
            ),
            headers := jsonb_build_object('Content-Type', 'application/json'),
            timeout_milliseconds := 10000
        );
    END IF;
END;
$$;


ALTER FUNCTION notifications.schedule_notification(p_template_id text, p_targets jsonb[], p_schedule_time timestamp without time zone, p_route text, p_params jsonb) OWNER TO postgres;

--
-- Name: schedule_notification(text, text, timestamp without time zone, text, text, jsonb); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.schedule_notification(p_template_id text, p_token text, p_schedule_time timestamp without time zone, p_route text DEFAULT NULL::text, p_preferred_language text DEFAULT 'en'::text, p_params jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_template notifications.communication_templates%ROWTYPE;
BEGIN
    RAISE LOG '[DEBUG] Scheduling notification';
    RAISE LOG '[DEBUG] Template ID: %', p_template_id;
    RAISE LOG '[DEBUG] Token: %', p_token;
    RAISE LOG '[DEBUG] Route: %', p_route;
    RAISE LOG '[DEBUG] Schedule time: %', p_schedule_time;

    IF p_token IS NULL THEN
        RAISE EXCEPTION 'Token cannot be null';
    END IF;

    SELECT * INTO v_template FROM notifications.communication_templates WHERE id = p_template_id;
    IF v_template IS NULL THEN
        RAISE EXCEPTION 'Template % not found', p_template_id;
    END IF;

    IF v_template.channel = 'push'::notifications.channel_type THEN
        perform net.http_post(
            url := 'https://processsendschedulednotification-z2hztgdgeq-ew.a.run.app',
            body := jsonb_build_object(
                'target', jsonb_build_object(
                    'token', p_token,
                    'preferred_language', p_preferred_language
                ),
                'preferred_language', p_preferred_language,
                'body_key', v_template.body_key,
                'title_key', v_template.title_key,
                'route', p_route,
                'params', p_params,
                'schedule_time', p_schedule_time
            ),
            headers := jsonb_build_object('Content-Type', 'application/json'),
            timeout_milliseconds := 10000
        );
    END IF;
END;
$$;


ALTER FUNCTION notifications.schedule_notification(p_template_id text, p_token text, p_schedule_time timestamp without time zone, p_route text, p_preferred_language text, p_params jsonb) OWNER TO postgres;

--
-- Name: schedule_rpc(text, jsonb, timestamp with time zone); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.schedule_rpc(p_rpc_name text, p_payload jsonb, p_schedule_time timestamp with time zone) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_base_url TEXT;
    v_publishable_key TEXT;
BEGIN

    SELECT value INTO v_base_url FROM config.database_configs WHERE key = 'database_url';
    SELECT value INTO v_publishable_key FROM config.database_configs WHERE key = 'publishable_key';

    PERFORM net.http_post(
        url := 'https://processsendschedulednotification-z2hztgdgeq-ew.a.run.app',
        body := jsonb_build_object(
            'payload', p_payload,
            'schedule_time', p_schedule_time,
            'custom_url', v_base_url || '/rest/v1/rpc/' || p_rpc_name,
            'headers', jsonb_build_object(
                'Content-Type', 'application/json',
                'Authorization', 'Bearer ' || v_publishable_key
            )
        ),
        timeout_milliseconds := 10000
    );
END;
$$;


ALTER FUNCTION notifications.schedule_rpc(p_rpc_name text, p_payload jsonb, p_schedule_time timestamp with time zone) OWNER TO postgres;

--
-- Name: schedule_session_report_reminder(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.schedule_session_report_reminder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_team_id uuid;
    v_admins_ids uuid[];
    v_admins_preferences jsonb[];
    v_session_end_time timestamp;
BEGIN

    SELECT team_id, end_time
    INTO v_team_id, v_session_end_time  
    FROM team_sessions
    WHERE id = NEW.session_id;

    SELECT ARRAY(
        SELECT member_id FROM team_members
        WHERE team_id = v_team_id
        AND is_admin = TRUE
    ) INTO v_admins_ids;


    SELECT ARRAY_AGG(notifications.profile_notifications_preferences(profile_id))
    INTO v_admins_preferences
    FROM UNNEST(v_admins_ids) AS profile_id;

    PERFORM notifications.schedule_notification(
        p_template_id := 'report_available_to_complete',
        p_targets := v_admins_preferences,
        p_schedule_time := v_session_end_time
    );
  RETURN NEW;
END
$$;


ALTER FUNCTION notifications.schedule_session_report_reminder() OWNER TO postgres;

--
-- Name: scheduled_session_invitation_reminder(); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.scheduled_session_invitation_reminder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM notifications.schedule_rpc(
        p_rpc_name := 'trigger_member_session_invitation_notification',
        p_payload := jsonb_build_object('p_session_id', NEW.id),
        p_schedule_time := NEW.appointment_datetime - INTERVAL '24 hours'
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION notifications.scheduled_session_invitation_reminder() OWNER TO postgres;

--
-- Name: send_notification(text, jsonb[], text, jsonb); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.send_notification(p_template_id text, p_targets jsonb[], p_route text DEFAULT NULL::text, p_params jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_template notifications.communication_templates%ROWTYPE;
BEGIN

    RAISE LOG '[DEBUG] Sending notification to % targets', array_length(p_targets, 1);
    RAISE LOG '[DEBUG] Template ID: %', p_template_id;
    RAISE LOG '[DEBUG] Route: %', p_route;

    IF p_targets IS NULL OR array_length(p_targets, 1) = 0 THEN
        RAISE EXCEPTION 'Targets cannot be null or empty';
    END IF;

    SELECT * INTO v_template FROM notifications.communication_templates WHERE id = p_template_id;
    IF v_template IS NULL THEN
        RAISE EXCEPTION 'Template % not found', p_template_id;
    END IF;

    if v_template.channel = 'push'::notifications.channel_type THEN
        perform net.http_post(
            url := 'https://processsendnotification-z2hztgdgeq-ew.a.run.app',
            body := jsonb_build_object(
                'targets', p_targets,
                'body_key', v_template.body_key,
                'title_key', v_template.title_key,
                'route', p_route,
                'params', p_params
            ),
            headers := jsonb_build_object('Content-Type', 'application/json'),
            timeout_milliseconds := 10000
        );
    END IF;
END;
$$;


ALTER FUNCTION notifications.send_notification(p_template_id text, p_targets jsonb[], p_route text, p_params jsonb) OWNER TO postgres;

--
-- Name: send_notification(text, text, text, text, jsonb); Type: FUNCTION; Schema: notifications; Owner: postgres
--

CREATE FUNCTION notifications.send_notification(p_template_id text, p_token text, p_route text DEFAULT NULL::text, p_preferred_language text DEFAULT 'en'::text, p_params jsonb DEFAULT NULL::jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_template notifications.communication_templates%ROWTYPE;
BEGIN

    RAISE LOG '[DEBUG] Sending notification to token: %', p_token;
    RAISE LOG '[DEBUG] Template ID: %', p_template_id;
    RAISE LOG '[DEBUG] Route: %', p_route;
    RAISE LOG '[DEBUG] Preferred language: %', p_preferred_language;

    IF p_token IS NULL THEN
        RAISE EXCEPTION 'Token cannot be null';
    END IF;

    SELECT * INTO v_template FROM notifications.communication_templates WHERE id = p_template_id;
    IF v_template IS NULL THEN
        RAISE EXCEPTION 'Template % not found', p_template_id;
    END IF;

    if v_template.channel = 'push'::notifications.channel_type THEN
        perform net.http_post(
            url := 'https://processsendnotification-z2hztgdgeq-ew.a.run.app',
            body := jsonb_build_object(
                'target', jsonb_build_object(
                    'token', p_token,
                    'preferred_language', p_preferred_language
                ),
                'preferred_language', p_preferred_language,
                'body_key', v_template.body_key,
                'title_key', v_template.title_key,
                'route', p_route,
                'params', p_params
            ),
            headers := jsonb_build_object('Content-Type', 'application/json'),
            timeout_milliseconds := 10000
        );
    END IF;
END;
$$;


ALTER FUNCTION notifications.send_notification(p_template_id text, p_token text, p_route text, p_preferred_language text, p_params jsonb) OWNER TO postgres;

--
-- Name: check_email_available(text); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.check_email_available(p_email text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN NOT EXISTS (SELECT 1 FROM public.profiles WHERE LOWER(p_email) = LOWER(email));
END;
$$;


ALTER FUNCTION profiles.check_email_available(p_email text) OWNER TO postgres;

--
-- Name: check_username_available(text); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.check_username_available(p_username text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RETURN NOT EXISTS (SELECT 1 FROM public.profiles WHERE LOWER(p_username) = LOWER(username));
END;
$$;


ALTER FUNCTION profiles.check_username_available(p_username text) OWNER TO postgres;

--
-- Name: create_profile(text, text, text, text, text, text, date, smallint, text, smallint, text); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.create_profile(p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_user_id text DEFAULT NULL::text, p_city_id smallint DEFAULT NULL::smallint, p_preferred_language text DEFAULT 'en'::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_display_name TEXT;
  v_user_id TEXT;
BEGIN
  -- Use public.uid() if p_user_id is NULL
  v_user_id := COALESCE(p_user_id, (SELECT public.uid()));
  v_display_name := p_first_name || ' ' || p_last_name;
  
  -- Create profile entry with all individual profile data
  INSERT INTO public.profiles (
    user_id,
    user_type,
    username,
    display_name,
    avatar_url,
    preferred_language,
    country_id,
    city_id,
    is_active,
    first_name,
    last_name,
    email,
    gender,
    date_of_birth
  ) VALUES (
    v_user_id,
    'private_profile'::user_type,
    p_username,
    v_display_name,
    p_image_url,
    p_preferred_language,
    p_country_id,
    p_city_id,
    false, -- New profiles are not active by default
    p_first_name,
    p_last_name,
    p_email,
    p_gender,
    p_date_of_birth
  )
  RETURNING id INTO v_profile_id;

  RETURN v_profile_id;
END;
$$;


ALTER FUNCTION profiles.create_profile(p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_user_id text, p_city_id smallint, p_preferred_language text) OWNER TO postgres;

--
-- Name: FUNCTION create_profile(p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_user_id text, p_city_id smallint, p_preferred_language text); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.create_profile(p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_user_id text, p_city_id smallint, p_preferred_language text) IS 'Creates a new profile with basic info. Uses public.uid() if p_user_id is NULL';


--
-- Name: create_profile_role(public.individual_role, uuid, uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.create_profile_role(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_profile_role_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Check if role already exists
  IF EXISTS (
    SELECT 1 FROM profiles.profile_roles
    WHERE profile_id = v_profile_id
      AND role = p_role
      AND primary_sport_id = p_sport_id
  ) THEN
    RAISE EXCEPTION 'Role % already exists for this profile with sport %', p_role, p_sport_id;
  END IF;

  -- Create profile_role entry
  INSERT INTO profiles.profile_roles (
    profile_id,
    role,
    primary_sport_id,
    is_completed
  ) VALUES (
    v_profile_id,
    p_role,
    p_sport_id,
    false
  )
  RETURNING id INTO v_profile_role_id;

  -- Create entry in role-specific table
  CASE p_role
    WHEN 'fan' THEN
      INSERT INTO profiles.fan_profiles (profile_role_id)
      VALUES (v_profile_role_id);
      
      UPDATE profiles.profile_roles
      SET is_completed = true, updated_at = NOW()
      WHERE id = v_profile_role_id;
    ELSE
      -- Other roles will be populated when updated
      NULL;
  END CASE;

  RETURN v_profile_role_id;
END;
$$;


ALTER FUNCTION profiles.create_profile_role(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION create_profile_role(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.create_profile_role(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid) IS 'Creates a new role for a profile. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: delete_profile(uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.delete_profile(p_profile_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Cascade delete will handle profile_roles and role-specific tables
  DELETE FROM public.profiles
  WHERE id = p_profile_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found: %', p_profile_id;
  END IF;
END;
$$;


ALTER FUNCTION profiles.delete_profile(p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION delete_profile(p_profile_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.delete_profile(p_profile_id uuid) IS 'Deletes a profile and all associated roles (cascade)';


--
-- Name: delete_profile_role(uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.delete_profile_role(p_profile_role_id uuid) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Cascade delete will handle role-specific tables
  DELETE FROM profiles.profile_roles
  WHERE id = p_profile_role_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile role not found: %', p_profile_role_id;
  END IF;
END;
$$;


ALTER FUNCTION profiles.delete_profile_role(p_profile_role_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION delete_profile_role(p_profile_role_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.delete_profile_role(p_profile_role_id uuid) IS 'Deletes a profile role (cascades to role-specific table)';


--
-- Name: get_profile(uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.get_profile(p_profile_id uuid DEFAULT NULL::uuid) RETURNS TABLE(profile_id uuid, user_id text, display_name text, avatar_url text, bio text, preferred_language text, country_id smallint, city_id smallint, is_active boolean, first_name text, last_name text, username text, email text, gender text, date_of_birth date, roles jsonb)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  RETURN QUERY
  SELECT 
    p.id AS profile_id,
    p.user_id,
    p.display_name,
    p.avatar_url,
    p.bio,
    p.preferred_language,
    p.country_id,
    p.city_id,
    p.is_active,
    p.first_name,
    p.last_name,
    p.username,
    p.email,
    p.gender,
    p.date_of_birth,
    COALESCE(
      jsonb_agg(
        jsonb_build_object(
          'id', pr.id,
          'role', pr.role,
          'primary_sport_id', pr.primary_sport_id,
          'is_completed', pr.is_completed,
          'created_at', pr.created_at
        )
      ) FILTER (WHERE pr.id IS NOT NULL),
      '[]'::jsonb
    ) AS roles
  FROM public.profiles p
  LEFT JOIN profiles.profile_roles pr ON pr.profile_id = p.id
  WHERE p.id = v_profile_id
  GROUP BY p.id;
END;
$$;


ALTER FUNCTION profiles.get_profile(p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION get_profile(p_profile_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.get_profile(p_profile_id uuid) IS 'Returns full profile with basic info and all roles. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: get_role_data(public.individual_role, uuid, uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.get_role_data(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid DEFAULT NULL::uuid) RETURNS jsonb
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_profile_role_id UUID;
  v_role_data JSONB;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Get profile_role_id
  SELECT id INTO v_profile_role_id
  FROM profiles.profile_roles
  WHERE profile_id = v_profile_id
    AND role = p_role
    AND primary_sport_id = p_sport_id;

  IF v_profile_role_id IS NULL THEN
    RETURN NULL;
  END IF;

  -- Get role-specific data based on role type
  CASE p_role
    WHEN 'player' THEN
      SELECT row_to_json(pp.*)::JSONB INTO v_role_data
      FROM profiles.player_profiles pp
      WHERE pp.profile_role_id = v_profile_role_id;
    
    WHEN 'coach' THEN
      SELECT row_to_json(cp.*)::JSONB INTO v_role_data
      FROM profiles.coach_profiles cp
      WHERE cp.profile_role_id = v_profile_role_id;
    
    WHEN 'referee' THEN
      SELECT row_to_json(rp.*)::JSONB INTO v_role_data
      FROM profiles.referee_profiles rp
      WHERE rp.profile_role_id = v_profile_role_id;
    
    WHEN 'club_staff' THEN
      SELECT row_to_json(csp.*)::JSONB INTO v_role_data
      FROM profiles.club_staff_profiles csp
      WHERE csp.profile_role_id = v_profile_role_id;
    
    WHEN 'fan' THEN
      SELECT row_to_json(fp.*)::JSONB INTO v_role_data
      FROM profiles.fan_profiles fp
      WHERE fp.profile_role_id = v_profile_role_id;
    
    ELSE
      RETURN NULL;
  END CASE;

  RETURN v_role_data;
END;
$$;


ALTER FUNCTION profiles.get_role_data(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION get_role_data(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.get_role_data(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid) IS 'Returns role-specific data as JSONB. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: list_profile_roles(uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.list_profile_roles(p_profile_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, role public.individual_role, primary_sport_id uuid, sport_name text, sport_icon text, is_completed boolean, created_at timestamp with time zone, updated_at timestamp with time zone)
    LANGUAGE plpgsql STABLE SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  RETURN QUERY
  SELECT 
    pr.id,
    pr.role,
    pr.primary_sport_id,
    s.name AS sport_name,
    s.icon_url AS sport_icon,
    pr.is_completed,
    pr.created_at,
    pr.updated_at
  FROM profiles.profile_roles pr
  JOIN public.sports s ON s.id = pr.primary_sport_id
  WHERE pr.profile_id = v_profile_id
  ORDER BY pr.created_at;
END;
$$;


ALTER FUNCTION profiles.list_profile_roles(p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION list_profile_roles(p_profile_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.list_profile_roles(p_profile_id uuid) IS 'Returns all roles for a profile with completion status. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: list_user_profiles(text); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.list_user_profiles(p_user_id text DEFAULT NULL::text) RETURNS TABLE(profile_id uuid, display_name text, avatar_url text, is_active boolean, role_count bigint, completed_roles_count bigint, created_at timestamp with time zone)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_user_id TEXT;
BEGIN
  -- Use public.uid() if p_user_id is NULL
  v_user_id := COALESCE(p_user_id, (SELECT public.uid()));
  
  RETURN QUERY
  SELECT 
    p.id AS profile_id,
    p.display_name,
    p.avatar_url,
    p.is_active,
    COUNT(pr.id) AS role_count,
    COUNT(pr.id) FILTER (WHERE pr.is_completed = true) AS completed_roles_count,
    p.created_at
  FROM public.profiles p
  LEFT JOIN profiles.profile_roles pr ON pr.profile_id = p.id
  WHERE p.user_id = v_user_id
  GROUP BY p.id, p.display_name, p.avatar_url, p.is_active, p.created_at
  ORDER BY p.is_active DESC, p.created_at DESC;
END;
$$;


ALTER FUNCTION profiles.list_user_profiles(p_user_id text) OWNER TO postgres;

--
-- Name: FUNCTION list_user_profiles(p_user_id text); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.list_user_profiles(p_user_id text) IS 'Returns all profiles for a user with basic info and role counts. Uses public.uid() if p_user_id is NULL';


--
-- Name: select_active_profile(uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.select_active_profile(p_profile_id uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_user_id TEXT;
BEGIN
  -- Get user_id from profile
  SELECT user_id INTO v_user_id
  FROM public.profiles
  WHERE id = p_profile_id;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'Profile not found: %', p_profile_id;
  END IF;

  -- Set all user profiles to inactive
  UPDATE public.profiles
  SET is_active = false
  WHERE user_id = v_user_id;

  -- Set specified profile to active
  UPDATE public.profiles
  SET is_active = true
  WHERE id = p_profile_id;

  RETURN p_profile_id;
END;
$$;


ALTER FUNCTION profiles.select_active_profile(p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION select_active_profile(p_profile_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.select_active_profile(p_profile_id uuid) IS 'Sets the active profile for a user';


--
-- Name: update_club_staff_role(uuid, uuid, text, text, uuid); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.update_club_staff_role(p_sport_id uuid, p_profile_id uuid DEFAULT NULL::uuid, p_club_staff_role text DEFAULT NULL::text, p_club_staff_department text DEFAULT NULL::text, p_sport_entity_id uuid DEFAULT NULL::uuid) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_profile_role_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Get profile_role_id
  SELECT id INTO v_profile_role_id
  FROM profiles.profile_roles
  WHERE profile_id = v_profile_id
    AND role = 'club_staff'
    AND primary_sport_id = p_sport_id;

  IF v_profile_role_id IS NULL THEN
    RAISE EXCEPTION 'Club staff role not found for profile % with sport %', v_profile_id, p_sport_id;
  END IF;

  -- Insert or update club_staff_profiles
  INSERT INTO profiles.club_staff_profiles (
    profile_role_id,
    club_staff_role,
    club_staff_department,
    sport_entity_id
  ) VALUES (
    v_profile_role_id,
    p_club_staff_role,
    p_club_staff_department,
    p_sport_entity_id
  )
  ON CONFLICT (profile_role_id) DO UPDATE SET
    club_staff_role = COALESCE(EXCLUDED.club_staff_role, club_staff_profiles.club_staff_role),
    club_staff_department = COALESCE(EXCLUDED.club_staff_department, club_staff_profiles.club_staff_department),
    sport_entity_id = COALESCE(EXCLUDED.sport_entity_id, club_staff_profiles.sport_entity_id);

  -- Mark as completed
  UPDATE profiles.profile_roles
  SET is_completed = true, updated_at = NOW()
  WHERE id = v_profile_role_id;

  RETURN v_profile_role_id;
END;
$$;


ALTER FUNCTION profiles.update_club_staff_role(p_sport_id uuid, p_profile_id uuid, p_club_staff_role text, p_club_staff_department text, p_sport_entity_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION update_club_staff_role(p_sport_id uuid, p_profile_id uuid, p_club_staff_role text, p_club_staff_department text, p_sport_entity_id uuid); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.update_club_staff_role(p_sport_id uuid, p_profile_id uuid, p_club_staff_role text, p_club_staff_department text, p_sport_entity_id uuid) IS 'Updates club staff role data and marks as completed. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: update_coach_role(uuid, uuid, text, text, text, uuid, text, jsonb, jsonb); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.update_coach_role(p_sport_id uuid, p_profile_id uuid DEFAULT NULL::uuid, p_sport_goal text DEFAULT NULL::text, p_sport_category text DEFAULT NULL::text, p_academy_category text DEFAULT NULL::text, p_sport_entity_id uuid DEFAULT NULL::uuid, p_coach_role text DEFAULT NULL::text, p_coach_certifications jsonb DEFAULT NULL::jsonb, p_coach_supervisions jsonb DEFAULT NULL::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_profile_role_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Get profile_role_id
  SELECT id INTO v_profile_role_id
  FROM profiles.profile_roles
  WHERE profile_id = v_profile_id
    AND role = 'coach'
    AND primary_sport_id = p_sport_id;

  IF v_profile_role_id IS NULL THEN
    RAISE EXCEPTION 'Coach role not found for profile % with sport %', v_profile_id, p_sport_id;
  END IF;

  -- Insert or update coach_profiles
  INSERT INTO profiles.coach_profiles (
    profile_role_id,
    sport_goal,
    sport_category,
    academy_category,
    sport_entity_id,
    coach_role,
    coach_certifications,
    coach_supervisions
  ) VALUES (
    v_profile_role_id,
    p_sport_goal,
    p_sport_category,
    p_academy_category,
    p_sport_entity_id,
    p_coach_role,
    p_coach_certifications,
    p_coach_supervisions
  )
  ON CONFLICT (profile_role_id) DO UPDATE SET
    sport_goal = COALESCE(EXCLUDED.sport_goal, coach_profiles.sport_goal),
    sport_category = COALESCE(EXCLUDED.sport_category, coach_profiles.sport_category),
    academy_category = COALESCE(EXCLUDED.academy_category, coach_profiles.academy_category),
    sport_entity_id = COALESCE(EXCLUDED.sport_entity_id, coach_profiles.sport_entity_id),
    coach_role = COALESCE(EXCLUDED.coach_role, coach_profiles.coach_role),
    coach_certifications = COALESCE(EXCLUDED.coach_certifications, coach_profiles.coach_certifications),
    coach_supervisions = COALESCE(EXCLUDED.coach_supervisions, coach_profiles.coach_supervisions);

  -- Mark as completed
  UPDATE profiles.profile_roles
  SET is_completed = true, updated_at = NOW()
  WHERE id = v_profile_role_id;

  RETURN v_profile_role_id;
END;
$$;


ALTER FUNCTION profiles.update_coach_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb) OWNER TO postgres;

--
-- Name: FUNCTION update_coach_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.update_coach_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb) IS 'Updates coach role data and marks as completed. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: update_player_role(uuid, uuid, text, text, text, uuid, text, text, integer, text); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.update_player_role(p_sport_id uuid, p_profile_id uuid DEFAULT NULL::uuid, p_sport_goal text DEFAULT NULL::text, p_sport_category text DEFAULT NULL::text, p_academy_category text DEFAULT NULL::text, p_sport_entity_id uuid DEFAULT NULL::uuid, p_field_position text DEFAULT NULL::text, p_strong_foot text DEFAULT NULL::text, p_height_cm integer DEFAULT NULL::integer, p_player_status text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_profile_role_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Get profile_role_id
  SELECT id INTO v_profile_role_id
  FROM profiles.profile_roles
  WHERE profile_id = v_profile_id
    AND role = 'player'
    AND primary_sport_id = p_sport_id;

  IF v_profile_role_id IS NULL THEN
    RAISE EXCEPTION 'Player role not found for profile % with sport %', v_profile_id, p_sport_id;
  END IF;

  -- Insert or update player_profiles
  INSERT INTO profiles.player_profiles (
    profile_role_id,
    sport_goal,
    sport_category,
    academy_category,
    sport_entity_id,
    field_position,
    strong_foot,
    height_cm,
    player_status
  ) VALUES (
    v_profile_role_id,
    p_sport_goal,
    p_sport_category,
    p_academy_category,
    p_sport_entity_id,
    p_field_position,
    p_strong_foot,
    p_height_cm,
    p_player_status
  )
  ON CONFLICT (profile_role_id) DO UPDATE SET
    sport_goal = COALESCE(EXCLUDED.sport_goal, player_profiles.sport_goal),
    sport_category = COALESCE(EXCLUDED.sport_category, player_profiles.sport_category),
    academy_category = COALESCE(EXCLUDED.academy_category, player_profiles.academy_category),
    sport_entity_id = COALESCE(EXCLUDED.sport_entity_id, player_profiles.sport_entity_id),
    field_position = COALESCE(EXCLUDED.field_position, player_profiles.field_position),
    strong_foot = COALESCE(EXCLUDED.strong_foot, player_profiles.strong_foot),
    height_cm = COALESCE(EXCLUDED.height_cm, player_profiles.height_cm),
    player_status = COALESCE(EXCLUDED.player_status, player_profiles.player_status);

  -- Mark as completed
  UPDATE profiles.profile_roles
  SET is_completed = true, updated_at = NOW()
  WHERE id = v_profile_role_id;

  RETURN v_profile_role_id;
END;
$$;


ALTER FUNCTION profiles.update_player_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text) OWNER TO postgres;

--
-- Name: FUNCTION update_player_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.update_player_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text) IS 'Updates player role data and marks as completed. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: update_profile_basic_info(uuid, text, text, text, text, text, text, date, smallint, smallint, text); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.update_profile_basic_info(p_profile_id uuid DEFAULT NULL::uuid, p_first_name text DEFAULT NULL::text, p_last_name text DEFAULT NULL::text, p_username text DEFAULT NULL::text, p_email text DEFAULT NULL::text, p_image_url text DEFAULT NULL::text, p_gender text DEFAULT NULL::text, p_date_of_birth date DEFAULT NULL::date, p_country_id smallint DEFAULT NULL::smallint, p_city_id smallint DEFAULT NULL::smallint, p_bio text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_display_name TEXT;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Calculate display name if names are being updated
  IF p_first_name IS NOT NULL OR p_last_name IS NOT NULL THEN
    SELECT 
      COALESCE(p_first_name, p.first_name) || ' ' || COALESCE(p_last_name, p.last_name)
    INTO v_display_name
    FROM public.profiles p
    WHERE p.id = v_profile_id;
  END IF;

  -- Update profiles table
  UPDATE public.profiles
  SET
    display_name = COALESCE(v_display_name, display_name),
    avatar_url = COALESCE(p_image_url, avatar_url),
    bio = COALESCE(p_bio, bio),
    country_id = COALESCE(p_country_id, country_id),
    city_id = COALESCE(p_city_id, city_id),
    username = COALESCE(p_username, username),
    first_name = COALESCE(p_first_name, first_name),
    last_name = COALESCE(p_last_name, last_name),
    email = COALESCE(p_email, email),
    gender = COALESCE(p_gender, gender),
    date_of_birth = COALESCE(p_date_of_birth, date_of_birth)
  WHERE id = v_profile_id;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Profile not found: %', v_profile_id;
  END IF;

  RETURN v_profile_id;
END;
$$;


ALTER FUNCTION profiles.update_profile_basic_info(p_profile_id uuid, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_city_id smallint, p_bio text) OWNER TO postgres;

--
-- Name: FUNCTION update_profile_basic_info(p_profile_id uuid, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_city_id smallint, p_bio text); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.update_profile_basic_info(p_profile_id uuid, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_city_id smallint, p_bio text) IS 'Updates basic profile information. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: update_referee_role(uuid, uuid, text, uuid, jsonb, jsonb); Type: FUNCTION; Schema: profiles; Owner: postgres
--

CREATE FUNCTION profiles.update_referee_role(p_sport_id uuid, p_profile_id uuid DEFAULT NULL::uuid, p_sport_goal text DEFAULT NULL::text, p_sport_entity_id uuid DEFAULT NULL::uuid, p_referee_categories jsonb DEFAULT NULL::jsonb, p_referee_match_types jsonb DEFAULT NULL::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_profile_id UUID;
  v_profile_role_id UUID;
  v_user_id TEXT;
BEGIN
  -- If p_profile_id is NULL, get active profile for current user
  IF p_profile_id IS NULL THEN 
    SELECT public.profile_id() INTO v_profile_id;
  ELSE
    v_profile_id := p_profile_id;
  END IF;

  -- Get profile_role_id
  SELECT id INTO v_profile_role_id
  FROM profiles.profile_roles
  WHERE profile_id = v_profile_id
    AND role = 'referee'
    AND primary_sport_id = p_sport_id;

  IF v_profile_role_id IS NULL THEN
    RAISE EXCEPTION 'Referee role not found for profile % with sport %', v_profile_id, p_sport_id;
  END IF;

  -- Insert or update referee_profiles
  INSERT INTO profiles.referee_profiles (
    profile_role_id,
    sport_goal,
    sport_entity_id,
    referee_categories,
    referee_match_types
  ) VALUES (
    v_profile_role_id,
    p_sport_goal,
    p_sport_entity_id,
    p_referee_categories,
    p_referee_match_types
  )
  ON CONFLICT (profile_role_id) DO UPDATE SET
    sport_goal = COALESCE(EXCLUDED.sport_goal, referee_profiles.sport_goal),
    sport_entity_id = COALESCE(EXCLUDED.sport_entity_id, referee_profiles.sport_entity_id),
    referee_categories = COALESCE(EXCLUDED.referee_categories, referee_profiles.referee_categories),
    referee_match_types = COALESCE(EXCLUDED.referee_match_types, referee_profiles.referee_match_types);

  -- Mark as completed
  UPDATE profiles.profile_roles
  SET is_completed = true, updated_at = NOW()
  WHERE id = v_profile_role_id;

  RETURN v_profile_role_id;
END;
$$;


ALTER FUNCTION profiles.update_referee_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_entity_id uuid, p_referee_categories jsonb, p_referee_match_types jsonb) OWNER TO postgres;

--
-- Name: FUNCTION update_referee_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_entity_id uuid, p_referee_categories jsonb, p_referee_match_types jsonb); Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON FUNCTION profiles.update_referee_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_entity_id uuid, p_referee_categories jsonb, p_referee_match_types jsonb) IS 'Updates referee role data and marks as completed. Uses active profile for current user (public.uid()) if p_profile_id is NULL';


--
-- Name: accept_session_invitation(uuid, public.session_invitation_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.accept_session_invitation(p_session_id uuid, p_status public.session_invitation_status) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.accept_session_invitation(p_session_id uuid, p_status public.session_invitation_status) OWNER TO postgres;

--
-- Name: broadcast_with_profile_id(jsonb, text, text, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.broadcast_with_profile_id(payload jsonb, event_name text, topic text, is_private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
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


ALTER FUNCTION public.broadcast_with_profile_id(payload jsonb, event_name text, topic text, is_private boolean) OWNER TO postgres;

--
-- Name: create_channel(text, uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_channel(p_channel_name text, p_owner_profile_id uuid, p_channel_logo_url text DEFAULT NULL::text) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_chat_id UUID;
  v_channel_config JSONB;
  v_current_profile_id UUID;
BEGIN
  -- Validate inputs
  IF p_channel_name IS NULL OR TRIM(p_channel_name) = '' THEN
    RAISE EXCEPTION 'channel_name cannot be null or empty';
  END IF;

  IF p_owner_profile_id IS NULL THEN
    RAISE EXCEPTION 'owner_profile_id cannot be null';
  END IF;

  -- Get current user profile_id
  v_current_profile_id := (SELECT profile_id());
  IF v_current_profile_id IS NULL THEN
    RAISE EXCEPTION 'user must be authenticated';
  END IF;

  -- Verify that the current user is the owner
  IF v_current_profile_id != p_owner_profile_id THEN
    RAISE EXCEPTION 'only profile owner can create channels';
  END IF;

  -- Verify that the profile is a sport entity profile
  IF NOT EXISTS (
    SELECT 1 FROM profiles p
    WHERE p.id = p_owner_profile_id
    AND p.user_type = 'sport_entity'
  ) THEN
    RAISE EXCEPTION 'only sport entity profiles can create channels';
  END IF;

  -- Build channel config JSONB
  v_channel_config := jsonb_build_object(
    'chat_type', 'channel',
    'channel_name', p_channel_name,
    'channel_logo_url', p_channel_logo_url,
    'sender_id', p_owner_profile_id::text,
    'is_read_only', true
  );

  -- Create chat with channel config
  INSERT INTO chats (
    name,
    config
  ) VALUES (
    p_channel_name,
    v_channel_config
  )
  RETURNING id INTO v_chat_id;

  -- Add owner to chat_members
  INSERT INTO chat_members (
    chat_id,
    profile_id,
    joined_at
  ) VALUES (
    v_chat_id,
    p_owner_profile_id,
    now()
  )
  ON CONFLICT (chat_id, profile_id) DO NOTHING;

  RETURN v_chat_id;
END;
$$;


ALTER FUNCTION public.create_channel(p_channel_name text, p_owner_profile_id uuid, p_channel_logo_url text) OWNER TO postgres;

--
-- Name: create_feedback_ticket(public.app_module, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_feedback_ticket(p_related_module public.app_module, p_recommendation text) RETURNS uuid
    LANGUAGE plpgsql
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


ALTER FUNCTION public.create_feedback_ticket(p_related_module public.app_module, p_recommendation text) OWNER TO postgres;

--
-- Name: create_opportunity(text, text, text, timestamp with time zone, real, real, text, smallint, smallint, jsonb, timestamp with time zone, smallint, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_opportunity(p_title text, p_description text, p_category text, p_deadline timestamp with time zone, p_latitude real, p_longitude real, p_address text, p_min_age smallint DEFAULT NULL::smallint, p_max_age smallint DEFAULT NULL::smallint, p_languages jsonb DEFAULT '[]'::jsonb, p_availability_date timestamp with time zone DEFAULT NULL::timestamp with time zone, p_min_experience_years smallint DEFAULT NULL::smallint, p_questions jsonb DEFAULT '[]'::jsonb) RETURNS uuid
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.create_opportunity(p_title text, p_description text, p_category text, p_deadline timestamp with time zone, p_latitude real, p_longitude real, p_address text, p_min_age smallint, p_max_age smallint, p_languages jsonb, p_availability_date timestamp with time zone, p_min_experience_years smallint, p_questions jsonb) OWNER TO postgres;

--
-- Name: create_profile_after_onboarding(public.user_type, text, smallint, smallint, text, text, text, text, text, text, text, date, uuid, public.individual_role, text, text, text, uuid, text, text, integer, text, text, jsonb, jsonb, jsonb, jsonb, public.sport_entity_type, text, text, text, jsonb, uuid, text, text, text, text, text, jsonb, jsonb, jsonb, jsonb, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_profile_after_onboarding(p_user_type public.user_type, p_bio text DEFAULT NULL::text, p_country_id smallint DEFAULT NULL::smallint, p_city_id smallint DEFAULT NULL::smallint, p_preferred_language text DEFAULT 'en'::text, p_first_name text DEFAULT NULL::text, p_last_name text DEFAULT NULL::text, p_username text DEFAULT NULL::text, p_email text DEFAULT NULL::text, p_image_url text DEFAULT NULL::text, p_gender text DEFAULT NULL::text, p_date_of_birth date DEFAULT NULL::date, p_primary_sport_id uuid DEFAULT NULL::uuid, p_sport_role public.individual_role DEFAULT NULL::public.individual_role, p_sport_goal text DEFAULT NULL::text, p_sport_category text DEFAULT NULL::text, p_academy_category text DEFAULT NULL::text, p_sport_entity_id uuid DEFAULT NULL::uuid, p_field_position text DEFAULT NULL::text, p_strong_foot text DEFAULT NULL::text, p_height_cm integer DEFAULT NULL::integer, p_player_status text DEFAULT NULL::text, p_coach_role text DEFAULT NULL::text, p_coach_certifications jsonb DEFAULT NULL::jsonb, p_coach_supervisions jsonb DEFAULT NULL::jsonb, p_referee_categories jsonb DEFAULT NULL::jsonb, p_referee_match_types jsonb DEFAULT NULL::jsonb, p_entity_type public.sport_entity_type DEFAULT NULL::public.sport_entity_type, p_entity_name text DEFAULT NULL::text, p_entity_username text DEFAULT NULL::text, p_entity_image_url text DEFAULT NULL::text, p_address jsonb DEFAULT NULL::jsonb, p_entity_primary_sport_id uuid DEFAULT NULL::uuid, p_contact_first_name text DEFAULT NULL::text, p_contact_last_name text DEFAULT NULL::text, p_contact_email text DEFAULT NULL::text, p_contact_phone text DEFAULT NULL::text, p_contact_website text DEFAULT NULL::text, p_club_categories jsonb DEFAULT NULL::jsonb, p_youth_leagues jsonb DEFAULT NULL::jsonb, p_adult_men_divisions jsonb DEFAULT NULL::jsonb, p_adult_women_divisions jsonb DEFAULT NULL::jsonb, p_federation_category text DEFAULT NULL::text) RETURNS public.profile_creation_result
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
    v_profile_id UUID;
    v_individual_profile_id UUID;
    v_entity_profile_id UUID;
    v_result profile_creation_result;
    v_existing_profile_count INTEGER;
    p_user_id TEXT;
    v_latest_season_id UUID;
    v_experience_category TEXT;
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
            username,
            bio,
            country_id,
            city_id,
            preferred_language
        ) VALUES (
            p_user_id,
            p_user_type,
            COALESCE(p_username, p_entity_username),
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
                coach_supervisions,
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
                p_coach_supervisions,
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
        
        -- Create initial experience for private_profile with official sport_goal
        IF p_user_type = 'private_profile' AND p_sport_goal = 'official' AND p_sport_entity_id IS NOT NULL THEN
            -- Determine experience category based on role and sport_category
            IF p_sport_role = 'player'::individual_role THEN
                -- Get the latest season for player
                SELECT id INTO v_latest_season_id 
                FROM public.seasons 
                ORDER BY end_date DESC 
                LIMIT 1;
                
                -- Determine category: academy_category if academy, 'U6' if adult
                IF p_sport_category = 'academy' THEN
                    v_experience_category := p_academy_category;
                ELSE
                    v_experience_category := 'U6';
                END IF;
                
                -- Create player experience
                PERFORM public.save_profile_experience(
                    p_sport_role := p_sport_role,
                    p_sport_entity_id := p_sport_entity_id,
                    p_season_id := v_latest_season_id,
                    p_category := v_experience_category
                );
                
            ELSIF p_sport_role = 'coach'::individual_role THEN
                -- Determine category: academy_category if academy, 'U6' if adult
                IF p_sport_category = 'academy' THEN
                    v_experience_category := p_academy_category;
                ELSE
                    v_experience_category := 'U6';
                END IF;
                
                -- Create coach experience
                PERFORM public.save_profile_experience(
                    p_sport_role := p_sport_role,
                    p_sport_entity_id := p_sport_entity_id,
                    p_category := v_experience_category,
                    p_coach_role := p_coach_role,
                    p_start_date := CURRENT_DATE,
                    p_end_date := CURRENT_DATE
                );
                
            ELSIF p_sport_role = 'referee'::individual_role THEN
                -- Create referee experience
                PERFORM public.save_profile_experience(
                    p_sport_role := p_sport_role,
                    p_sport_entity_id := p_sport_entity_id,
                    p_start_date := CURRENT_DATE,
                    p_end_date := CURRENT_DATE
                );
            END IF;
        END IF;
        
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


ALTER FUNCTION public.create_profile_after_onboarding(p_user_type public.user_type, p_bio text, p_country_id smallint, p_city_id smallint, p_preferred_language text, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_primary_sport_id uuid, p_sport_role public.individual_role, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb, p_referee_categories jsonb, p_referee_match_types jsonb, p_entity_type public.sport_entity_type, p_entity_name text, p_entity_username text, p_entity_image_url text, p_address jsonb, p_entity_primary_sport_id uuid, p_contact_first_name text, p_contact_last_name text, p_contact_email text, p_contact_phone text, p_contact_website text, p_club_categories jsonb, p_youth_leagues jsonb, p_adult_men_divisions jsonb, p_adult_women_divisions jsonb, p_federation_category text) OWNER TO postgres;

--
-- Name: create_session(uuid, public.session_type, timestamp without time zone, timestamp without time zone, timestamp without time zone, jsonb, text, uuid[], boolean, text, uuid, public.turf); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_session(p_team_id uuid, p_session_type public.session_type, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_location jsonb, p_description text, p_invited_members uuid[], p_attendance_hidden boolean DEFAULT false, p_session_name text DEFAULT NULL::text, p_opponent_team_id uuid DEFAULT NULL::uuid, p_turf public.turf DEFAULT NULL::public.turf) RETURNS uuid
    LANGUAGE plpgsql
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

  return v_team_session_id;

END
$$;


ALTER FUNCTION public.create_session(p_team_id uuid, p_session_type public.session_type, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_location jsonb, p_description text, p_invited_members uuid[], p_attendance_hidden boolean, p_session_name text, p_opponent_team_id uuid, p_turf public.turf) OWNER TO postgres;

--
-- Name: create_support_ticket(text, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_support_ticket(p_subject text, p_message text) RETURNS uuid
    LANGUAGE plpgsql
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


ALTER FUNCTION public.create_support_ticket(p_subject text, p_message text) OWNER TO postgres;

--
-- Name: create_team(uuid, text, text, uuid, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid DEFAULT NULL::uuid, p_members jsonb DEFAULT '[]'::jsonb) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
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


ALTER FUNCTION public.create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb) OWNER TO postgres;

--
-- Name: FUNCTION create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb) IS 'Creates a team, inserts team members, creates a team chat, and adds all team members to the chat. Returns team_id and chat_id.';


--
-- Name: edit_session(uuid, timestamp without time zone, timestamp without time zone, timestamp without time zone, text, jsonb, uuid[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.edit_session(p_session_id uuid, p_appointment_date timestamp without time zone DEFAULT NULL::timestamp without time zone, p_start_time timestamp without time zone DEFAULT NULL::timestamp without time zone, p_end_time timestamp without time zone DEFAULT NULL::timestamp without time zone, p_description text DEFAULT NULL::text, p_location jsonb DEFAULT NULL::jsonb, p_new_invitees uuid[] DEFAULT ARRAY[]::uuid[]) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Validate that session exists
  IF NOT EXISTS (SELECT 1 FROM team_sessions WHERE id = p_session_id) THEN
    RAISE EXCEPTION 'Session with id % does not exist', p_session_id;
  END IF;

  -- Update only the provided fields
  UPDATE team_sessions
  SET
    appointment_datetime = COALESCE(p_appointment_date, appointment_datetime),
    start_time = COALESCE(p_start_time, start_time),
    end_time = COALESCE(p_end_time, end_time),
    description = COALESCE(p_description, description),
    location = COALESCE(p_location, location)
  WHERE id = p_session_id;


    if array_length(p_new_invitees, 1) > 0 then
        INSERT INTO session_invitations (
            session_id,
            member_id,
            team_id,
            status
        )
        SELECT 
            p_session_id,
            UNNEST(p_new_invitees),
            (SELECT team_id FROM team_sessions WHERE id = p_session_id),
            'pending'::session_invitation_status
        ON CONFLICT (session_id, member_id) DO NOTHING;
    end if;



END
$$;


ALTER FUNCTION public.edit_session(p_session_id uuid, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_description text, p_location jsonb, p_new_invitees uuid[]) OWNER TO postgres;

--
-- Name: get_channels_for_profile(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_channels_for_profile(p_owner_profile_id text) RETURNS TABLE(chat_id uuid, channel_name text, channel_logo_url text, member_count bigint, is_subscribed boolean, owner_profile_id uuid, created_at timestamp with time zone, last_message text, last_message_time text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  v_current_user_profile_id UUID;
BEGIN
  -- Get current authenticated user profile_id server-side (SECURITY)
  v_current_user_profile_id := (SELECT profile_id());

  RETURN QUERY
  SELECT
    c.id AS chat_id,
    c.config->>'channel_name' AS channel_name,
    c.config->>'channel_logo_url' AS channel_logo_url,
    COUNT(DISTINCT cm.profile_id) AS member_count,
    CASE
      WHEN v_current_user_profile_id IS NULL THEN FALSE
      ELSE EXISTS (
        SELECT 1
        FROM chat_members cm2
        WHERE cm2.chat_id = c.id
        AND cm2.profile_id = v_current_user_profile_id
      )
    END AS is_subscribed,
    COALESCE(
      (c.config->>'owner_profile_id')::UUID,
      (c.config->>'sender_id')::UUID
    ) AS owner_profile_id,
    c.created_at,
    c.config->>'last_message' AS last_message,
    c.config->>'last_message_time' AS last_message_time
  FROM chats c
  LEFT JOIN chat_members cm ON cm.chat_id = c.id
  WHERE c.config->>'chat_type' = 'channel'
    AND (
      COALESCE(
        (c.config->>'owner_profile_id')::TEXT,
        (c.config->>'sender_id')::TEXT
      ) = COALESCE(p_owner_profile_id::TEXT, v_current_user_profile_id::TEXT)
    )
  GROUP BY
    c.id,
    c.config,
    c.created_at
  ORDER BY c.created_at DESC;
END;
$$;


ALTER FUNCTION public.get_channels_for_profile(p_owner_profile_id text) OWNER TO postgres;

--
-- Name: get_composition_by_session_id(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_composition_by_session_id(p_session_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_composition_by_session_id(p_session_id uuid) OWNER TO postgres;

--
-- Name: get_game_events_by_session_id(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_game_events_by_session_id(session_id uuid) RETURNS TABLE(id uuid, report_id uuid, events jsonb)
    LANGUAGE sql
    AS $$
  select 
    gs.id, 
    gs.report_id, 
    gs.events
  from session_report_game_stats gs
  join session_reports r on gs.report_id = r.id
  where r.session_id = get_game_events_by_session_id.session_id;
$$;


ALTER FUNCTION public.get_game_events_by_session_id(session_id uuid) OWNER TO postgres;

--
-- Name: get_invited_members(uuid, text, public.session_invitation_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_invited_members(p_session_id uuid, q text DEFAULT ''::text, q_status public.session_invitation_status DEFAULT NULL::public.session_invitation_status) RETURNS TABLE(id uuid, name text, avatar_url text, is_admin boolean, profile_id uuid, status public.session_invitation_status)
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_invited_members(p_session_id uuid, q text, q_status public.session_invitation_status) OWNER TO postgres;

--
-- Name: get_medical_reports(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_medical_reports(p_team_id uuid, q text DEFAULT ''::text) RETURNS TABLE(id uuid, member jsonb, severity public.medical_severity, cause public.session_type, injury_date timestamp with time zone, estimated_recovery_date timestamp with time zone, report text)
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_medical_reports(p_team_id uuid, q text) OWNER TO postgres;

--
-- Name: profile_id(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.profile_id() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$SELECT id FROM public.profiles WHERE profiles.user_id = public.uid()$$;


ALTER FUNCTION public.profile_id() OWNER TO postgres;

--
-- Name: uid(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uid() RETURNS text
    LANGUAGE sql STABLE
    AS $$ 
   select  
   	coalesce( 
 		current_setting('request.jwt.claim.sub', true), 
 		(current_setting('request.jwt.claims', true)::jsonb ->> 'sub') 
 	)::text 
 $$;


ALTER FUNCTION public.uid() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: opportunities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opportunities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    category public.opportunity_category NOT NULL,
    status public.opportunity_status DEFAULT 'published'::public.opportunity_status NOT NULL,
    deadline timestamp with time zone NOT NULL,
    created_by uuid NOT NULL,
    latitude real NOT NULL,
    longitude real NOT NULL,
    address text NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    updated_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL
);


ALTER TABLE public.opportunities OWNER TO postgres;

--
-- Name: TABLE opportunities; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.opportunities IS 'Main opportunities table with basic information';


--
-- Name: opportunity_applications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opportunity_applications (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    opportunity_id uuid NOT NULL,
    applicant_id uuid NOT NULL,
    status public.application_status DEFAULT 'pending'::public.application_status NOT NULL,
    answers jsonb DEFAULT '{}'::jsonb NOT NULL,
    applied_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL
);


ALTER TABLE public.opportunity_applications OWNER TO postgres;

--
-- Name: TABLE opportunity_applications; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.opportunity_applications IS 'Answers to opportunity questions from applicants';


--
-- Name: opportunity_requirements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.opportunity_requirements (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    opportunity_id uuid NOT NULL,
    min_age smallint NOT NULL,
    max_age smallint NOT NULL,
    min_experience_years smallint NOT NULL,
    availability_date timestamp with time zone NOT NULL,
    languages jsonb NOT NULL,
    questions jsonb DEFAULT '[]'::jsonb NOT NULL,
    CONSTRAINT check_languages_schema CHECK (extensions.jsonb_matches_schema('{
            "type": "array",
            "items": {
                "type": "string",
                "enum": ["Dutch", "French", "English"]
            },
            "uniqueItems": true,
            "maxItems": 10
        }'::json, languages)),
    CONSTRAINT check_questions_schema CHECK (extensions.jsonb_matches_schema('{
            "type": "array", 
            "items": {
                "type": "string",
                "minLength": 1,
                "maxLength": 500
            },
            "maxItems": 20
        }'::json, questions))
);


ALTER TABLE public.opportunity_requirements OWNER TO postgres;

--
-- Name: TABLE opportunity_requirements; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.opportunity_requirements IS 'Age, experience and availability requirements for opportunities';


--
-- Name: COLUMN opportunity_requirements.languages; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.opportunity_requirements.languages IS 'JSONB array of required languages for the opportunity';


--
-- Name: COLUMN opportunity_requirements.questions; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.opportunity_requirements.questions IS 'JSONB array of yes/no questions for applicants';


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id text DEFAULT public.uid() NOT NULL,
    user_type public.user_type NOT NULL,
    display_name text DEFAULT ''''''::text NOT NULL,
    bio text,
    avatar_url text,
    preferred_language text DEFAULT 'en'::text NOT NULL,
    country_id smallint NOT NULL,
    city_id smallint,
    username text NOT NULL,
    opt_in_contact boolean DEFAULT false,
    fcm_token text,
    is_active boolean DEFAULT false NOT NULL,
    first_name text,
    last_name text,
    email text,
    gender text,
    date_of_birth date
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: TABLE profiles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.profiles IS 'Main profile information for all user types';


--
-- Name: COLUMN profiles.display_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.display_name IS 'Generated column based on user_type and name from extended profile tables';


--
-- Name: COLUMN profiles.avatar_url; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.avatar_url IS 'Generated column based on image_url from extended profile tables';


--
-- Name: COLUMN profiles.opt_in_contact; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.opt_in_contact IS 'User chose to get contacted for feedback';


--
-- Name: COLUMN profiles.is_active; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.is_active IS 'Indicates if this is the currently active profile for the user';


--
-- Name: COLUMN profiles.first_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.first_name IS 'First name of the user';


--
-- Name: COLUMN profiles.last_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.last_name IS 'Last name of the user';


--
-- Name: COLUMN profiles.email; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.email IS 'Email address';


--
-- Name: COLUMN profiles.gender; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.gender IS 'Gender';


--
-- Name: COLUMN profiles.date_of_birth; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.date_of_birth IS 'Date of birth';


--
-- Name: saved_opportunities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_opportunities (
    profile_id uuid DEFAULT public.profile_id() NOT NULL,
    opportunity_id uuid NOT NULL
);


ALTER TABLE public.saved_opportunities OWNER TO postgres;

--
-- Name: opportunity_view; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.opportunity_view WITH (security_invoker='on') AS
 SELECT o.id,
    o.title,
    o.description,
    o.category,
    o.status,
    o.deadline,
    o.created_by,
    o.latitude,
    o.longitude,
    o.address,
    jsonb_build_object('latitude', o.latitude, 'longitude', o.longitude, 'address', o.address) AS location,
    jsonb_build_object('minAge', COALESCE((req.min_age)::integer, 0), 'maxAge', COALESCE((req.max_age)::integer, 100), 'languages', COALESCE(req.languages, '[]'::jsonb), 'availability', COALESCE(req.availability_date, o.deadline), 'minExperience', COALESCE((req.min_experience_years)::integer, 0), 'qandA', COALESCE(req.questions, '[]'::jsonb)) AS requirements,
    COALESCE(( SELECT jsonb_agg(jsonb_build_object('id', app.id, 'applicant', app.applicant_id, 'status', app.status, 'answers', app.answers, 'applied_at', app.applied_at)) AS jsonb_agg
           FROM public.opportunity_applications app
          WHERE (app.opportunity_id = o.id)), '[]'::jsonb) AS applicants,
    creator_profile.avatar_url AS image,
    creator_profile.display_name AS creator_name,
    creator_profile.user_type AS creator_type,
    o.created_at,
    o.updated_at,
    (EXISTS ( SELECT 1
           FROM public.saved_opportunities
          WHERE ((saved_opportunities.opportunity_id = o.id) AND (saved_opportunities.profile_id = public.profile_id())))) AS is_saved
   FROM ((public.opportunities o
     LEFT JOIN public.opportunity_requirements req ON ((req.opportunity_id = o.id)))
     LEFT JOIN public.profiles creator_profile ON ((creator_profile.id = o.created_by)));


ALTER VIEW public.opportunity_view OWNER TO postgres;

--
-- Name: get_nearby_opportunities(real, real, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_nearby_opportunities(p_latitude real, p_longitude real, p_limit integer DEFAULT 10) RETURNS SETOF public.opportunity_view
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
  v_point extensions.geography;
BEGIN
  -- Validate input coordinates
  IF p_latitude IS NULL OR p_longitude IS NULL THEN
    RAISE EXCEPTION 'Latitude and longitude cannot be NULL';
  END IF;
  
  -- Normalize coordinate ranges
  p_latitude := CASE 
    WHEN p_latitude > 90 THEN 90 - (p_latitude - 90)
    WHEN p_latitude < -90 THEN -90 + (-90 - p_latitude)
    ELSE p_latitude
  END;
  
  p_longitude := CASE 
    WHEN p_longitude > 180 THEN p_longitude - 360
    WHEN p_longitude < -180 THEN p_longitude + 360
    ELSE p_longitude
  END;
  -- Create geography point from input coordinates (cast to double precision)
  v_point := extensions.ST_SetSRID(extensions.ST_MakePoint(p_longitude::double precision, p_latitude::double precision), 4326)::extensions.geography;
  
  -- Return opportunities to near by location
  -- Using ST_Distance with geography type which returns meters
  -- Filter out NULL locations and ensure location has required fields
  RETURN QUERY
  SELECT *
  FROM opportunity_view
  WHERE location IS NOT NULL
    AND location->>'longitude' IS NOT NULL
    AND location->>'latitude' IS NOT NULL
  ORDER BY extensions.ST_Distance(
    extensions.ST_SetSRID(
        extensions.ST_MakePoint(
          (location->>'longitude')::double precision,
          (location->>'latitude')::double precision
        ),
        4326
      )::extensions.geography,
      v_point
    )
  LIMIT p_limit;
END;
$$;


ALTER FUNCTION public.get_nearby_opportunities(p_latitude real, p_longitude real, p_limit integer) OWNER TO postgres;

--
-- Name: get_opportunities_by_applicant(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_opportunities_by_applicant() RETURNS SETOF public.opportunity_view
    LANGUAGE sql
    AS $$

 SELECT * FROM public.opportunity_view v WHERE v.applicants @> format('[{"applicant":"%s"}]', 
 (SELECT id FROM public.profiles WHERE profiles.user_id = public.uid()))::jsonb;  

$$;


ALTER FUNCTION public.get_opportunities_by_applicant() OWNER TO postgres;

--
-- Name: get_opportunity_applicants(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_opportunity_applicants(p_opportunity_id uuid, p_q text DEFAULT NULL::text) RETURNS TABLE(answers jsonb, applied_at timestamp with time zone, status text, profile jsonb)
    LANGUAGE sql STABLE
    AS $$
  select
    oa.answers,
    oa.applied_at,
    oa.status,
    jsonb_build_object(
      'id', p.id,
      'user_id', p.user_id,
      'username', p.username,
      'display_name', p.display_name,
      'avatar_url', p.avatar_url,
      'user_type', p.user_type
    ) as profile
  from opportunity_applications oa
  join profiles p on p.id = oa.applicant_id
  where oa.opportunity_id = p_opportunity_id
    and (
      p_q is null
      or p.display_name ilike '%' || p_q || '%'
    )
  order by oa.applied_at desc;
$$;


ALTER FUNCTION public.get_opportunity_applicants(p_opportunity_id uuid, p_q text) OWNER TO postgres;

--
-- Name: get_profile_avatar_url(uuid, public.user_type); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_profile_avatar_url(p_profile_id uuid, user_type_val public.user_type) RETURNS text
    LANGUAGE plpgsql STABLE
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


ALTER FUNCTION public.get_profile_avatar_url(p_profile_id uuid, user_type_val public.user_type) OWNER TO postgres;

--
-- Name: get_profile_display_name(uuid, public.user_type); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_profile_display_name(p_profile_id uuid, user_type_val public.user_type) RETURNS text
    LANGUAGE plpgsql STABLE
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


ALTER FUNCTION public.get_profile_display_name(p_profile_id uuid, user_type_val public.user_type) OWNER TO postgres;

--
-- Name: get_profile_experiences(public.individual_role, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_profile_experiences(p_sport_role public.individual_role DEFAULT NULL::public.individual_role, p_profile_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, sport_role public.individual_role, image_url text, title text, category text, season text, start_date date, end_date date, role text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
  p_profile_id := COALESCE(
    p_profile_id,
    (SELECT profile_id())
  );

  RETURN QUERY
  SELECT
    pe.id,
    pe.sport_role,
    sep.image_url,
    sep.entity_name AS title,
    CASE
      WHEN pe.sport_role IN ('player'::public.individual_role, 'coach'::public.individual_role)
        THEN pe.category
      ELSE NULL
    END AS category,
    CASE
      WHEN pe.sport_role = 'player'::public.individual_role
        THEN s.name
      ELSE NULL
    END AS season,
    CASE
      WHEN pe.sport_role IN ('coach'::public.individual_role, 'referee'::public.individual_role)
        THEN pe.start_date
      ELSE NULL
    END AS start_date,
    CASE
      WHEN pe.sport_role IN ('coach'::public.individual_role, 'referee'::public.individual_role)
        THEN pe.end_date
      ELSE NULL
    END AS end_date,
    CASE
      WHEN pe.sport_role = 'coach'::public.individual_role
        THEN pe.coach_role
      ELSE NULL
    END AS role
  FROM public.profile_experiences pe
  LEFT JOIN public.individual_profiles ip ON pe.owner_id = ip.id
  LEFT JOIN public.sport_entity_profiles sep ON sep.id = pe.sport_entity_id
  LEFT JOIN public.seasons s ON pe.season_id = s.id
  WHERE
    pe.owner_id = p_profile_id
    AND (p_sport_role IS NULL OR pe.sport_role = p_sport_role);
END;
$$;


ALTER FUNCTION public.get_profile_experiences(p_sport_role public.individual_role, p_profile_id uuid) OWNER TO postgres;

--
-- Name: get_profile_id_by_team_member(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_profile_id_by_team_member(team_member_id uuid) RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  SELECT tm.member_id
  FROM public.team_members tm
  WHERE tm.id = team_member_id
  LIMIT 1;
$$;


ALTER FUNCTION public.get_profile_id_by_team_member(team_member_id uuid) OWNER TO postgres;

--
-- Name: get_ratings_by_session_id(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_ratings_by_session_id(p_session_id uuid) RETURNS SETOF jsonb
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_ratings_by_session_id(p_session_id uuid) OWNER TO postgres;

--
-- Name: get_report_by_id(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_report_by_id(p_report_id uuid) RETURNS TABLE(id uuid, is_completed boolean, session jsonb)
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_report_by_id(p_report_id uuid) OWNER TO postgres;

--
-- Name: get_reports(text, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_reports(p_session_type text, p_team_id uuid) RETURNS SETOF jsonb
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_reports(p_session_type text, p_team_id uuid) OWNER TO postgres;

--
-- Name: get_saved_opportunities(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_saved_opportunities() RETURNS SETOF public.opportunity_view
    LANGUAGE sql
    AS $$
SELECT ov.* 
FROM public.opportunity_view ov
INNER JOIN public.saved_opportunities so ON so.opportunity_id = ov.id
WHERE so.profile_id = (select public.profile_id());
$$;


ALTER FUNCTION public.get_saved_opportunities() OWNER TO postgres;

--
-- Name: get_session_details_for_user(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_session_details_for_user(p_session_id uuid) RETURNS jsonb
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_session_details_for_user(p_session_id uuid) OWNER TO postgres;

--
-- Name: get_sport_entity_profile(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_sport_entity_profile(p_profile_id uuid DEFAULT NULL::uuid) RETURNS TABLE(profile_id uuid, entity_type public.sport_entity_type, image_url text, name text, username text, number_of_opportunities integer, primary_sport_name text, primary_sport_icon text, contact_phone text, contact_email text, contact_website text, location jsonb, number_of_teams integer, youth_leagues jsonb, adult_men_divisions jsonb, adult_women_divisions jsonb)
    LANGUAGE sql
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
    COALESCE((
        SELECT COUNT(*)::integer FROM public.teams t WHERE t.associated_club = sep.id
      ), 0) AS number_of_teams,
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
    END AS adult_women_divisions
  FROM public.sport_entity_profiles sep
  LEFT JOIN public.sports s ON s.id = sep.primary_sport_id
  WHERE sep.profile_id = COALESCE(p_profile_id, (SELECT profile_id()));
$$;


ALTER FUNCTION public.get_sport_entity_profile(p_profile_id uuid) OWNER TO postgres;

--
-- Name: get_team_chat_id(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_chat_id(team_id uuid) RETURNS uuid
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (SELECT id FROM chats WHERE config->>'team_id' = team_id::text LIMIT 1);
END;
$$;


ALTER FUNCTION public.get_team_chat_id(team_id uuid) OWNER TO postgres;

--
-- Name: get_team_members(uuid, text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_members(p_team_id uuid, q text DEFAULT ''::text) RETURNS TABLE(id uuid, profile_id uuid, name text, avatar_url text, is_admin boolean)
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_team_members(p_team_id uuid, q text) OWNER TO postgres;

--
-- Name: get_team_profile(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_profile(p_team_id uuid) RETURNS TABLE(id uuid, name text, image_url text, notifications_count integer, recent_sessions jsonb, next_sessions jsonb, im_admin boolean)
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_team_profile(p_team_id uuid) OWNER TO postgres;

--
-- Name: get_team_statistics(uuid, integer, boolean); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_team_statistics(p_team_id uuid, p_matches_limit integer DEFAULT NULL::integer, p_order_descending boolean DEFAULT true) RETURNS jsonb
    LANGUAGE plpgsql
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


ALTER FUNCTION public.get_team_statistics(p_team_id uuid, p_matches_limit integer, p_order_descending boolean) OWNER TO postgres;

--
-- Name: get_teams(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_teams(p_profile_id uuid DEFAULT NULL::uuid) RETURNS TABLE(id uuid, name text, logo_url text, im_admin boolean)
    LANGUAGE sql STABLE
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


ALTER FUNCTION public.get_teams(p_profile_id uuid) OWNER TO postgres;

--
-- Name: insert_notify_me(jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insert_notify_me(p_data jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$BEGIN
    INSERT INTO notify_me (id, data)
    VALUES (uid(), p_data)
    ON CONFLICT (id) DO UPDATE
    SET data = EXCLUDED.data;
END;$$;


ALTER FUNCTION public.insert_notify_me(p_data jsonb) OWNER TO postgres;

--
-- Name: is_user_in_team(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_user_in_team(p_team_id uuid, p_profile_id uuid DEFAULT NULL::uuid) RETURNS boolean
    LANGUAGE plpgsql
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


ALTER FUNCTION public.is_user_in_team(p_team_id uuid, p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION is_user_in_team(p_team_id uuid, p_profile_id uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.is_user_in_team(p_team_id uuid, p_profile_id uuid) IS 'Checks if a user is in a team';


--
-- Name: is_user_team_admin(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_user_team_admin(p_team_id uuid, p_profile_id uuid DEFAULT NULL::uuid) RETURNS boolean
    LANGUAGE plpgsql
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


ALTER FUNCTION public.is_user_team_admin(p_team_id uuid, p_profile_id uuid) OWNER TO postgres;

--
-- Name: FUNCTION is_user_team_admin(p_team_id uuid, p_profile_id uuid); Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON FUNCTION public.is_user_team_admin(p_team_id uuid, p_profile_id uuid) IS 'Checks if a user is a team admin';


--
-- Name: join_channel(uuid, uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.join_channel(p_chat_id uuid, p_profile_id uuid DEFAULT NULL::uuid) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_profile_id UUID;
  v_chat_type TEXT;
BEGIN
  -- Get current user profile_id if not provided
  v_profile_id := COALESCE(p_profile_id, (SELECT profile_id()));
  IF v_profile_id IS NULL THEN
    RAISE EXCEPTION 'user must be authenticated';
  END IF;

  -- Validate chat_id
  IF p_chat_id IS NULL THEN
    RAISE EXCEPTION 'chat_id cannot be null';
  END IF;

  -- Verify that the chat is a channel
  SELECT config->>'chat_type' INTO v_chat_type
  FROM chats
  WHERE id = p_chat_id;

  IF v_chat_type IS NULL THEN
    RAISE EXCEPTION 'chat not found';
  END IF;

  IF v_chat_type != 'channel' THEN
    RAISE EXCEPTION 'can only join channels using this function';
  END IF;

  -- Add user to chat_members if not already a member
  INSERT INTO chat_members (
    chat_id,
    profile_id,
    joined_at
  ) VALUES (
    p_chat_id,
    v_profile_id,
    now()
  )
  ON CONFLICT (chat_id, profile_id) DO NOTHING;

  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.join_channel(p_chat_id uuid, p_profile_id uuid) OWNER TO postgres;

--
-- Name: save_profile_experience(public.individual_role, uuid, uuid, uuid, text, text, date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.save_profile_experience(p_sport_role public.individual_role, p_experience_id uuid DEFAULT NULL::uuid, p_sport_entity_id uuid DEFAULT NULL::uuid, p_season_id uuid DEFAULT NULL::uuid, p_category text DEFAULT NULL::text, p_coach_role text DEFAULT NULL::text, p_start_date date DEFAULT NULL::date, p_end_date date DEFAULT NULL::date) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_owner_id uuid;
  v_experience_id uuid;
BEGIN
  -- Get the current user's profile ID
  v_owner_id := profile_id();

  -- Validate required fields based on sport role
  IF p_sport_role = 'player'::individual_role THEN
    IF p_sport_entity_id IS NULL THEN
      RAISE EXCEPTION 'sport_entity_id is required for player';
    END IF;

    IF p_category IS NULL THEN
      RAISE EXCEPTION 'category is required for player';
    END IF;

    IF p_season_id IS NULL THEN
      RAISE EXCEPTION 'season_id is required for player';
    END IF;

  ELSIF p_sport_role = 'coach'::individual_role THEN
    IF p_sport_entity_id IS NULL THEN
      RAISE EXCEPTION 'sport_entity_id is required for coach';
    END IF;

    IF p_category IS NULL THEN
      RAISE EXCEPTION 'category is required for coach';
    END IF;

    IF p_coach_role IS NULL THEN
      RAISE EXCEPTION 'coach_role is required for coach';
    END IF;

    IF p_start_date IS NULL THEN
      RAISE EXCEPTION 'start_date is required for coach';
    END IF;

    IF p_end_date IS NULL THEN
      RAISE EXCEPTION 'end_date is required for coach';
    END IF;

  ELSIF p_sport_role = 'referee'::individual_role THEN
    IF p_sport_entity_id IS NULL THEN
      RAISE EXCEPTION 'sport_entity_id is required for referee';
    END IF;

    IF p_start_date IS NULL THEN
      RAISE EXCEPTION 'start_date is required for referee';
    END IF;

    IF p_end_date IS NULL THEN
      RAISE EXCEPTION 'end_date is required for referee';
    END IF;
  END IF;

  -- UPDATE case
  IF p_experience_id IS NOT NULL THEN
    UPDATE public.profile_experiences
    SET
      sport_role = p_sport_role,
      sport_entity_id = p_sport_entity_id,
      season_id = p_season_id,
      category = p_category,
      coach_role = p_coach_role,
      start_date = p_start_date,
      end_date = p_end_date
    WHERE
      id = p_experience_id
      AND owner_id = v_owner_id
    RETURNING id INTO v_experience_id;

    IF v_experience_id IS NULL THEN
      RAISE EXCEPTION 'Experience not found or you do not have permission to update it';
    END IF;

  -- INSERT case
  ELSE
    INSERT INTO public.profile_experiences (
      owner_id,
      sport_role,
      sport_entity_id,
      season_id,
      category,
      coach_role,
      start_date,
      end_date
    )
    VALUES (
      v_owner_id,
      p_sport_role,
      p_sport_entity_id,
      p_season_id,
      p_category,
      p_coach_role,
      p_start_date,
      p_end_date
    )
    RETURNING id INTO v_experience_id;
  END IF;

  RETURN v_experience_id::text;
END;
$$;


ALTER FUNCTION public.save_profile_experience(p_sport_role public.individual_role, p_experience_id uuid, p_sport_entity_id uuid, p_season_id uuid, p_category text, p_coach_role text, p_start_date date, p_end_date date) OWNER TO postgres;

--
-- Name: search_engine(text, text[], smallint, smallint, smallint, smallint, text[], text[], text[], uuid[], text[], text[], text[], smallint, smallint, text[], text[], text[], uuid[], text[], text[], text[], uuid[], text[], text[], text[]); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.search_engine(p_query text DEFAULT NULL::text, p_profile_types text[] DEFAULT ARRAY[]::text[], p_min_age smallint DEFAULT NULL::smallint, p_max_age smallint DEFAULT NULL::smallint, p_location_city smallint DEFAULT NULL::smallint, p_location_radius smallint DEFAULT NULL::smallint, p_genders text[] DEFAULT ARRAY[]::text[], p_player_categories text[] DEFAULT ARRAY[]::text[], p_player_young_leagues text[] DEFAULT ARRAY[]::text[], p_player_clubs uuid[] DEFAULT ARRAY[]::uuid[], p_player_levels text[] DEFAULT ARRAY[]::text[], p_player_positions text[] DEFAULT ARRAY[]::text[], p_player_strong_foot text[] DEFAULT ARRAY[]::text[], p_player_height_min smallint DEFAULT NULL::smallint, p_player_height_max smallint DEFAULT NULL::smallint, p_player_status text[] DEFAULT ARRAY[]::text[], p_coach_categories text[] DEFAULT ARRAY[]::text[], p_coach_young_leagues text[] DEFAULT ARRAY[]::text[], p_coach_clubs uuid[] DEFAULT ARRAY[]::uuid[], p_coach_levels text[] DEFAULT ARRAY[]::text[], p_coach_roles text[] DEFAULT ARRAY[]::text[], p_coach_certifications text[] DEFAULT ARRAY[]::text[], p_referee_federations uuid[] DEFAULT ARRAY[]::uuid[], p_referee_match_types text[] DEFAULT ARRAY[]::text[], p_club_levels text[] DEFAULT ARRAY[]::text[], p_federation_levels text[] DEFAULT ARRAY[]::text[]) RETURNS TABLE(id uuid, image_url text, name text, sport text, sport_entity_name text, user_type text)
    LANGUAGE plpgsql
    AS $$ 
BEGIN 
  RETURN QUERY 
  WITH city_location AS (
    SELECT
      cities.latitude,
      cities.longitude
    FROM
      cities
    WHERE
      cities.id = p_location_city
  ),
  individual_results AS (
    SELECT
      p.id AS id,
      p.avatar_url AS image_url,
      p.display_name AS name,
      s.name AS sport,
      sep.entity_name AS sport_entity_name,
      p.user_type :: TEXT AS user_type
    FROM
      profiles p
      INNER JOIN individual_profiles ip ON p.id = ip.profile_id
      LEFT JOIN sports s ON ip.primary_sport_id = s.id
      LEFT JOIN sport_entity_profiles sep ON ip.sport_entity_id = sep.id
      LEFT JOIN cities c ON ip.city_id = c.id
      LEFT JOIN LATERAL (
        SELECT
          city_location.latitude,
          city_location.longitude
        FROM
          city_location
      ) cl ON TRUE
    WHERE
      -- Query filter: search in first_name, last_name, username
      (
        p_query IS NULL
        OR (
          ip.first_name ILIKE '%' || p_query || '%'
          OR ip.last_name ILIKE '%' || p_query || '%'
          OR ip.username ILIKE '%' || p_query || '%'
        )
      ) -- Profile types filter: match sport_role
      AND (
        array_length(p_profile_types, 1) IS NULL
        OR ip.sport_role :: TEXT = ANY(p_profile_types)
      ) -- Age filters: calculate age from date_of_birth
      AND (
        p_min_age IS NULL
        OR EXTRACT(
          YEAR
          FROM
            AGE(ip.date_of_birth)
        ) >= p_min_age
      )
      AND (
        p_max_age IS NULL
        OR EXTRACT(
          YEAR
          FROM
            AGE(ip.date_of_birth)
        ) <= p_max_age
      ) -- Location filter: city_id
      AND (
        p_location_city IS NULL
        OR ip.city_id = p_location_city
      ) -- Location radius filter: calculate distance using PostGIS ST_DWithin
      AND (
        p_location_radius IS NULL
        OR p_location_city IS NULL
        OR c.latitude IS NULL
        OR c.longitude IS NULL
        OR cl.latitude IS NULL
        OR cl.longitude IS NULL
        OR ST_DWithin(
          ST_MakePoint(c.longitude, c.latitude)::geography,
          ST_MakePoint(cl.longitude, cl.latitude)::geography,
          p_location_radius * 1000
        )
      ) -- Gender filter
      AND (
        array_length(p_genders, 1) IS NULL
        OR ip.gender = ANY(p_genders)
      ) -- Player-specific filters (only when sport_role = 'player')
      AND (
        ip.sport_role != 'player'
        OR (
          -- Player categories filter
          (
            array_length(p_player_categories, 1) IS NULL
            OR ip.sport_category = ANY(p_player_categories)
          ) -- Player young leagues filter: check if sport entity's youth_leagues JSONB contains any of the specified leagues
          AND (
            array_length(p_player_young_leagues, 1) IS NULL
            OR sep.youth_leagues IS NULL
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_each_text(sep.youth_leagues) AS league_entry
              WHERE
                league_entry.value = ANY(p_player_young_leagues)
                OR EXISTS (
                  SELECT
                    1
                  FROM
                    jsonb_array_elements_text(league_entry.value :: jsonb) AS league_value
                  WHERE
                    league_value = ANY(p_player_young_leagues)
                )
            )
          ) -- Player clubs filter
          AND (
            array_length(p_player_clubs, 1) IS NULL
            OR ip.sport_entity_id = ANY(p_player_clubs)
          ) -- Player levels filter: check if sport entity's adult_men_divisions or adult_women_divisions JSONB contains any of the specified levels
          AND (
            array_length(p_player_levels, 1) IS NULL
            OR (sep.adult_men_divisions IS NULL AND sep.adult_women_divisions IS NULL)
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_each_text(COALESCE(sep.adult_men_divisions, '{}' :: jsonb)) AS div_entry
              WHERE
                div_entry.value = ANY(p_player_levels)
                OR EXISTS (
                  SELECT
                    1
                  FROM
                    jsonb_array_elements_text(div_entry.value :: jsonb) AS level_value
                  WHERE
                    level_value = ANY(p_player_levels)
                )
            )
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_each_text(COALESCE(sep.adult_women_divisions, '{}' :: jsonb)) AS div_entry
              WHERE
                div_entry.value = ANY(p_player_levels)
                OR EXISTS (
                  SELECT
                    1
                  FROM
                    jsonb_array_elements_text(div_entry.value :: jsonb) AS level_value
                  WHERE
                    level_value = ANY(p_player_levels)
                )
            )
          ) -- Player positions filter
          AND (
            array_length(p_player_positions, 1) IS NULL
            OR ip.field_position = ANY(p_player_positions)
          ) -- Player strong foot filter
          AND (
            array_length(p_player_strong_foot, 1) IS NULL
            OR ip.strong_foot = ANY(p_player_strong_foot)
          ) -- Player height filter
          AND (
            p_player_height_min IS NULL
            OR ip.height_cm IS NULL
            OR ip.height_cm >= p_player_height_min
          )
          AND (
            p_player_height_max IS NULL
            OR ip.height_cm IS NULL
            OR ip.height_cm <= p_player_height_max
          ) -- Player status filter
          AND (
            array_length(p_player_status, 1) IS NULL
            OR ip.player_status = ANY(p_player_status)
          )
        )
      ) -- Coach-specific filters (only when sport_role = 'coach')
      AND (
        ip.sport_role != 'coach'
        OR (
          -- Coach categories filter
          (
            array_length(p_coach_categories, 1) IS NULL
            OR ip.sport_category = ANY(p_coach_categories)
          ) -- Coach young leagues filter: check if sport entity's youth_leagues JSONB contains any of the specified leagues
          AND (
            array_length(p_coach_young_leagues, 1) IS NULL
            OR sep.youth_leagues IS NULL
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_each_text(sep.youth_leagues) AS league_entry
              WHERE
                league_entry.value = ANY(p_coach_young_leagues)
                OR EXISTS (
                  SELECT
                    1
                  FROM
                    jsonb_array_elements_text(league_entry.value :: jsonb) AS league_value
                  WHERE
                    league_value = ANY(p_coach_young_leagues)
                )
            )
          ) -- Coach clubs filter
          AND (
            array_length(p_coach_clubs, 1) IS NULL
            OR ip.sport_entity_id = ANY(p_coach_clubs)
          ) -- Coach levels filter: check if sport entity's adult_men_divisions or adult_women_divisions JSONB contains any of the specified levels
          AND (
            array_length(p_coach_levels, 1) IS NULL
            OR (sep.adult_men_divisions IS NULL AND sep.adult_women_divisions IS NULL)
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_each_text(COALESCE(sep.adult_men_divisions, '{}' :: jsonb)) AS div_entry
              WHERE
                div_entry.value = ANY(p_coach_levels)
                OR EXISTS (
                  SELECT
                    1
                  FROM
                    jsonb_array_elements_text(div_entry.value :: jsonb) AS level_value
                  WHERE
                    level_value = ANY(p_coach_levels)
                )
            )
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_each_text(COALESCE(sep.adult_women_divisions, '{}' :: jsonb)) AS div_entry
              WHERE
                div_entry.value = ANY(p_coach_levels)
                OR EXISTS (
                  SELECT
                    1
                  FROM
                    jsonb_array_elements_text(div_entry.value :: jsonb) AS level_value
                  WHERE
                    level_value = ANY(p_coach_levels)
                )
            )
          ) -- Coach roles filter
          AND (
            array_length(p_coach_roles, 1) IS NULL
            OR ip.coach_role = ANY(p_coach_roles)
          ) -- Coach certifications filter: check if coach_certifications JSONB array contains any of the specified certifications
          AND (
            array_length(p_coach_certifications, 1) IS NULL
            OR ip.coach_certifications IS NULL
            OR ip.coach_certifications ?| p_coach_certifications
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_array_elements_text(ip.coach_certifications) AS cert_value
              WHERE
                cert_value = ANY(p_coach_certifications)
            )
          )
        )
      ) -- Referee-specific filters (only when sport_role = 'referee')
      AND (
        ip.sport_role != 'referee'
        OR (
          -- Referee federations filter: must be linked to a federation entity
          (
            array_length(p_referee_federations, 1) IS NULL
            OR (
              ip.sport_entity_id = ANY(p_referee_federations)
              AND sep.entity_type = 'federation'
            )
          ) -- Referee match types filter: check if referee_match_types JSONB array contains any of the specified match types
          AND (
            array_length(p_referee_match_types, 1) IS NULL
            OR ip.referee_match_types IS NULL
            OR ip.referee_match_types ?| p_referee_match_types
            OR EXISTS (
              SELECT
                1
              FROM
                jsonb_array_elements_text(ip.referee_match_types) AS match_type_value
              WHERE
                match_type_value = ANY(p_referee_match_types)
            )
          )
        )
      )
  ),
  sport_entity_results AS (
    SELECT
      p.id AS id,
      p.avatar_url AS image_url,
      p.display_name AS name,
      s.name AS sport,
      NULL :: TEXT AS sport_entity_name,
      p.user_type :: TEXT AS user_type
    FROM
      profiles p
      INNER JOIN sport_entity_profiles sep ON p.id = sep.profile_id
      LEFT JOIN sports s ON sep.primary_sport_id = s.id
      LEFT JOIN cities c ON sep.city_id = c.id
      LEFT JOIN LATERAL (
        SELECT
          city_location.latitude,
          city_location.longitude
        FROM
          city_location
      ) cl ON TRUE
    WHERE
      -- Query filter: search in entity_name, username
      (
        p_query IS NULL
        OR (
          sep.entity_name ILIKE '%' || p_query || '%'
          OR sep.username ILIKE '%' || p_query || '%'
        )
      ) -- Profile types filter: match entity_type
      AND (
        array_length(p_profile_types, 1) IS NULL
        OR sep.entity_type :: TEXT = ANY(p_profile_types)
      ) -- Location filter: city_id
      AND (
        p_location_city IS NULL
        OR sep.city_id = p_location_city
      ) -- Location radius filter: calculate distance using PostGIS ST_DWithin
      AND (
        p_location_radius IS NULL
        OR p_location_city IS NULL
        OR c.latitude IS NULL
        OR c.longitude IS NULL
        OR cl.latitude IS NULL
        OR cl.longitude IS NULL
        OR ST_DWithin(
          ST_MakePoint(c.longitude, c.latitude)::geography,
          ST_MakePoint(cl.longitude, cl.latitude)::geography,
          p_location_radius * 1000
        )
      ) -- Club-specific filters (only when entity_type = 'club')
      AND (
        sep.entity_type != 'club'
        OR (
          -- Club levels filter: check if club_categories JSONB contains any of the specified levels
          array_length(p_club_levels, 1) IS NULL
          OR sep.club_categories IS NULL
          OR EXISTS (
            SELECT
              1
            FROM
              jsonb_each_text(sep.club_categories) AS category_entry
            WHERE
              category_entry.value = ANY(p_club_levels)
              OR EXISTS (
                SELECT
                  1
                FROM
                  jsonb_array_elements_text(category_entry.value :: jsonb) AS level_value
                WHERE
                  level_value = ANY(p_club_levels)
              )
          )
        )
      ) -- Federation-specific filters (only when entity_type = 'federation')
      AND (
        sep.entity_type != 'federation'
        OR (
          -- Federation levels filter
          array_length(p_federation_levels, 1) IS NULL
          OR sep.federation_category = ANY(p_federation_levels)
        )
      )
  ) -- Combine results from both individual and sport entity profiles
  SELECT
    result_set.id,
    result_set.image_url,
    result_set.name,
    result_set.sport,
    result_set.sport_entity_name,
    result_set.user_type
  FROM (
    SELECT
      individual_results.id AS id,
      individual_results.image_url AS image_url,
      individual_results.name AS name,
      individual_results.sport AS sport,
      individual_results.sport_entity_name AS sport_entity_name,
      individual_results.user_type AS user_type
    FROM
      individual_results
    UNION ALL
    SELECT
      sport_entity_results.id AS id,
      sport_entity_results.image_url AS image_url,
      sport_entity_results.name AS name,
      sport_entity_results.sport AS sport,
      sport_entity_results.sport_entity_name AS sport_entity_name,
      sport_entity_results.user_type AS user_type
    FROM
      sport_entity_results
  ) AS result_set;
END;
$$;


ALTER FUNCTION public.search_engine(p_query text, p_profile_types text[], p_min_age smallint, p_max_age smallint, p_location_city smallint, p_location_radius smallint, p_genders text[], p_player_categories text[], p_player_young_leagues text[], p_player_clubs uuid[], p_player_levels text[], p_player_positions text[], p_player_strong_foot text[], p_player_height_min smallint, p_player_height_max smallint, p_player_status text[], p_coach_categories text[], p_coach_young_leagues text[], p_coach_clubs uuid[], p_coach_levels text[], p_coach_roles text[], p_coach_certifications text[], p_referee_federations uuid[], p_referee_match_types text[], p_club_levels text[], p_federation_levels text[]) OWNER TO postgres;

--
-- Name: send_message(uuid, text, jsonb); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.send_message(p_chat_id uuid, p_message text, p_attachments jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_message_id UUID;
    v_timestamp TIMESTAMPTZ;
    v_timestamp_text TEXT;
    v_created_by UUID;
    attachments_json JSONB;
    message_payload JSONB;
    v_chat_type TEXT;
    v_channel_owner_id TEXT;
BEGIN
    -- Validate inputs
    IF p_chat_id IS NULL THEN
        RAISE EXCEPTION 'chat_id cannot be null';
    END IF;

    IF p_message IS NULL OR TRIM(p_message) = '' AND (p_attachments IS NULL OR jsonb_array_length(p_attachments) = 0) THEN
        RAISE EXCEPTION 'message cannot be null or empty';
    END IF;

    -- Get current user profile_id
    v_created_by := (SELECT profile_id());
    IF v_created_by IS NULL THEN
        RAISE EXCEPTION 'user must be authenticated';
    END IF;

    -- Check if this is a channel and enforce read-only permissions
    SELECT config->>'chat_type', config->>'sender_id'
    INTO v_chat_type, v_channel_owner_id
    FROM chats
    WHERE id = p_chat_id;

    IF v_chat_type = 'channel' THEN
        -- Verify that the sender is the channel owner
        IF v_channel_owner_id IS NULL OR v_channel_owner_id::UUID != v_created_by THEN
            RAISE EXCEPTION 'only channel owner can send messages';
        END IF;
    END IF;

    -- Insert the message
    INSERT INTO messages (chat_id, content, created_by, created_at)
    VALUES (p_chat_id, p_message, v_created_by, now())
    RETURNING id, created_at INTO v_message_id, v_timestamp;

    -- Format timestamp as ISO 8601 string for JSON payload
    v_timestamp_text := (v_timestamp AT TIME ZONE 'UTC')::text;

    -- Update the chat config with the last message and time
    UPDATE chats
    SET config = config || jsonb_build_object(
        'last_message', p_message,
        'last_message_time', v_timestamp_text,
        'last_message_sender', v_created_by::text
    )
    WHERE id = p_chat_id;

    -- Insert attachments if provided
    IF p_attachments IS NOT NULL AND jsonb_array_length(p_attachments) > 0 THEN
        INSERT INTO message_attachments (message_id, name, type, url, mime_type, size)
        SELECT
            v_message_id,
            attachment->>'name',
            (attachment->>'type')::attachment_type,
            attachment->>'url',
            attachment->>'mime_type',
            (attachment->>'size')::integer
        FROM jsonb_array_elements(p_attachments) AS attachment;
    END IF;

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
    WHERE ma.message_id = v_message_id;

    -- Build the message payload matching the query structure
    message_payload := jsonb_build_object(
        'id', v_message_id,
        'chat_id', p_chat_id,
        'created_by', v_created_by::text,
        'content', p_message,
        'created_at', v_timestamp_text,
        'attachments', attachments_json
    );

    -- Broadcast the message using realtime.send
    PERFORM realtime.send(
        message_payload,                    -- JSONB Payload
        'new_message',                      -- Event name
        'chat:' || p_chat_id::text,         -- Topic (chat-specific channel)
        TRUE                                -- Private flag
    );

EXCEPTION
    WHEN OTHERS THEN
        -- Log error and re-raise
        RAISE LOG 'ERROR in send_message for chat_id: % - SQLSTATE: %, SQLERRM: %',
            p_chat_id, SQLSTATE, SQLERRM;
        RAISE;
END;
$$;


ALTER FUNCTION public.send_message(p_chat_id uuid, p_message text, p_attachments jsonb) OWNER TO postgres;

--
-- Name: set_preferred_language(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_preferred_language(p_language text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_allowed_languages TEXT[] := ARRAY['en', 'fr', 'nl'];
BEGIN

    IF p_language IS NULL OR p_language = '' THEN
        RAISE EXCEPTION 'language cannot be null or empty';
    END IF;
    -- temporary fix for gb language code
    if p_language = 'gb' THEN p_language := 'en'; END IF;
    IF p_language NOT IN (SELECT UNNEST(v_allowed_languages)) THEN
        RAISE EXCEPTION 'language "%" must be one of: %', p_language, v_allowed_languages;
    END IF;

    UPDATE public.profiles
    SET preferred_language = p_language
    WHERE id = (SELECT profile_id());

    RETURN;
END;
$$;


ALTER FUNCTION public.set_preferred_language(p_language text) OWNER TO postgres;

--
-- Name: toggle_save_opportunity(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.toggle_save_opportunity(p_opportunity_id uuid) RETURNS void
    LANGUAGE plpgsql
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


ALTER FUNCTION public.toggle_save_opportunity(p_opportunity_id uuid) OWNER TO postgres;

--
-- Name: trigger_member_session_invitation_notification(uuid); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_member_session_invitation_notification(p_session_id uuid) RETURNS jsonb
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_member_preferences JSONB[];
    v_team_id UUID;
    v_invited_member_ids UUID[];
    v_params JSONB;
BEGIN
    RAISE LOG '[DEBUG] Manual member session invitation notification triggered, session_id: %', p_session_id;

    -- Get team_id for this session
    SELECT ts.team_id INTO v_team_id
    FROM public.team_sessions ts
    WHERE ts.id = p_session_id;

    IF v_team_id IS NULL THEN
        RAISE EXCEPTION 'Session % not found', p_session_id;
    END IF;

    RAISE LOG '[DEBUG] Processing session_id: %, team_id: %', p_session_id, v_team_id;

    -- Get all profile IDs for members invited to this session
    SELECT ARRAY_AGG(DISTINCT tm.member_id) INTO v_invited_member_ids
    FROM public.session_invitations si
    INNER JOIN public.team_members tm ON si.member_id = tm.id
    WHERE si.session_id = p_session_id
    AND si.status = 'pending'::session_invitation_status;

    -- If no members found, return early
    IF v_invited_member_ids IS NULL OR array_length(v_invited_member_ids, 1) = 0 THEN
        RAISE LOG '[DEBUG] No pending invitations found for session %', p_session_id;
        RETURN jsonb_build_object(
            'success', true,
            'sessions_processed', 0,
            'notifications_sent', 0
        );
    END IF;

    RAISE LOG '[DEBUG] Found % invited members for session %', array_length(v_invited_member_ids, 1), p_session_id;

    -- Get notification preferences for all invited members (using profile_id)
    SELECT ARRAY_AGG(notifications.profile_notifications_preferences(profile_id))
    INTO v_member_preferences
    FROM UNNEST(v_invited_member_ids) AS profile_id
    WHERE notifications.profile_notifications_preferences(profile_id) IS NOT NULL;

    -- If no preferences found, return early
    IF v_member_preferences IS NULL OR array_length(v_member_preferences, 1) = 0 THEN
        RAISE LOG '[DEBUG] No notification preferences found for invited members in session %', p_session_id;
        RETURN jsonb_build_object(
            'success', true,
            'sessions_processed', 1,
            'notifications_sent', 0
        );
    END IF;

    SELECT jsonb_build_object(
        'SessionName', ts.name,
        'date', ts.appointment_datetime::date,
        'time', ts.appointment_datetime::time
    )
    INTO v_params
    FROM public.team_sessions ts
    WHERE ts.id = p_session_id;

    RAISE LOG '[DEBUG] Notification parameters: %', v_params;

    -- Send notifications to all invited members for this session
    PERFORM notifications.send_notification(
        p_template_id := 'rsvp_reminder_24h_immediate',
        p_targets := v_member_preferences,
        p_route := '/teams/' || v_team_id || '/planning/' || p_session_id,
        p_params := v_params
    );

    RAISE LOG '[DEBUG] Sent session invitation notifications to % members for session %', 
        array_length(v_member_preferences, 1), p_session_id;

    RETURN jsonb_build_object(
        'success', true,
        'sessions_processed', 1,
        'notifications_sent', array_length(v_member_preferences, 1)
    );
END;
$$;


ALTER FUNCTION public.trigger_member_session_invitation_notification(p_session_id uuid) OWNER TO postgres;

--
-- Name: update_last_updated(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_last_updated() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  new.last_updated = now();
  return new;
end;
$$;


ALTER FUNCTION public.update_last_updated() OWNER TO postgres;

--
-- Name: update_opportunity_application_status(uuid, uuid, public.application_status); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_opportunity_application_status(p_opportunity_id uuid, p_applicant_id uuid, p_status public.application_status) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Update the opportunity application status
    UPDATE opportunity_applications
    SET status = p_status
    WHERE opportunity_id = p_opportunity_id
      AND applicant_id = p_applicant_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'No opportunity application found for the given opportunity and applicant';
    END IF;

END;
$$;


ALTER FUNCTION public.update_opportunity_application_status(p_opportunity_id uuid, p_applicant_id uuid, p_status public.application_status) OWNER TO postgres;

--
-- Name: update_profile_generated_columns(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_profile_generated_columns() RETURNS trigger
    LANGUAGE plpgsql
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


ALTER FUNCTION public.update_profile_generated_columns() OWNER TO postgres;

--
-- Name: user_opt_in_contacting(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.user_opt_in_contacting() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    UPDATE profiles
    SET opt_in_contact = true 
    WHERE id = (SELECT profile_id());
END;
$$;


ALTER FUNCTION public.user_opt_in_contacting() OWNER TO postgres;

--
-- Name: validate_composition(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_composition() RETURNS trigger
    LANGUAGE plpgsql
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


ALTER FUNCTION public.validate_composition() OWNER TO postgres;

--
-- Name: communication_schedule_rules; Type: TABLE; Schema: notifications; Owner: postgres
--

CREATE TABLE notifications.communication_schedule_rules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id text NOT NULL,
    delay text,
    recurrence_pattern text,
    max_occurrences integer,
    stop_after_duration text,
    quiet_hours_start time with time zone,
    quiet_hours_end time with time zone
);


ALTER TABLE notifications.communication_schedule_rules OWNER TO postgres;

--
-- Name: TABLE communication_schedule_rules; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON TABLE notifications.communication_schedule_rules IS 'Rules defining when and how often notifications should be sent';


--
-- Name: COLUMN communication_schedule_rules.id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.id IS 'Unique identifier for the schedule rule';


--
-- Name: COLUMN communication_schedule_rules.template_id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.template_id IS 'Reference to the communication template this rule applies to';


--
-- Name: COLUMN communication_schedule_rules.delay; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.delay IS 'Delay after trigger event (e.g., 1h, 2d, 1w)';


--
-- Name: COLUMN communication_schedule_rules.recurrence_pattern; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.recurrence_pattern IS 'Cron expression or simple pattern for recurring notifications';


--
-- Name: COLUMN communication_schedule_rules.max_occurrences; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.max_occurrences IS 'Maximum number of times to send this notification (NULL for unlimited)';


--
-- Name: COLUMN communication_schedule_rules.stop_after_duration; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.stop_after_duration IS 'Stop sending notifications after this duration regardless of max_occurrences';


--
-- Name: COLUMN communication_schedule_rules.quiet_hours_start; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.quiet_hours_start IS 'Start time for quiet hours when notifications should not be sent';


--
-- Name: COLUMN communication_schedule_rules.quiet_hours_end; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_schedule_rules.quiet_hours_end IS 'End time for quiet hours when notifications should not be sent';


--
-- Name: communication_templates; Type: TABLE; Schema: notifications; Owner: postgres
--

CREATE TABLE notifications.communication_templates (
    id text NOT NULL,
    channel notifications.channel_type NOT NULL,
    description text DEFAULT ''::text,
    title_key text NOT NULL,
    body_key text NOT NULL,
    delivery_type notifications.delivery_type NOT NULL
);


ALTER TABLE notifications.communication_templates OWNER TO postgres;

--
-- Name: TABLE communication_templates; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON TABLE notifications.communication_templates IS 'Templates for different types of communications';


--
-- Name: COLUMN communication_templates.id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates.id IS 'Unique template identifier (e.g., welcome_email, cart_reminder)';


--
-- Name: COLUMN communication_templates.channel; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates.channel IS 'Communication channel type (email, sms, push)';


--
-- Name: COLUMN communication_templates.description; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates.description IS 'Human-readable description of what this template is for';


--
-- Name: COLUMN communication_templates.title_key; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates.title_key IS 'Localization key for the notification title';


--
-- Name: COLUMN communication_templates.body_key; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates.body_key IS 'Localization key for the notification body';


--
-- Name: COLUMN communication_templates.delivery_type; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates.delivery_type IS 'How the notification should be delivered (immediate, scheduled, recurring)';


--
-- Name: communication_templates_assets; Type: TABLE; Schema: notifications; Owner: postgres
--

CREATE TABLE notifications.communication_templates_assets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_id text NOT NULL,
    asset_url text,
    icon text,
    color text,
    route text,
    payload jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE notifications.communication_templates_assets OWNER TO postgres;

--
-- Name: TABLE communication_templates_assets; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON TABLE notifications.communication_templates_assets IS 'Assets and metadata associated with communication templates';


--
-- Name: COLUMN communication_templates_assets.id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.id IS 'Unique identifier for the asset record';


--
-- Name: COLUMN communication_templates_assets.template_id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.template_id IS 'Reference to the communication template this asset belongs to';


--
-- Name: COLUMN communication_templates_assets.asset_url; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.asset_url IS 'URL to an external asset like an image or icon';


--
-- Name: COLUMN communication_templates_assets.icon; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.icon IS 'Icon identifier or name for the notification';


--
-- Name: COLUMN communication_templates_assets.color; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.color IS 'Color code for the notification (hex, rgb, etc.)';


--
-- Name: COLUMN communication_templates_assets.route; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.route IS 'Deep link or route for navigation when notification is tapped';


--
-- Name: COLUMN communication_templates_assets.payload; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.communication_templates_assets.payload IS 'Additional JSON data payload for the notification';


--
-- Name: lanaguages; Type: TABLE; Schema: notifications; Owner: postgres
--

CREATE TABLE notifications.lanaguages (
    id text NOT NULL,
    name text NOT NULL,
    native_name text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE notifications.lanaguages OWNER TO postgres;

--
-- Name: TABLE lanaguages; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON TABLE notifications.lanaguages IS 'Supported languages for notification localization';


--
-- Name: COLUMN lanaguages.id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.lanaguages.id IS 'Language code in ISO 639-1 format';


--
-- Name: COLUMN lanaguages.name; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.lanaguages.name IS 'English name of the language';


--
-- Name: COLUMN lanaguages.native_name; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.lanaguages.native_name IS 'Native name of the language';


--
-- Name: COLUMN lanaguages.is_active; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.lanaguages.is_active IS 'Whether this language is currently active and supported';


--
-- Name: schema_migrations; Type: TABLE; Schema: notifications; Owner: postgres
--

CREATE TABLE notifications.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE notifications.schema_migrations OWNER TO postgres;

--
-- Name: user_communication_preferences; Type: TABLE; Schema: notifications; Owner: postgres
--

CREATE TABLE notifications.user_communication_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    profile_id uuid NOT NULL,
    template_id text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);


ALTER TABLE notifications.user_communication_preferences OWNER TO postgres;

--
-- Name: TABLE user_communication_preferences; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON TABLE notifications.user_communication_preferences IS 'User preferences for different types of notifications';


--
-- Name: COLUMN user_communication_preferences.id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.user_communication_preferences.id IS 'Unique identifier for the preference record';


--
-- Name: COLUMN user_communication_preferences.profile_id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.user_communication_preferences.profile_id IS 'Reference to the user this preference belongs to';


--
-- Name: COLUMN user_communication_preferences.template_id; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.user_communication_preferences.template_id IS 'Reference to the communication template this preference applies to';


--
-- Name: COLUMN user_communication_preferences.is_active; Type: COMMENT; Schema: notifications; Owner: postgres
--

COMMENT ON COLUMN notifications.user_communication_preferences.is_active IS 'Whether the user wants to receive notifications of this type';


--
-- Name: club_staff_profiles; Type: TABLE; Schema: profiles; Owner: postgres
--

CREATE TABLE profiles.club_staff_profiles (
    profile_role_id uuid NOT NULL,
    club_staff_role text,
    club_staff_department text,
    sport_entity_id uuid
);


ALTER TABLE profiles.club_staff_profiles OWNER TO postgres;

--
-- Name: TABLE club_staff_profiles; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON TABLE profiles.club_staff_profiles IS 'Club staff-specific profile data';


--
-- Name: COLUMN club_staff_profiles.profile_role_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.club_staff_profiles.profile_role_id IS 'Reference to the profile_role entry';


--
-- Name: COLUMN club_staff_profiles.club_staff_role; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.club_staff_profiles.club_staff_role IS 'Staff role type';


--
-- Name: COLUMN club_staff_profiles.club_staff_department; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.club_staff_profiles.club_staff_department IS 'Department within the club';


--
-- Name: COLUMN club_staff_profiles.sport_entity_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.club_staff_profiles.sport_entity_id IS 'Reference to associated sport entity (club)';


--
-- Name: coach_profiles; Type: TABLE; Schema: profiles; Owner: postgres
--

CREATE TABLE profiles.coach_profiles (
    profile_role_id uuid NOT NULL,
    sport_goal text,
    sport_category text,
    academy_category text,
    sport_entity_id uuid,
    coach_role text,
    coach_certifications jsonb,
    coach_supervisions jsonb
);


ALTER TABLE profiles.coach_profiles OWNER TO postgres;

--
-- Name: TABLE coach_profiles; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON TABLE profiles.coach_profiles IS 'Coach-specific profile data';


--
-- Name: COLUMN coach_profiles.profile_role_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.profile_role_id IS 'Reference to the profile_role entry';


--
-- Name: COLUMN coach_profiles.sport_goal; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.sport_goal IS 'Sport goal: official or for fun';


--
-- Name: COLUMN coach_profiles.sport_category; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.sport_category IS 'Category: academy or adult';


--
-- Name: COLUMN coach_profiles.academy_category; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.academy_category IS 'Academy level/category';


--
-- Name: COLUMN coach_profiles.sport_entity_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.sport_entity_id IS 'Reference to associated sport entity (club)';


--
-- Name: COLUMN coach_profiles.coach_role; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.coach_role IS 'Coach role type';


--
-- Name: COLUMN coach_profiles.coach_certifications; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.coach_certifications IS 'Coach certifications as JSON array';


--
-- Name: COLUMN coach_profiles.coach_supervisions; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.coach_profiles.coach_supervisions IS 'Coach supervision types as JSON array';


--
-- Name: fan_profiles; Type: TABLE; Schema: profiles; Owner: postgres
--

CREATE TABLE profiles.fan_profiles (
    profile_role_id uuid NOT NULL
);


ALTER TABLE profiles.fan_profiles OWNER TO postgres;

--
-- Name: TABLE fan_profiles; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON TABLE profiles.fan_profiles IS 'Fan-specific profile data (minimal)';


--
-- Name: COLUMN fan_profiles.profile_role_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.fan_profiles.profile_role_id IS 'Reference to the profile_role entry';


--
-- Name: player_profiles; Type: TABLE; Schema: profiles; Owner: postgres
--

CREATE TABLE profiles.player_profiles (
    profile_role_id uuid NOT NULL,
    sport_goal text,
    sport_category text,
    academy_category text,
    sport_entity_id uuid,
    field_position text,
    strong_foot text,
    height_cm integer,
    player_status text
);


ALTER TABLE profiles.player_profiles OWNER TO postgres;

--
-- Name: TABLE player_profiles; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON TABLE profiles.player_profiles IS 'Player-specific profile data';


--
-- Name: COLUMN player_profiles.profile_role_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.profile_role_id IS 'Reference to the profile_role entry';


--
-- Name: COLUMN player_profiles.sport_goal; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.sport_goal IS 'Sport goal: official or for fun';


--
-- Name: COLUMN player_profiles.sport_category; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.sport_category IS 'Category: academy or adult';


--
-- Name: COLUMN player_profiles.academy_category; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.academy_category IS 'Academy level/category';


--
-- Name: COLUMN player_profiles.sport_entity_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.sport_entity_id IS 'Reference to associated sport entity (club)';


--
-- Name: COLUMN player_profiles.field_position; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.field_position IS 'Field position as JSON';


--
-- Name: COLUMN player_profiles.strong_foot; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.strong_foot IS 'Preferred foot';


--
-- Name: COLUMN player_profiles.height_cm; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.height_cm IS 'Height in centimeters';


--
-- Name: COLUMN player_profiles.player_status; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.player_profiles.player_status IS 'Current player status';


--
-- Name: profile_roles; Type: TABLE; Schema: profiles; Owner: postgres
--

CREATE TABLE profiles.profile_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    profile_id uuid NOT NULL,
    role public.individual_role NOT NULL,
    primary_sport_id uuid NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE profiles.profile_roles OWNER TO postgres;

--
-- Name: TABLE profile_roles; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON TABLE profiles.profile_roles IS 'Tracks all roles associated with a profile';


--
-- Name: COLUMN profile_roles.profile_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.profile_roles.profile_id IS 'Reference to the profile';


--
-- Name: COLUMN profile_roles.role; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.profile_roles.role IS 'The role type (player, coach, referee, fan, club_staff)';


--
-- Name: COLUMN profile_roles.primary_sport_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.profile_roles.primary_sport_id IS 'The primary sport for this role';


--
-- Name: COLUMN profile_roles.is_completed; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.profile_roles.is_completed IS 'Whether the role configuration is complete';


--
-- Name: referee_profiles; Type: TABLE; Schema: profiles; Owner: postgres
--

CREATE TABLE profiles.referee_profiles (
    profile_role_id uuid NOT NULL,
    sport_entity_id uuid,
    sport_goal text,
    referee_categories jsonb,
    referee_match_types jsonb
);


ALTER TABLE profiles.referee_profiles OWNER TO postgres;

--
-- Name: TABLE referee_profiles; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON TABLE profiles.referee_profiles IS 'Referee-specific profile data';


--
-- Name: COLUMN referee_profiles.profile_role_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.referee_profiles.profile_role_id IS 'Reference to the profile_role entry';


--
-- Name: COLUMN referee_profiles.sport_entity_id; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.referee_profiles.sport_entity_id IS 'Reference to associated sport entity (federation)';


--
-- Name: COLUMN referee_profiles.sport_goal; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.referee_profiles.sport_goal IS 'Sport goal: official or for fun';


--
-- Name: COLUMN referee_profiles.referee_categories; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.referee_profiles.referee_categories IS 'Referee categories as JSON array';


--
-- Name: COLUMN referee_profiles.referee_match_types; Type: COMMENT; Schema: profiles; Owner: postgres
--

COMMENT ON COLUMN profiles.referee_profiles.referee_match_types IS 'Types of matches refereed as JSON array';


--
-- Name: chat_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chat_members (
    chat_id uuid NOT NULL,
    profile_id uuid NOT NULL,
    joined_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.chat_members OWNER TO postgres;

--
-- Name: TABLE chat_members; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.chat_members IS 'Stores members participating in each chat';


--
-- Name: chats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chats (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text,
    config jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.chats OWNER TO postgres;

--
-- Name: TABLE chats; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.chats IS 'Stores chat conversations';


--
-- Name: COLUMN chats.config; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.chats.config IS 'JSON configuration for chat settings (e.g., permissions, settings)';


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    team_id uuid NOT NULL,
    member_id uuid NOT NULL,
    is_admin boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.team_members OWNER TO postgres;

--
-- Name: teams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.teams (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    logo_url text NOT NULL,
    created_by uuid DEFAULT public.profile_id() NOT NULL,
    associated_club uuid,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL
);


ALTER TABLE public.teams OWNER TO postgres;

--
-- Name: chats_with_config; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.chats_with_config WITH (security_invoker='on') AS
 SELECT id,
    name,
    created_at,
        CASE
            WHEN ((config ->> 'chat_type'::text) = 'direct'::text) THEN jsonb_build_object('chat_type', 'direct', 'participants', (config -> 'participants'::text), 'other_user_id', ( SELECT (p.id)::text AS id
               FROM (jsonb_array_elements_text((c.config -> 'participants'::text)) participant_id(value)
                 LEFT JOIN public.profiles p ON (((p.id)::text = participant_id.value)))
              WHERE (participant_id.value <> (public.profile_id())::text)
             LIMIT 1), 'other_user_name', ( SELECT p.display_name
               FROM (jsonb_array_elements_text((c.config -> 'participants'::text)) participant_id(value)
                 LEFT JOIN public.profiles p ON (((p.id)::text = participant_id.value)))
              WHERE (participant_id.value <> (public.profile_id())::text)
             LIMIT 1), 'other_user_avatar_url', ( SELECT p.avatar_url
               FROM (jsonb_array_elements_text((c.config -> 'participants'::text)) participant_id(value)
                 LEFT JOIN public.profiles p ON (((p.id)::text = participant_id.value)))
              WHERE (participant_id.value <> (public.profile_id())::text)
             LIMIT 1), 'last_message', (config ->> 'last_message'::text), 'last_message_time', (config ->> 'last_message_time'::text))
            WHEN ((config ->> 'chat_type'::text) = 'team'::text) THEN jsonb_build_object('chat_type', 'team', 'team_id', (config ->> 'team_id'::text), 'team_name', ( SELECT t.name
               FROM public.teams t
              WHERE ((t.id)::text = (c.config ->> 'team_id'::text))
             LIMIT 1), 'team_logo_url', ( SELECT t.logo_url
               FROM public.teams t
              WHERE ((t.id)::text = (c.config ->> 'team_id'::text))
             LIMIT 1), 'last_message', (config ->> 'last_message'::text), 'last_message_time', (config ->> 'last_message_time'::text))
            WHEN ((config ->> 'chat_type'::text) = 'channel'::text) THEN jsonb_build_object('chat_type', 'channel', 'channel_name', (config ->> 'channel_name'::text), 'channel_logo_url', (config ->> 'channel_logo_url'::text), 'sender_id', (config ->> 'sender_id'::text), 'is_read_only', COALESCE(((config ->> 'is_read_only'::text))::boolean, true), 'last_message', (config ->> 'last_message'::text), 'last_message_time', (config ->> 'last_message_time'::text))
            ELSE COALESCE(config, '{}'::jsonb)
        END AS config
   FROM public.chats c
  WHERE ((( SELECT (public.profile_id())::text AS profile_id) IN ( SELECT jsonb_array_elements_text((c.config -> 'participants'::text)) AS jsonb_array_elements_text)) OR (EXISTS ( SELECT 1
           FROM (public.teams t
             JOIN public.team_members tm ON ((tm.team_id = t.id)))
          WHERE (((t.id)::text = (c.config ->> 'team_id'::text)) AND (tm.member_id = public.profile_id()))
        UNION ALL
         SELECT 1
          WHERE ((c.config ->> 'chat_type'::text) = 'channel'::text))));


ALTER VIEW public.chats_with_config OWNER TO postgres;

--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id smallint NOT NULL,
    name text NOT NULL,
    country_id smallint NOT NULL,
    latitude numeric(10,8),
    longitude numeric(11,8)
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.countries (
    id smallint NOT NULL,
    name text NOT NULL,
    code text NOT NULL,
    latitude numeric(10,8),
    longitude numeric(11,8),
    emoji text,
    translations jsonb,
    is_supported boolean DEFAULT false NOT NULL
);


ALTER TABLE public.countries OWNER TO postgres;

--
-- Name: feedback_tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback_tickets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    related_module public.app_module NOT NULL,
    recommendation text NOT NULL,
    created_by uuid
);


ALTER TABLE public.feedback_tickets OWNER TO postgres;

--
-- Name: TABLE feedback_tickets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.feedback_tickets IS 'This table holds the tickets for Feedback & Ideas module';


--
-- Name: medical_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.medical_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    team_id uuid NOT NULL,
    member_id uuid NOT NULL,
    severity public.medical_severity NOT NULL,
    cause public.session_type NOT NULL,
    injury_date timestamp with time zone NOT NULL,
    recovery_date timestamp with time zone,
    report text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.medical_reports OWNER TO postgres;

--
-- Name: members_evaluations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members_evaluations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    member_id uuid NOT NULL,
    text text,
    last_updated timestamp with time zone DEFAULT now() NOT NULL,
    profile_id uuid NOT NULL,
    team_id uuid NOT NULL
);


ALTER TABLE public.members_evaluations OWNER TO postgres;

--
-- Name: message_attachments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.message_attachments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    message_id uuid NOT NULL,
    name text NOT NULL,
    type public.attachment_type NOT NULL,
    url text NOT NULL,
    mime_type text NOT NULL,
    size integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.message_attachments OWNER TO postgres;

--
-- Name: TABLE message_attachments; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.message_attachments IS 'Stores file attachments associated with messages';


--
-- Name: COLUMN message_attachments.size; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.message_attachments.size IS 'File size in bytes';


--
-- Name: messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.messages (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    chat_id uuid NOT NULL,
    created_by uuid DEFAULT public.profile_id() NOT NULL,
    content text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.messages OWNER TO postgres;

--
-- Name: TABLE messages; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.messages IS 'Stores individual messages within chats';


--
-- Name: notify_me; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notify_me (
    id text DEFAULT public.uid() NOT NULL,
    data json NOT NULL
);


ALTER TABLE public.notify_me OWNER TO postgres;

--
-- Name: TABLE notify_me; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.notify_me IS 'Receives the current individual profile onboarding draft when they select unsupported sport/country';


--
-- Name: profile_experiences; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profile_experiences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    sport_role public.individual_role NOT NULL,
    sport_entity_id uuid NOT NULL,
    season_id uuid,
    category text,
    coach_role text,
    start_date date,
    end_date date,
    owner_id uuid DEFAULT public.profile_id() NOT NULL
);


ALTER TABLE public.profile_experiences OWNER TO postgres;

--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: seasons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seasons (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.seasons OWNER TO postgres;

--
-- Name: session_invitations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_invitations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    member_id uuid NOT NULL,
    team_id uuid NOT NULL,
    status public.session_invitation_status DEFAULT 'pending'::public.session_invitation_status NOT NULL,
    updated_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL
);


ALTER TABLE public.session_invitations OWNER TO postgres;

--
-- Name: TABLE session_invitations; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.session_invitations IS 'Tracks session invitations sent to team members';


--
-- Name: COLUMN session_invitations.id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.session_invitations.id IS 'Unique identifier for the invitation';


--
-- Name: COLUMN session_invitations.session_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.session_invitations.session_id IS 'Reference to the session';


--
-- Name: COLUMN session_invitations.member_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.session_invitations.member_id IS 'Reference to the invited team member';


--
-- Name: COLUMN session_invitations.team_id; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.session_invitations.team_id IS 'Reference to the team';


--
-- Name: COLUMN session_invitations.status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.session_invitations.status IS 'Current status of the invitation (pending, accepted, declined)';


--
-- Name: session_report_attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_report_attendance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_id uuid NOT NULL,
    member_id uuid NOT NULL,
    status public.attendance_report_status NOT NULL
);


ALTER TABLE public.session_report_attendance OWNER TO postgres;

--
-- Name: session_report_comments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_report_comments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_id uuid NOT NULL,
    comment text NOT NULL
);


ALTER TABLE public.session_report_comments OWNER TO postgres;

--
-- Name: session_report_composition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_report_composition (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_id uuid NOT NULL,
    substitutes uuid[] NOT NULL,
    positions jsonb NOT NULL,
    formation_name text DEFAULT ''::text NOT NULL
);


ALTER TABLE public.session_report_composition OWNER TO postgres;

--
-- Name: COLUMN session_report_composition.formation_name; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.session_report_composition.formation_name IS 'The name of the formation like 4-4-2, to be able to allocate the positioned into it on screen';


--
-- Name: session_report_game_stats; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_report_game_stats (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_id uuid NOT NULL,
    events jsonb DEFAULT '[]'::jsonb NOT NULL
);


ALTER TABLE public.session_report_game_stats OWNER TO postgres;

--
-- Name: session_report_ratings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_report_ratings (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    report_id uuid NOT NULL,
    member_id uuid NOT NULL,
    rating numeric(3,1) NOT NULL,
    CONSTRAINT chk_rating_precision CHECK (((rating % 0.5) = (0)::numeric)),
    CONSTRAINT chk_rating_range CHECK (((rating >= (0)::numeric) AND (rating <= (10)::numeric)))
);


ALTER TABLE public.session_report_ratings OWNER TO postgres;

--
-- Name: session_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    is_completed boolean DEFAULT false NOT NULL
);


ALTER TABLE public.session_reports OWNER TO postgres;

--
-- Name: sport_entity_profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sport_entity_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    profile_id uuid NOT NULL,
    entity_type public.sport_entity_type NOT NULL,
    entity_name text NOT NULL,
    username text NOT NULL,
    image_url text NOT NULL,
    address jsonb NOT NULL,
    primary_sport_id uuid NOT NULL,
    contact_first_name text NOT NULL,
    contact_last_name text NOT NULL,
    contact_email text NOT NULL,
    contact_phone text NOT NULL,
    contact_website text,
    club_categories jsonb,
    federation_category text,
    country_id smallint NOT NULL,
    city_id smallint,
    youth_leagues jsonb,
    adult_men_divisions jsonb,
    adult_women_divisions jsonb,
    CONSTRAINT chk_address_schema CHECK (extensions.jsonb_matches_schema('{
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
    CONSTRAINT chk_club_categories_schema CHECK (extensions.jsonb_matches_schema('{
                "type": "array",
                "items": {
                    "type": "string"
                },
                "uniqueItems": true
            }'::json, club_categories))
);


ALTER TABLE public.sport_entity_profiles OWNER TO postgres;

--
-- Name: TABLE sport_entity_profiles; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.sport_entity_profiles IS 'Extended profile for sport entities with type-specific data and JSON validation';


--
-- Name: sports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    code text,
    category text,
    is_team_sport boolean DEFAULT true,
    min_players_per_team smallint,
    max_players_per_team smallint,
    is_supported boolean DEFAULT false NOT NULL,
    icon_url text
);


ALTER TABLE public.sports OWNER TO postgres;

--
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.support_tickets (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    subject text NOT NULL,
    message text NOT NULL,
    created_by uuid
);


ALTER TABLE public.support_tickets OWNER TO postgres;

--
-- Name: TABLE support_tickets; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.support_tickets IS 'This table holds the tickets for Support & Contact module';


--
-- Name: team_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.team_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    team_id uuid NOT NULL,
    opponent_team_id uuid,
    turf public.turf,
    type public.session_type NOT NULL,
    name text NOT NULL,
    appointment_datetime timestamp with time zone NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    location jsonb NOT NULL,
    invitation_status public.session_invitation_status,
    attendance_hidden boolean DEFAULT false
);


ALTER TABLE public.team_sessions OWNER TO postgres;

--
-- Name: COLUMN team_sessions.attendance_hidden; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.team_sessions.attendance_hidden IS 'If true, attendance will not be shown to players';


--
-- Name: communication_schedule_rules communication_schedule_rules_pkey; Type: CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.communication_schedule_rules
    ADD CONSTRAINT communication_schedule_rules_pkey PRIMARY KEY (id);


--
-- Name: communication_templates_assets communication_templates_assets_pkey; Type: CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.communication_templates_assets
    ADD CONSTRAINT communication_templates_assets_pkey PRIMARY KEY (id);


--
-- Name: communication_templates communication_templates_pkey; Type: CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.communication_templates
    ADD CONSTRAINT communication_templates_pkey PRIMARY KEY (id);


--
-- Name: lanaguages lanaguages_pkey; Type: CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.lanaguages
    ADD CONSTRAINT lanaguages_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: user_communication_preferences user_communication_preferences_pkey; Type: CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.user_communication_preferences
    ADD CONSTRAINT user_communication_preferences_pkey PRIMARY KEY (id);


--
-- Name: club_staff_profiles club_staff_profiles_pkey; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.club_staff_profiles
    ADD CONSTRAINT club_staff_profiles_pkey PRIMARY KEY (profile_role_id);


--
-- Name: coach_profiles coach_profiles_pkey; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.coach_profiles
    ADD CONSTRAINT coach_profiles_pkey PRIMARY KEY (profile_role_id);


--
-- Name: fan_profiles fan_profiles_pkey; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.fan_profiles
    ADD CONSTRAINT fan_profiles_pkey PRIMARY KEY (profile_role_id);


--
-- Name: player_profiles player_profiles_pkey; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.player_profiles
    ADD CONSTRAINT player_profiles_pkey PRIMARY KEY (profile_role_id);


--
-- Name: profile_roles profile_roles_pkey; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.profile_roles
    ADD CONSTRAINT profile_roles_pkey PRIMARY KEY (id);


--
-- Name: profile_roles profile_roles_profile_id_role_primary_sport_id_key; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.profile_roles
    ADD CONSTRAINT profile_roles_profile_id_role_primary_sport_id_key UNIQUE (profile_id, role, primary_sport_id);


--
-- Name: referee_profiles referee_profiles_pkey; Type: CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.referee_profiles
    ADD CONSTRAINT referee_profiles_pkey PRIMARY KEY (profile_role_id);


--
-- Name: chat_members chat_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_members
    ADD CONSTRAINT chat_members_pkey PRIMARY KEY (chat_id, profile_id);


--
-- Name: chats chats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chats
    ADD CONSTRAINT chats_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: countries countries_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_code_key UNIQUE (code);


--
-- Name: countries countries_emoji_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_emoji_key UNIQUE (emoji);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: feedback_tickets feedback_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback_tickets
    ADD CONSTRAINT feedback_tickets_pkey PRIMARY KEY (id);


--
-- Name: medical_reports medical_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_reports
    ADD CONSTRAINT medical_reports_pkey PRIMARY KEY (id);


--
-- Name: members_evaluations members_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members_evaluations
    ADD CONSTRAINT members_evaluations_pkey PRIMARY KEY (id);


--
-- Name: message_attachments message_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_attachments
    ADD CONSTRAINT message_attachments_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: notify_me notify_me_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notify_me
    ADD CONSTRAINT notify_me_pkey PRIMARY KEY (id);


--
-- Name: opportunities opportunities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunities
    ADD CONSTRAINT opportunities_pkey PRIMARY KEY (id);


--
-- Name: opportunity_applications opportunity_applications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunity_applications
    ADD CONSTRAINT opportunity_applications_pkey PRIMARY KEY (id);


--
-- Name: opportunity_requirements opportunity_requirements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunity_requirements
    ADD CONSTRAINT opportunity_requirements_pkey PRIMARY KEY (id);


--
-- Name: profile_experiences profile_experiences_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_experiences
    ADD CONSTRAINT profile_experiences_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_username_key UNIQUE (username);


--
-- Name: saved_opportunities saved_opportunities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_opportunities
    ADD CONSTRAINT saved_opportunities_pkey PRIMARY KEY (profile_id, opportunity_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seasons seasons_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_name_key UNIQUE (name);


--
-- Name: seasons seasons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seasons
    ADD CONSTRAINT seasons_pkey PRIMARY KEY (id);


--
-- Name: session_invitations session_invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_invitations
    ADD CONSTRAINT session_invitations_pkey PRIMARY KEY (id);


--
-- Name: session_invitations session_invitations_session_id_member_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_invitations
    ADD CONSTRAINT session_invitations_session_id_member_id_key UNIQUE (session_id, member_id);


--
-- Name: session_report_attendance session_report_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_attendance
    ADD CONSTRAINT session_report_attendance_pkey PRIMARY KEY (id);


--
-- Name: session_report_attendance session_report_attendance_unique_report_member; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_attendance
    ADD CONSTRAINT session_report_attendance_unique_report_member UNIQUE (report_id, member_id);


--
-- Name: session_report_comments session_report_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_comments
    ADD CONSTRAINT session_report_comments_pkey PRIMARY KEY (id);


--
-- Name: session_report_composition session_report_composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_composition
    ADD CONSTRAINT session_report_composition_pkey PRIMARY KEY (id);


--
-- Name: session_report_game_stats session_report_game_stats_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_game_stats
    ADD CONSTRAINT session_report_game_stats_pkey PRIMARY KEY (id);


--
-- Name: session_report_ratings session_report_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_ratings
    ADD CONSTRAINT session_report_ratings_pkey PRIMARY KEY (id);


--
-- Name: session_reports session_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_reports
    ADD CONSTRAINT session_reports_pkey PRIMARY KEY (id);


--
-- Name: sport_entity_profiles sport_entity_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_pkey PRIMARY KEY (id);


--
-- Name: sport_entity_profiles sport_entity_profiles_profile_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_profile_id_key UNIQUE (profile_id);


--
-- Name: sport_entity_profiles sport_entity_profiles_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_username_key UNIQUE (username);


--
-- Name: sports sports_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sports
    ADD CONSTRAINT sports_code_key UNIQUE (code);


--
-- Name: sports sports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sports
    ADD CONSTRAINT sports_pkey PRIMARY KEY (id);


--
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (id);


--
-- Name: team_sessions team_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_sessions
    ADD CONSTRAINT team_sessions_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: session_report_comments unique_report_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_comments
    ADD CONSTRAINT unique_report_id UNIQUE (report_id);


--
-- Name: opportunity_applications uq_opportunity_applications_user_opportunity; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunity_applications
    ADD CONSTRAINT uq_opportunity_applications_user_opportunity UNIQUE (opportunity_id, applicant_id);


--
-- Name: idx_profile_roles_profile_id; Type: INDEX; Schema: profiles; Owner: postgres
--

CREATE INDEX idx_profile_roles_profile_id ON profiles.profile_roles USING btree (profile_id);


--
-- Name: idx_profile_roles_role; Type: INDEX; Schema: profiles; Owner: postgres
--

CREATE INDEX idx_profile_roles_role ON profiles.profile_roles USING btree (role);


--
-- Name: idx_chat_members_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_members_chat_id ON public.chat_members USING btree (chat_id);


--
-- Name: idx_chat_members_profile_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_chat_members_profile_id ON public.chat_members USING btree (profile_id);


--
-- Name: idx_cities_country_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cities_country_id ON public.cities USING btree (country_id);


--
-- Name: idx_cities_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cities_location ON public.cities USING btree (latitude, longitude);


--
-- Name: idx_cities_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cities_name ON public.cities USING btree (name);


--
-- Name: idx_countries_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_countries_location ON public.countries USING btree (latitude, longitude);


--
-- Name: idx_countries_translations; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_countries_translations ON public.countries USING gin (translations);


--
-- Name: idx_message_attachments_message_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_message_attachments_message_id ON public.message_attachments USING btree (message_id);


--
-- Name: idx_messages_chat_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_chat_id ON public.messages USING btree (chat_id);


--
-- Name: idx_messages_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_created_at ON public.messages USING btree (created_at DESC);


--
-- Name: idx_messages_created_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_messages_created_by ON public.messages USING btree (created_by);


--
-- Name: idx_profiles_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profiles_user_id ON public.profiles USING btree (user_id);


--
-- Name: session_invitations accepted_session_reminder_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER accepted_session_reminder_trigger AFTER UPDATE OF status ON public.session_invitations FOR EACH ROW EXECUTE FUNCTION notifications.accepted_session_reminder();


--
-- Name: opportunity_applications application_status_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER application_status_notification_trigger AFTER UPDATE ON public.opportunity_applications FOR EACH ROW EXECUTE FUNCTION notifications.application_status_notification();


--
-- Name: session_invitations member_session_invitation_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER member_session_invitation_notification_trigger AFTER INSERT ON public.session_invitations FOR EACH STATEMENT EXECUTE FUNCTION notifications.member_session_invitation_notification();


--
-- Name: opportunity_applications new_applicant_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER new_applicant_notification_trigger AFTER INSERT ON public.opportunity_applications FOR EACH ROW EXECUTE FUNCTION notifications.new_applicant_notification();


--
-- Name: messages new_chat_message_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER new_chat_message_notification_trigger AFTER INSERT ON public.messages FOR EACH ROW EXECUTE FUNCTION notifications.new_chat_message_notification();


--
-- Name: medical_reports new_medical_report_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER new_medical_report_notification_trigger AFTER INSERT OR UPDATE ON public.medical_reports FOR EACH ROW EXECUTE FUNCTION notifications.new_medical_report_notification();


--
-- Name: team_members new_member_added_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER new_member_added_notification_trigger AFTER INSERT ON public.team_members REFERENCING NEW TABLE AS inserted_batch FOR EACH STATEMENT EXECUTE FUNCTION notifications.new_member_added_notification();


--
-- Name: members_evaluations new_member_evaluation_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER new_member_evaluation_notification_trigger AFTER INSERT OR UPDATE ON public.members_evaluations FOR EACH ROW EXECUTE FUNCTION notifications.new_member_evaluation_notification();


--
-- Name: opportunities opportunity_closed_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER opportunity_closed_notification_trigger AFTER UPDATE ON public.opportunities FOR EACH ROW EXECUTE FUNCTION notifications.opportunity_closed_notification();


--
-- Name: opportunities opportunity_ending_reminder_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER opportunity_ending_reminder_trigger AFTER INSERT ON public.opportunities FOR EACH ROW EXECUTE FUNCTION notifications.opportunity_ending_reminder();


--
-- Name: opportunities saved_opportunity_updated_notification_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER saved_opportunity_updated_notification_trigger AFTER UPDATE ON public.opportunities FOR EACH ROW EXECUTE FUNCTION notifications.saved_opportunity_updated_notification();


--
-- Name: team_sessions scheduled_session_invitation_reminder_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER scheduled_session_invitation_reminder_trigger AFTER INSERT ON public.team_sessions FOR EACH ROW EXECUTE FUNCTION notifications.scheduled_session_invitation_reminder();


--
-- Name: session_reports session_report_reminder_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER session_report_reminder_trigger AFTER INSERT ON public.session_reports FOR EACH ROW EXECUTE FUNCTION notifications.schedule_session_report_reminder();


--
-- Name: session_report_composition trg_validate_composition; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validate_composition BEFORE INSERT OR UPDATE ON public.session_report_composition FOR EACH ROW EXECUTE FUNCTION public.validate_composition();


--
-- Name: sport_entity_profiles trigger_update_sport_entity_profile_generated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_update_sport_entity_profile_generated AFTER INSERT OR UPDATE OF entity_name, image_url ON public.sport_entity_profiles FOR EACH ROW EXECUTE FUNCTION public.update_profile_generated_columns();


--
-- Name: members_evaluations update_evaluation_last_updated; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_evaluation_last_updated BEFORE UPDATE ON public.members_evaluations FOR EACH ROW EXECUTE FUNCTION public.update_last_updated();


--
-- Name: communication_schedule_rules communication_schedule_rules_template_id_fkey; Type: FK CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.communication_schedule_rules
    ADD CONSTRAINT communication_schedule_rules_template_id_fkey FOREIGN KEY (template_id) REFERENCES notifications.communication_templates(id);


--
-- Name: communication_templates_assets communication_templates_assets_template_id_fkey; Type: FK CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.communication_templates_assets
    ADD CONSTRAINT communication_templates_assets_template_id_fkey FOREIGN KEY (template_id) REFERENCES notifications.communication_templates(id);


--
-- Name: user_communication_preferences user_communication_preferences_profile_id_fkey; Type: FK CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.user_communication_preferences
    ADD CONSTRAINT user_communication_preferences_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id);


--
-- Name: user_communication_preferences user_communication_preferences_template_id_fkey; Type: FK CONSTRAINT; Schema: notifications; Owner: postgres
--

ALTER TABLE ONLY notifications.user_communication_preferences
    ADD CONSTRAINT user_communication_preferences_template_id_fkey FOREIGN KEY (template_id) REFERENCES notifications.communication_templates(id);


--
-- Name: club_staff_profiles club_staff_profiles_profile_role_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.club_staff_profiles
    ADD CONSTRAINT club_staff_profiles_profile_role_id_fkey FOREIGN KEY (profile_role_id) REFERENCES profiles.profile_roles(id) ON DELETE CASCADE;


--
-- Name: club_staff_profiles club_staff_profiles_sport_entity_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.club_staff_profiles
    ADD CONSTRAINT club_staff_profiles_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id);


--
-- Name: coach_profiles coach_profiles_profile_role_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.coach_profiles
    ADD CONSTRAINT coach_profiles_profile_role_id_fkey FOREIGN KEY (profile_role_id) REFERENCES profiles.profile_roles(id) ON DELETE CASCADE;


--
-- Name: coach_profiles coach_profiles_sport_entity_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.coach_profiles
    ADD CONSTRAINT coach_profiles_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id);


--
-- Name: fan_profiles fan_profiles_profile_role_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.fan_profiles
    ADD CONSTRAINT fan_profiles_profile_role_id_fkey FOREIGN KEY (profile_role_id) REFERENCES profiles.profile_roles(id) ON DELETE CASCADE;


--
-- Name: player_profiles player_profiles_profile_role_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.player_profiles
    ADD CONSTRAINT player_profiles_profile_role_id_fkey FOREIGN KEY (profile_role_id) REFERENCES profiles.profile_roles(id) ON DELETE CASCADE;


--
-- Name: player_profiles player_profiles_sport_entity_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.player_profiles
    ADD CONSTRAINT player_profiles_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id);


--
-- Name: profile_roles profile_roles_primary_sport_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.profile_roles
    ADD CONSTRAINT profile_roles_primary_sport_id_fkey FOREIGN KEY (primary_sport_id) REFERENCES public.sports(id);


--
-- Name: profile_roles profile_roles_profile_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.profile_roles
    ADD CONSTRAINT profile_roles_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: referee_profiles referee_profiles_profile_role_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.referee_profiles
    ADD CONSTRAINT referee_profiles_profile_role_id_fkey FOREIGN KEY (profile_role_id) REFERENCES profiles.profile_roles(id) ON DELETE CASCADE;


--
-- Name: referee_profiles referee_profiles_sport_entity_id_fkey; Type: FK CONSTRAINT; Schema: profiles; Owner: postgres
--

ALTER TABLE ONLY profiles.referee_profiles
    ADD CONSTRAINT referee_profiles_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id);


--
-- Name: chat_members chat_members_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_members
    ADD CONSTRAINT chat_members_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: chat_members chat_members_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chat_members
    ADD CONSTRAINT chat_members_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cities cities_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: feedback_tickets feedback_tickets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback_tickets
    ADD CONSTRAINT feedback_tickets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: session_report_attendance fk_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_attendance
    ADD CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- Name: session_report_ratings fk_member; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_ratings
    ADD CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- Name: session_reports fk_session; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_reports
    ADD CONSTRAINT fk_session FOREIGN KEY (session_id) REFERENCES public.team_sessions(id) ON DELETE CASCADE;


--
-- Name: session_report_attendance fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_attendance
    ADD CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id) ON DELETE CASCADE;


--
-- Name: session_report_comments fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_comments
    ADD CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id) ON DELETE CASCADE;


--
-- Name: session_report_composition fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_composition
    ADD CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id) ON DELETE CASCADE;


--
-- Name: session_report_game_stats fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_game_stats
    ADD CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id) ON DELETE CASCADE;


--
-- Name: session_report_ratings fk_session_report; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_report_ratings
    ADD CONSTRAINT fk_session_report FOREIGN KEY (report_id) REFERENCES public.session_reports(id) ON DELETE CASCADE;


--
-- Name: medical_reports medical_reports_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_reports
    ADD CONSTRAINT medical_reports_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.team_members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: medical_reports medical_reports_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.medical_reports
    ADD CONSTRAINT medical_reports_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: members_evaluations members_evaluations_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members_evaluations
    ADD CONSTRAINT members_evaluations_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.team_members(id) ON DELETE CASCADE;


--
-- Name: members_evaluations members_evaluations_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members_evaluations
    ADD CONSTRAINT members_evaluations_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: members_evaluations members_evaluations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members_evaluations
    ADD CONSTRAINT members_evaluations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON DELETE CASCADE;


--
-- Name: message_attachments message_attachments_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.message_attachments
    ADD CONSTRAINT message_attachments_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: messages messages_chat_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_chat_id_fkey FOREIGN KEY (chat_id) REFERENCES public.chats(id) ON DELETE CASCADE;


--
-- Name: messages messages_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: opportunities opportunities_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunities
    ADD CONSTRAINT opportunities_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: opportunity_applications opportunity_applications_applicant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunity_applications
    ADD CONSTRAINT opportunity_applications_applicant_id_fkey FOREIGN KEY (applicant_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: opportunity_applications opportunity_applications_opportunity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunity_applications
    ADD CONSTRAINT opportunity_applications_opportunity_id_fkey FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id) ON DELETE CASCADE;


--
-- Name: opportunity_requirements opportunity_requirements_opportunity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.opportunity_requirements
    ADD CONSTRAINT opportunity_requirements_opportunity_id_fkey FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profile_experiences profile_experiences_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_experiences
    ADD CONSTRAINT profile_experiences_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: profile_experiences profile_experiences_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_experiences
    ADD CONSTRAINT profile_experiences_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.seasons(id);


--
-- Name: profile_experiences profile_experiences_sport_entity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profile_experiences
    ADD CONSTRAINT profile_experiences_sport_entity_id_fkey FOREIGN KEY (sport_entity_id) REFERENCES public.sport_entity_profiles(id);


--
-- Name: profiles profiles_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: profiles profiles_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON UPDATE CASCADE;


--
-- Name: saved_opportunities saved_opportunities_opportunity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_opportunities
    ADD CONSTRAINT saved_opportunities_opportunity_id_fkey FOREIGN KEY (opportunity_id) REFERENCES public.opportunities(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: saved_opportunities saved_opportunities_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_opportunities
    ADD CONSTRAINT saved_opportunities_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: session_invitations session_invitations_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_invitations
    ADD CONSTRAINT session_invitations_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.team_members(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: session_invitations session_invitations_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_invitations
    ADD CONSTRAINT session_invitations_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.team_sessions(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: session_invitations session_invitations_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session_invitations
    ADD CONSTRAINT session_invitations_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: sport_entity_profiles sport_entity_profiles_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: sport_entity_profiles sport_entity_profiles_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id) ON UPDATE CASCADE;


--
-- Name: sport_entity_profiles sport_entity_profiles_primary_sport_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_primary_sport_id_fkey FOREIGN KEY (primary_sport_id) REFERENCES public.sports(id);


--
-- Name: sport_entity_profiles sport_entity_profiles_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sport_entity_profiles
    ADD CONSTRAINT sport_entity_profiles_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: support_tickets support_tickets_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: team_members team_members_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: team_members team_members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: team_sessions team_sessions_opponent_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_sessions
    ADD CONSTRAINT team_sessions_opponent_team_id_fkey FOREIGN KEY (opponent_team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: team_sessions team_sessions_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.team_sessions
    ADD CONSTRAINT team_sessions_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: teams teams_associated_club_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_associated_club_fkey FOREIGN KEY (associated_club) REFERENCES public.sport_entity_profiles(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: teams teams_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.profiles(id) ON UPDATE CASCADE;


--
-- Name: user_communication_preferences Allow users to insert their own preferences; Type: POLICY; Schema: notifications; Owner: postgres
--

CREATE POLICY "Allow users to insert their own preferences" ON notifications.user_communication_preferences FOR INSERT TO authenticated WITH CHECK ((profile_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: user_communication_preferences Allow users to update their own preferences; Type: POLICY; Schema: notifications; Owner: postgres
--

CREATE POLICY "Allow users to update their own preferences" ON notifications.user_communication_preferences FOR UPDATE TO authenticated USING ((profile_id = ( SELECT public.profile_id() AS profile_id))) WITH CHECK ((profile_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: user_communication_preferences Allow users to view their own preferences; Type: POLICY; Schema: notifications; Owner: postgres
--

CREATE POLICY "Allow users to view their own preferences" ON notifications.user_communication_preferences FOR SELECT TO authenticated USING (true);


--
-- Name: user_communication_preferences; Type: ROW SECURITY; Schema: notifications; Owner: postgres
--

ALTER TABLE notifications.user_communication_preferences ENABLE ROW LEVEL SECURITY;

--
-- Name: club_staff_profiles Allow authenticated users to view all club staff profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow authenticated users to view all club staff profiles" ON profiles.club_staff_profiles FOR SELECT TO authenticated USING (true);


--
-- Name: coach_profiles Allow authenticated users to view all coach profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow authenticated users to view all coach profiles" ON profiles.coach_profiles FOR SELECT TO authenticated USING (true);


--
-- Name: fan_profiles Allow authenticated users to view all fan profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow authenticated users to view all fan profiles" ON profiles.fan_profiles FOR SELECT TO authenticated USING (true);


--
-- Name: player_profiles Allow authenticated users to view all player profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow authenticated users to view all player profiles" ON profiles.player_profiles FOR SELECT TO authenticated USING (true);


--
-- Name: profile_roles Allow authenticated users to view all profile roles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow authenticated users to view all profile roles" ON profiles.profile_roles FOR SELECT TO authenticated USING (true);


--
-- Name: referee_profiles Allow authenticated users to view all referee profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow authenticated users to view all referee profiles" ON profiles.referee_profiles FOR SELECT TO authenticated USING (true);


--
-- Name: club_staff_profiles Allow users to delete their own club staff profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to delete their own club staff profiles" ON profiles.club_staff_profiles FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = club_staff_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: coach_profiles Allow users to delete their own coach profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to delete their own coach profiles" ON profiles.coach_profiles FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = coach_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: fan_profiles Allow users to delete their own fan profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to delete their own fan profiles" ON profiles.fan_profiles FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = fan_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: player_profiles Allow users to delete their own player profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to delete their own player profiles" ON profiles.player_profiles FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = player_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: profile_roles Allow users to delete their own profile roles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to delete their own profile roles" ON profiles.profile_roles FOR DELETE TO authenticated USING ((profile_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: referee_profiles Allow users to delete their own referee profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to delete their own referee profiles" ON profiles.referee_profiles FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = referee_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: club_staff_profiles Allow users to insert club staff data for their own profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to insert club staff data for their own profiles" ON profiles.club_staff_profiles FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = club_staff_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: coach_profiles Allow users to insert coach data for their own profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to insert coach data for their own profiles" ON profiles.coach_profiles FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = coach_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: fan_profiles Allow users to insert fan data for their own profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to insert fan data for their own profiles" ON profiles.fan_profiles FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = fan_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: player_profiles Allow users to insert player data for their own profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to insert player data for their own profiles" ON profiles.player_profiles FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = player_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: referee_profiles Allow users to insert referee data for their own profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to insert referee data for their own profiles" ON profiles.referee_profiles FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = referee_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: profile_roles Allow users to insert roles for their own profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to insert roles for their own profiles" ON profiles.profile_roles FOR INSERT TO authenticated WITH CHECK ((profile_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: club_staff_profiles Allow users to update their own club staff profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to update their own club staff profiles" ON profiles.club_staff_profiles FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = club_staff_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id)))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = club_staff_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: coach_profiles Allow users to update their own coach profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to update their own coach profiles" ON profiles.coach_profiles FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = coach_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id)))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = coach_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: fan_profiles Allow users to update their own fan profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to update their own fan profiles" ON profiles.fan_profiles FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = fan_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id)))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = fan_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: player_profiles Allow users to update their own player profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to update their own player profiles" ON profiles.player_profiles FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = player_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id)))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = player_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: profile_roles Allow users to update their own profile roles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to update their own profile roles" ON profiles.profile_roles FOR UPDATE TO authenticated USING ((profile_id = ( SELECT public.profile_id() AS profile_id))) WITH CHECK ((profile_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: referee_profiles Allow users to update their own referee profiles; Type: POLICY; Schema: profiles; Owner: postgres
--

CREATE POLICY "Allow users to update their own referee profiles" ON profiles.referee_profiles FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = referee_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id)))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM profiles.profile_roles pr
  WHERE ((pr.id = referee_profiles.profile_role_id) AND (pr.profile_id = ( SELECT public.profile_id() AS profile_id))))));


--
-- Name: club_staff_profiles; Type: ROW SECURITY; Schema: profiles; Owner: postgres
--

ALTER TABLE profiles.club_staff_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: coach_profiles; Type: ROW SECURITY; Schema: profiles; Owner: postgres
--

ALTER TABLE profiles.coach_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: fan_profiles; Type: ROW SECURITY; Schema: profiles; Owner: postgres
--

ALTER TABLE profiles.fan_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: player_profiles; Type: ROW SECURITY; Schema: profiles; Owner: postgres
--

ALTER TABLE profiles.player_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profile_roles; Type: ROW SECURITY; Schema: profiles; Owner: postgres
--

ALTER TABLE profiles.profile_roles ENABLE ROW LEVEL SECURITY;

--
-- Name: referee_profiles; Type: ROW SECURITY; Schema: profiles; Owner: postgres
--

ALTER TABLE profiles.referee_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: seasons Allow SELECT operations for Authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow SELECT operations for Authenticated users" ON public.seasons FOR SELECT TO authenticated USING (true);


--
-- Name: feedback_tickets Allow authenticated users to create their own support tickets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to create their own support tickets" ON public.feedback_tickets FOR INSERT TO authenticated WITH CHECK ((created_by = public.profile_id()));


--
-- Name: support_tickets Allow authenticated users to create their own support tickets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to create their own support tickets" ON public.support_tickets FOR INSERT TO authenticated WITH CHECK ((created_by = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: feedback_tickets Allow authenticated users to read their own support tickets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read their own support tickets" ON public.feedback_tickets FOR SELECT TO authenticated USING ((created_by = public.profile_id()));


--
-- Name: support_tickets Allow authenticated users to read their own support tickets; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow authenticated users to read their own support tickets" ON public.support_tickets FOR SELECT TO authenticated USING ((created_by = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: team_members Allow delete by team admin only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow delete by team admin only" ON public.team_members FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.member_id = ( SELECT public.profile_id() AS profile_id)) AND (tm.is_admin = true) AND (tm.team_id = team_members.team_id)))));


--
-- Name: teams Allow delete by team admins only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow delete by team admins only" ON public.teams FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = teams.id) AND (tm.member_id = public.profile_id()) AND (tm.is_admin = true)))));


--
-- Name: team_members Allow insertions by team admins or team creators only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow insertions by team admins or team creators only" ON public.team_members FOR INSERT TO authenticated WITH CHECK (((EXISTS ( SELECT 1
   FROM public.teams t
  WHERE ((t.id = team_members.team_id) AND (t.created_by = public.profile_id())))) OR (EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = tm.team_id) AND (tm.is_admin = true))))));


--
-- Name: medical_reports Allow team admin to have full access on reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow team admin to have full access on reports" ON public.medical_reports TO authenticated USING (( SELECT public.is_user_team_admin(medical_reports.team_id) AS is_user_team_admin)) WITH CHECK (( SELECT public.is_user_team_admin(medical_reports.team_id) AS is_user_team_admin));


--
-- Name: medical_reports Allow team members to delete their own reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow team members to delete their own reports" ON public.medical_reports FOR DELETE USING ((( SELECT public.is_user_in_team(medical_reports.team_id) AS is_user_in_team) AND (( SELECT public.get_profile_id_by_team_member(medical_reports.member_id) AS get_profile_id_by_team_member) = ( SELECT public.profile_id() AS profile_id))));


--
-- Name: medical_reports Allow team members to update their own reports; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow team members to update their own reports" ON public.medical_reports FOR UPDATE TO authenticated USING ((( SELECT public.is_user_in_team(medical_reports.team_id) AS is_user_in_team) AND (( SELECT public.get_profile_id_by_team_member(medical_reports.member_id) AS get_profile_id_by_team_member) = ( SELECT public.profile_id() AS profile_id)))) WITH CHECK ((( SELECT public.is_user_in_team(medical_reports.team_id) AS is_user_in_team) AND (( SELECT public.get_profile_id_by_team_member(medical_reports.member_id) AS get_profile_id_by_team_member) = ( SELECT public.profile_id() AS profile_id))));


--
-- Name: teams Allow team update by admin members only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow team update by admin members only" ON public.teams FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = teams.id) AND (tm.member_id = public.profile_id()) AND (tm.is_admin = true))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = teams.id) AND (tm.member_id = public.profile_id()) AND (tm.is_admin = true)))));


--
-- Name: team_members Allow update by team admins only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Allow update by team admins only" ON public.team_members FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = team_members.team_id) AND (tm.member_id = public.profile_id()) AND (tm.is_admin = true))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.team_members tm
  WHERE ((tm.team_id = team_members.team_id) AND (tm.member_id = public.profile_id()) AND (tm.is_admin = true)))));


--
-- Name: profiles Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.profiles FOR DELETE TO authenticated USING ((( SELECT public.uid() AS uid) = user_id));


--
-- Name: saved_opportunities Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable delete for users based on user_id" ON public.saved_opportunities FOR DELETE TO authenticated USING ((( SELECT public.profile_id() AS profile_id) = profile_id));


--
-- Name: opportunities Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.opportunities FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: opportunity_applications Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.opportunity_applications FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: profile_experiences Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.profile_experiences FOR INSERT TO authenticated WITH CHECK ((owner_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: profiles Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((public.uid() IS NOT NULL));


--
-- Name: saved_opportunities Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.saved_opportunities FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: teams Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable insert for authenticated users only" ON public.teams FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: opportunities Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all authenticated users" ON public.opportunities FOR SELECT TO authenticated USING (true);


--
-- Name: opportunity_requirements Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all authenticated users" ON public.opportunity_requirements FOR SELECT TO authenticated USING (true);


--
-- Name: team_members Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all authenticated users" ON public.team_members FOR SELECT TO authenticated USING (true);


--
-- Name: teams Enable read access for all authenticated users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all authenticated users" ON public.teams FOR SELECT TO authenticated USING (true);


--
-- Name: cities Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.cities FOR SELECT USING (true);


--
-- Name: countries Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.countries FOR SELECT USING (true);


--
-- Name: sport_entity_profiles Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.sport_entity_profiles FOR SELECT USING (true);


--
-- Name: sports Enable read access for all users; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable read access for all users" ON public.sports FOR SELECT USING (true);


--
-- Name: opportunities Enable update for users based on profile_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable update for users based on profile_id" ON public.opportunities FOR UPDATE TO authenticated USING ((( SELECT public.profile_id() AS profile_id) = created_by));


--
-- Name: profile_experiences Enable users to update their own data only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable users to update their own data only" ON public.profile_experiences FOR UPDATE TO authenticated USING ((owner_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: opportunity_applications Enable users to view their own data only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable users to view their own data only" ON public.opportunity_applications FOR SELECT TO authenticated USING (((( SELECT public.profile_id() AS profile_id) = applicant_id) OR ( SELECT (public.profile_id() = ( SELECT opportunities.created_by
           FROM public.opportunities
          WHERE (opportunities.id = opportunity_applications.opportunity_id))))));


--
-- Name: profile_experiences Enable users to view their own data only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable users to view their own data only" ON public.profile_experiences FOR SELECT TO authenticated USING ((owner_id = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: saved_opportunities Enable users to view their own data only; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Enable users to view their own data only" ON public.saved_opportunities FOR SELECT TO authenticated USING ((( SELECT public.profile_id() AS profile_id) = profile_id));


--
-- Name: chat_members Users can add members to chats they belong to; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can add members to chats they belong to" ON public.chat_members FOR INSERT WITH CHECK ((true OR (EXISTS ( SELECT 1
   FROM public.chat_members cm
  WHERE ((cm.chat_id = chat_members.chat_id) AND (cm.profile_id = public.profile_id()))))));


--
-- Name: chat_members Users can add themselves to chats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can add themselves to chats" ON public.chat_members FOR INSERT WITH CHECK ((profile_id = public.profile_id()));


--
-- Name: message_attachments Users can create attachments for their own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can create attachments for their own messages" ON public.message_attachments FOR INSERT WITH CHECK ((EXISTS ( SELECT 1
   FROM public.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.created_by = public.profile_id())))));


--
-- Name: chats Users can create chats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can create chats" ON public.chats FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: messages Users can create messages in chats they belong to; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can create messages in chats they belong to" ON public.messages FOR INSERT WITH CHECK (((created_by = public.profile_id()) AND (EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = messages.chat_id) AND (chat_members.profile_id = public.profile_id()))))));


--
-- Name: session_reports Users can create session reports for their team sessions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can create session reports for their team sessions" ON public.session_reports FOR INSERT TO authenticated WITH CHECK ((session_id IN ( SELECT ts.id
   FROM (public.team_sessions ts
     JOIN public.team_members tm ON ((ts.team_id = tm.team_id)))
  WHERE (tm.member_id = public.profile_id()))));


--
-- Name: message_attachments Users can delete attachments for their own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete attachments for their own messages" ON public.message_attachments FOR DELETE USING ((EXISTS ( SELECT 1
   FROM public.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.created_by = public.profile_id())))));


--
-- Name: chats Users can delete chats they are members of; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete chats they are members of" ON public.chats FOR DELETE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = chats.id) AND (chat_members.profile_id = public.profile_id())))));


--
-- Name: messages Users can delete their own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can delete their own messages" ON public.messages FOR DELETE USING ((created_by = public.profile_id()));


--
-- Name: chat_members Users can remove themselves from chats; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can remove themselves from chats" ON public.chat_members FOR DELETE USING ((profile_id = public.profile_id()));


--
-- Name: message_attachments Users can update attachments for their own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update attachments for their own messages" ON public.message_attachments FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM public.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.created_by = public.profile_id()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.messages m
  WHERE ((m.id = message_attachments.message_id) AND (m.created_by = public.profile_id())))));


--
-- Name: chats Users can update chats they are members of; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update chats they are members of" ON public.chats FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = chats.id) AND (chat_members.profile_id = public.profile_id()))))) WITH CHECK ((EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = chats.id) AND (chat_members.profile_id = public.profile_id())))));


--
-- Name: session_reports Users can update session reports for their team sessions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update session reports for their team sessions" ON public.session_reports FOR UPDATE TO authenticated USING ((session_id IN ( SELECT ts.id
   FROM (public.team_sessions ts
     JOIN public.team_members tm ON ((ts.team_id = tm.team_id)))
  WHERE (tm.member_id = public.profile_id()))));


--
-- Name: chat_members Users can update their own membership; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own membership" ON public.chat_members FOR UPDATE USING ((profile_id = public.profile_id())) WITH CHECK ((profile_id = public.profile_id()));


--
-- Name: messages Users can update their own messages; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can update their own messages" ON public.messages FOR UPDATE USING ((created_by = public.profile_id())) WITH CHECK (((created_by = public.profile_id()) AND (EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = messages.chat_id) AND (chat_members.profile_id = public.profile_id()))))));


--
-- Name: message_attachments Users can view attachments for messages they can see; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view attachments for messages they can see" ON public.message_attachments FOR SELECT USING ((EXISTS ( SELECT 1
   FROM (public.messages m
     JOIN public.chat_members cm ON ((m.chat_id = cm.chat_id)))
  WHERE ((m.id = message_attachments.message_id) AND (cm.profile_id = public.profile_id())))));


--
-- Name: chats Users can view chats they are members of; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view chats they are members of" ON public.chats FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = chats.id) AND (chat_members.profile_id = public.profile_id())))));


--
-- Name: chat_members Users can view members of chats they belong to; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view members of chats they belong to" ON public.chat_members FOR SELECT TO authenticated USING ((profile_id = public.profile_id()));


--
-- Name: messages Users can view messages in chats they belong to; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view messages in chats they belong to" ON public.messages FOR SELECT USING ((EXISTS ( SELECT 1
   FROM public.chat_members
  WHERE ((chat_members.chat_id = messages.chat_id) AND (chat_members.profile_id = public.profile_id())))));


--
-- Name: session_reports Users can view session reports for their team sessions; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Users can view session reports for their team sessions" ON public.session_reports FOR SELECT USING ((session_id IN ( SELECT ts.id
   FROM (public.team_sessions ts
     JOIN public.team_members tm ON ((ts.team_id = tm.team_id)))
  WHERE (tm.member_id = public.profile_id()))));


--
-- Name: opportunity_requirements allow Update Opportunity Join Table by Creator; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allow Update Opportunity Join Table by Creator" ON public.opportunity_requirements FOR UPDATE TO authenticated USING ((( SELECT opportunities.created_by
   FROM public.opportunities
  WHERE (opportunities.id = opportunity_requirements.opportunity_id)) = ( SELECT public.profile_id() AS profile_id)));


--
-- Name: session_invitations allow admins to create session invitations; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allow admins to create session invitations" ON public.session_invitations FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_user_team_admin(session_invitations.team_id) AS is_user_team_admin));


--
-- Name: medical_reports allow for team members to see; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allow for team members to see" ON public.medical_reports FOR SELECT TO authenticated USING (( SELECT public.is_user_in_team(medical_reports.team_id) AS is_user_in_team));


--
-- Name: session_invitations allow read access for members in team; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allow read access for members in team" ON public.session_invitations FOR SELECT TO authenticated USING (( SELECT public.is_user_in_team(session_invitations.team_id) AS is_user_in_team));


--
-- Name: profiles allow read when authenticated; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allow read when authenticated" ON public.profiles FOR SELECT TO authenticated USING ((public.uid() IS NOT NULL));


--
-- Name: medical_reports allow team member to create his own report; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allow team member to create his own report" ON public.medical_reports FOR INSERT TO authenticated WITH CHECK ((( SELECT public.is_user_in_team(medical_reports.team_id) AS is_user_in_team) AND (( SELECT public.get_profile_id_by_team_member(medical_reports.member_id) AS get_profile_id_by_team_member) = ( SELECT public.profile_id() AS profile_id))));


--
-- Name: team_sessions allows insertion if team admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allows insertion if team admin" ON public.team_sessions FOR INSERT TO authenticated WITH CHECK (( SELECT public.is_user_team_admin(team_sessions.team_id) AS is_user_team_admin));


--
-- Name: team_sessions allows update if team admin; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "allows update if team admin" ON public.team_sessions FOR UPDATE TO authenticated USING (( SELECT public.is_user_team_admin(team_sessions.team_id) AS is_user_team_admin)) WITH CHECK (( SELECT public.is_user_team_admin(team_sessions.team_id) AS is_user_team_admin));


--
-- Name: chat_members; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.chat_members ENABLE ROW LEVEL SECURITY;

--
-- Name: cities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.cities ENABLE ROW LEVEL SECURITY;

--
-- Name: countries; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.countries ENABLE ROW LEVEL SECURITY;

--
-- Name: team_sessions enable read access for members inside team; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "enable read access for members inside team" ON public.team_sessions FOR SELECT TO authenticated USING (( SELECT public.is_user_in_team(team_sessions.team_id) AS is_user_in_team));


--
-- Name: profiles enable update based on user_id; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "enable update based on user_id" ON public.profiles FOR UPDATE TO authenticated USING ((public.uid() = user_id));


--
-- Name: feedback_tickets; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.feedback_tickets ENABLE ROW LEVEL SECURITY;

--
-- Name: medical_reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.medical_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: message_attachments; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.message_attachments ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: opportunities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.opportunities ENABLE ROW LEVEL SECURITY;

--
-- Name: opportunity_applications; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.opportunity_applications ENABLE ROW LEVEL SECURITY;

--
-- Name: opportunity_requirements; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.opportunity_requirements ENABLE ROW LEVEL SECURITY;

--
-- Name: profile_experiences; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profile_experiences ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: saved_opportunities; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.saved_opportunities ENABLE ROW LEVEL SECURITY;

--
-- Name: seasons; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.seasons ENABLE ROW LEVEL SECURITY;

--
-- Name: session_invitations; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.session_invitations ENABLE ROW LEVEL SECURITY;

--
-- Name: session_reports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.session_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: sport_entity_profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sport_entity_profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: sports; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.sports ENABLE ROW LEVEL SECURITY;

--
-- Name: support_tickets; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.support_tickets ENABLE ROW LEVEL SECURITY;

--
-- Name: team_members; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;

--
-- Name: team_sessions; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.team_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: teams; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;

--
-- Name: team_sessions update session policy; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "update session policy" ON public.team_sessions FOR UPDATE TO authenticated USING (true) WITH CHECK (true);


--
-- Name: SCHEMA notifications; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA notifications TO anon;
GRANT USAGE ON SCHEMA notifications TO authenticated;
GRANT USAGE ON SCHEMA notifications TO service_role;


--
-- Name: SCHEMA profiles; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA profiles TO authenticated;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: FUNCTION accepted_session_reminder(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.accepted_session_reminder() TO anon;
GRANT ALL ON FUNCTION notifications.accepted_session_reminder() TO authenticated;
GRANT ALL ON FUNCTION notifications.accepted_session_reminder() TO service_role;


--
-- Name: FUNCTION application_status_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.application_status_notification() TO anon;
GRANT ALL ON FUNCTION notifications.application_status_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.application_status_notification() TO service_role;


--
-- Name: FUNCTION member_session_invitation_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.member_session_invitation_notification() TO anon;
GRANT ALL ON FUNCTION notifications.member_session_invitation_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.member_session_invitation_notification() TO service_role;


--
-- Name: FUNCTION new_applicant_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.new_applicant_notification() TO anon;
GRANT ALL ON FUNCTION notifications.new_applicant_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.new_applicant_notification() TO service_role;


--
-- Name: FUNCTION new_chat_message_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.new_chat_message_notification() TO anon;
GRANT ALL ON FUNCTION notifications.new_chat_message_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.new_chat_message_notification() TO service_role;


--
-- Name: FUNCTION new_medical_report_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.new_medical_report_notification() TO anon;
GRANT ALL ON FUNCTION notifications.new_medical_report_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.new_medical_report_notification() TO service_role;


--
-- Name: FUNCTION new_member_added_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.new_member_added_notification() TO anon;
GRANT ALL ON FUNCTION notifications.new_member_added_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.new_member_added_notification() TO service_role;


--
-- Name: FUNCTION new_member_evaluation_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.new_member_evaluation_notification() TO anon;
GRANT ALL ON FUNCTION notifications.new_member_evaluation_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.new_member_evaluation_notification() TO service_role;


--
-- Name: FUNCTION opportunity_closed_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.opportunity_closed_notification() TO anon;
GRANT ALL ON FUNCTION notifications.opportunity_closed_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.opportunity_closed_notification() TO service_role;


--
-- Name: FUNCTION opportunity_ending_reminder(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.opportunity_ending_reminder() TO anon;
GRANT ALL ON FUNCTION notifications.opportunity_ending_reminder() TO authenticated;
GRANT ALL ON FUNCTION notifications.opportunity_ending_reminder() TO service_role;


--
-- Name: FUNCTION profile_notifications_preferences(p_profile_id uuid); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.profile_notifications_preferences(p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION notifications.profile_notifications_preferences(p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION notifications.profile_notifications_preferences(p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION saved_opportunity_updated_notification(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.saved_opportunity_updated_notification() TO anon;
GRANT ALL ON FUNCTION notifications.saved_opportunity_updated_notification() TO authenticated;
GRANT ALL ON FUNCTION notifications.saved_opportunity_updated_notification() TO service_role;


--
-- Name: FUNCTION schedule_notification(p_template_id text, p_targets jsonb[], p_schedule_time timestamp without time zone, p_route text, p_params jsonb); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.schedule_notification(p_template_id text, p_targets jsonb[], p_schedule_time timestamp without time zone, p_route text, p_params jsonb) TO anon;
GRANT ALL ON FUNCTION notifications.schedule_notification(p_template_id text, p_targets jsonb[], p_schedule_time timestamp without time zone, p_route text, p_params jsonb) TO authenticated;
GRANT ALL ON FUNCTION notifications.schedule_notification(p_template_id text, p_targets jsonb[], p_schedule_time timestamp without time zone, p_route text, p_params jsonb) TO service_role;


--
-- Name: FUNCTION schedule_notification(p_template_id text, p_token text, p_schedule_time timestamp without time zone, p_route text, p_preferred_language text, p_params jsonb); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.schedule_notification(p_template_id text, p_token text, p_schedule_time timestamp without time zone, p_route text, p_preferred_language text, p_params jsonb) TO anon;
GRANT ALL ON FUNCTION notifications.schedule_notification(p_template_id text, p_token text, p_schedule_time timestamp without time zone, p_route text, p_preferred_language text, p_params jsonb) TO authenticated;
GRANT ALL ON FUNCTION notifications.schedule_notification(p_template_id text, p_token text, p_schedule_time timestamp without time zone, p_route text, p_preferred_language text, p_params jsonb) TO service_role;


--
-- Name: FUNCTION schedule_rpc(p_rpc_name text, p_payload jsonb, p_schedule_time timestamp with time zone); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.schedule_rpc(p_rpc_name text, p_payload jsonb, p_schedule_time timestamp with time zone) TO anon;
GRANT ALL ON FUNCTION notifications.schedule_rpc(p_rpc_name text, p_payload jsonb, p_schedule_time timestamp with time zone) TO authenticated;
GRANT ALL ON FUNCTION notifications.schedule_rpc(p_rpc_name text, p_payload jsonb, p_schedule_time timestamp with time zone) TO service_role;


--
-- Name: FUNCTION schedule_session_report_reminder(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.schedule_session_report_reminder() TO anon;
GRANT ALL ON FUNCTION notifications.schedule_session_report_reminder() TO authenticated;
GRANT ALL ON FUNCTION notifications.schedule_session_report_reminder() TO service_role;


--
-- Name: FUNCTION scheduled_session_invitation_reminder(); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.scheduled_session_invitation_reminder() TO anon;
GRANT ALL ON FUNCTION notifications.scheduled_session_invitation_reminder() TO authenticated;
GRANT ALL ON FUNCTION notifications.scheduled_session_invitation_reminder() TO service_role;


--
-- Name: FUNCTION send_notification(p_template_id text, p_targets jsonb[], p_route text, p_params jsonb); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.send_notification(p_template_id text, p_targets jsonb[], p_route text, p_params jsonb) TO anon;
GRANT ALL ON FUNCTION notifications.send_notification(p_template_id text, p_targets jsonb[], p_route text, p_params jsonb) TO authenticated;
GRANT ALL ON FUNCTION notifications.send_notification(p_template_id text, p_targets jsonb[], p_route text, p_params jsonb) TO service_role;


--
-- Name: FUNCTION send_notification(p_template_id text, p_token text, p_route text, p_preferred_language text, p_params jsonb); Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON FUNCTION notifications.send_notification(p_template_id text, p_token text, p_route text, p_preferred_language text, p_params jsonb) TO anon;
GRANT ALL ON FUNCTION notifications.send_notification(p_template_id text, p_token text, p_route text, p_preferred_language text, p_params jsonb) TO authenticated;
GRANT ALL ON FUNCTION notifications.send_notification(p_template_id text, p_token text, p_route text, p_preferred_language text, p_params jsonb) TO service_role;


--
-- Name: FUNCTION create_profile(p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_user_id text, p_city_id smallint, p_preferred_language text); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.create_profile(p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_user_id text, p_city_id smallint, p_preferred_language text) TO authenticated;


--
-- Name: FUNCTION create_profile_role(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.create_profile_role(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid) TO authenticated;


--
-- Name: FUNCTION delete_profile(p_profile_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.delete_profile(p_profile_id uuid) TO authenticated;


--
-- Name: FUNCTION delete_profile_role(p_profile_role_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.delete_profile_role(p_profile_role_id uuid) TO authenticated;


--
-- Name: FUNCTION get_profile(p_profile_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.get_profile(p_profile_id uuid) TO authenticated;


--
-- Name: FUNCTION get_role_data(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.get_role_data(p_role public.individual_role, p_sport_id uuid, p_profile_id uuid) TO authenticated;


--
-- Name: FUNCTION list_profile_roles(p_profile_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.list_profile_roles(p_profile_id uuid) TO authenticated;


--
-- Name: FUNCTION list_user_profiles(p_user_id text); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.list_user_profiles(p_user_id text) TO authenticated;


--
-- Name: FUNCTION select_active_profile(p_profile_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.select_active_profile(p_profile_id uuid) TO authenticated;


--
-- Name: FUNCTION update_club_staff_role(p_sport_id uuid, p_profile_id uuid, p_club_staff_role text, p_club_staff_department text, p_sport_entity_id uuid); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.update_club_staff_role(p_sport_id uuid, p_profile_id uuid, p_club_staff_role text, p_club_staff_department text, p_sport_entity_id uuid) TO authenticated;


--
-- Name: FUNCTION update_coach_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.update_coach_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb) TO authenticated;


--
-- Name: FUNCTION update_player_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.update_player_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text) TO authenticated;


--
-- Name: FUNCTION update_profile_basic_info(p_profile_id uuid, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_city_id smallint, p_bio text); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.update_profile_basic_info(p_profile_id uuid, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_country_id smallint, p_city_id smallint, p_bio text) TO authenticated;


--
-- Name: FUNCTION update_referee_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_entity_id uuid, p_referee_categories jsonb, p_referee_match_types jsonb); Type: ACL; Schema: profiles; Owner: postgres
--

GRANT ALL ON FUNCTION profiles.update_referee_role(p_sport_id uuid, p_profile_id uuid, p_sport_goal text, p_sport_entity_id uuid, p_referee_categories jsonb, p_referee_match_types jsonb) TO authenticated;


--
-- Name: FUNCTION accept_session_invitation(p_session_id uuid, p_status public.session_invitation_status); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.accept_session_invitation(p_session_id uuid, p_status public.session_invitation_status) TO anon;
GRANT ALL ON FUNCTION public.accept_session_invitation(p_session_id uuid, p_status public.session_invitation_status) TO authenticated;
GRANT ALL ON FUNCTION public.accept_session_invitation(p_session_id uuid, p_status public.session_invitation_status) TO service_role;


--
-- Name: FUNCTION broadcast_with_profile_id(payload jsonb, event_name text, topic text, is_private boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.broadcast_with_profile_id(payload jsonb, event_name text, topic text, is_private boolean) TO anon;
GRANT ALL ON FUNCTION public.broadcast_with_profile_id(payload jsonb, event_name text, topic text, is_private boolean) TO authenticated;
GRANT ALL ON FUNCTION public.broadcast_with_profile_id(payload jsonb, event_name text, topic text, is_private boolean) TO service_role;


--
-- Name: FUNCTION create_channel(p_channel_name text, p_owner_profile_id uuid, p_channel_logo_url text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_channel(p_channel_name text, p_owner_profile_id uuid, p_channel_logo_url text) TO anon;
GRANT ALL ON FUNCTION public.create_channel(p_channel_name text, p_owner_profile_id uuid, p_channel_logo_url text) TO authenticated;
GRANT ALL ON FUNCTION public.create_channel(p_channel_name text, p_owner_profile_id uuid, p_channel_logo_url text) TO service_role;


--
-- Name: FUNCTION create_feedback_ticket(p_related_module public.app_module, p_recommendation text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_feedback_ticket(p_related_module public.app_module, p_recommendation text) TO anon;
GRANT ALL ON FUNCTION public.create_feedback_ticket(p_related_module public.app_module, p_recommendation text) TO authenticated;
GRANT ALL ON FUNCTION public.create_feedback_ticket(p_related_module public.app_module, p_recommendation text) TO service_role;


--
-- Name: FUNCTION create_opportunity(p_title text, p_description text, p_category text, p_deadline timestamp with time zone, p_latitude real, p_longitude real, p_address text, p_min_age smallint, p_max_age smallint, p_languages jsonb, p_availability_date timestamp with time zone, p_min_experience_years smallint, p_questions jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_opportunity(p_title text, p_description text, p_category text, p_deadline timestamp with time zone, p_latitude real, p_longitude real, p_address text, p_min_age smallint, p_max_age smallint, p_languages jsonb, p_availability_date timestamp with time zone, p_min_experience_years smallint, p_questions jsonb) TO anon;
GRANT ALL ON FUNCTION public.create_opportunity(p_title text, p_description text, p_category text, p_deadline timestamp with time zone, p_latitude real, p_longitude real, p_address text, p_min_age smallint, p_max_age smallint, p_languages jsonb, p_availability_date timestamp with time zone, p_min_experience_years smallint, p_questions jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.create_opportunity(p_title text, p_description text, p_category text, p_deadline timestamp with time zone, p_latitude real, p_longitude real, p_address text, p_min_age smallint, p_max_age smallint, p_languages jsonb, p_availability_date timestamp with time zone, p_min_experience_years smallint, p_questions jsonb) TO service_role;


--
-- Name: FUNCTION create_profile_after_onboarding(p_user_type public.user_type, p_bio text, p_country_id smallint, p_city_id smallint, p_preferred_language text, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_primary_sport_id uuid, p_sport_role public.individual_role, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb, p_referee_categories jsonb, p_referee_match_types jsonb, p_entity_type public.sport_entity_type, p_entity_name text, p_entity_username text, p_entity_image_url text, p_address jsonb, p_entity_primary_sport_id uuid, p_contact_first_name text, p_contact_last_name text, p_contact_email text, p_contact_phone text, p_contact_website text, p_club_categories jsonb, p_youth_leagues jsonb, p_adult_men_divisions jsonb, p_adult_women_divisions jsonb, p_federation_category text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_profile_after_onboarding(p_user_type public.user_type, p_bio text, p_country_id smallint, p_city_id smallint, p_preferred_language text, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_primary_sport_id uuid, p_sport_role public.individual_role, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb, p_referee_categories jsonb, p_referee_match_types jsonb, p_entity_type public.sport_entity_type, p_entity_name text, p_entity_username text, p_entity_image_url text, p_address jsonb, p_entity_primary_sport_id uuid, p_contact_first_name text, p_contact_last_name text, p_contact_email text, p_contact_phone text, p_contact_website text, p_club_categories jsonb, p_youth_leagues jsonb, p_adult_men_divisions jsonb, p_adult_women_divisions jsonb, p_federation_category text) TO anon;
GRANT ALL ON FUNCTION public.create_profile_after_onboarding(p_user_type public.user_type, p_bio text, p_country_id smallint, p_city_id smallint, p_preferred_language text, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_primary_sport_id uuid, p_sport_role public.individual_role, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb, p_referee_categories jsonb, p_referee_match_types jsonb, p_entity_type public.sport_entity_type, p_entity_name text, p_entity_username text, p_entity_image_url text, p_address jsonb, p_entity_primary_sport_id uuid, p_contact_first_name text, p_contact_last_name text, p_contact_email text, p_contact_phone text, p_contact_website text, p_club_categories jsonb, p_youth_leagues jsonb, p_adult_men_divisions jsonb, p_adult_women_divisions jsonb, p_federation_category text) TO authenticated;
GRANT ALL ON FUNCTION public.create_profile_after_onboarding(p_user_type public.user_type, p_bio text, p_country_id smallint, p_city_id smallint, p_preferred_language text, p_first_name text, p_last_name text, p_username text, p_email text, p_image_url text, p_gender text, p_date_of_birth date, p_primary_sport_id uuid, p_sport_role public.individual_role, p_sport_goal text, p_sport_category text, p_academy_category text, p_sport_entity_id uuid, p_field_position text, p_strong_foot text, p_height_cm integer, p_player_status text, p_coach_role text, p_coach_certifications jsonb, p_coach_supervisions jsonb, p_referee_categories jsonb, p_referee_match_types jsonb, p_entity_type public.sport_entity_type, p_entity_name text, p_entity_username text, p_entity_image_url text, p_address jsonb, p_entity_primary_sport_id uuid, p_contact_first_name text, p_contact_last_name text, p_contact_email text, p_contact_phone text, p_contact_website text, p_club_categories jsonb, p_youth_leagues jsonb, p_adult_men_divisions jsonb, p_adult_women_divisions jsonb, p_federation_category text) TO service_role;


--
-- Name: FUNCTION create_session(p_team_id uuid, p_session_type public.session_type, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_location jsonb, p_description text, p_invited_members uuid[], p_attendance_hidden boolean, p_session_name text, p_opponent_team_id uuid, p_turf public.turf); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_session(p_team_id uuid, p_session_type public.session_type, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_location jsonb, p_description text, p_invited_members uuid[], p_attendance_hidden boolean, p_session_name text, p_opponent_team_id uuid, p_turf public.turf) TO anon;
GRANT ALL ON FUNCTION public.create_session(p_team_id uuid, p_session_type public.session_type, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_location jsonb, p_description text, p_invited_members uuid[], p_attendance_hidden boolean, p_session_name text, p_opponent_team_id uuid, p_turf public.turf) TO authenticated;
GRANT ALL ON FUNCTION public.create_session(p_team_id uuid, p_session_type public.session_type, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_location jsonb, p_description text, p_invited_members uuid[], p_attendance_hidden boolean, p_session_name text, p_opponent_team_id uuid, p_turf public.turf) TO service_role;


--
-- Name: FUNCTION create_support_ticket(p_subject text, p_message text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_support_ticket(p_subject text, p_message text) TO anon;
GRANT ALL ON FUNCTION public.create_support_ticket(p_subject text, p_message text) TO authenticated;
GRANT ALL ON FUNCTION public.create_support_ticket(p_subject text, p_message text) TO service_role;


--
-- Name: FUNCTION create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb) TO anon;
GRANT ALL ON FUNCTION public.create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.create_team(p_team_id uuid, p_team_name text, p_logo_url text, p_associated_club uuid, p_members jsonb) TO service_role;


--
-- Name: FUNCTION edit_session(p_session_id uuid, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_description text, p_location jsonb, p_new_invitees uuid[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.edit_session(p_session_id uuid, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_description text, p_location jsonb, p_new_invitees uuid[]) TO anon;
GRANT ALL ON FUNCTION public.edit_session(p_session_id uuid, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_description text, p_location jsonb, p_new_invitees uuid[]) TO authenticated;
GRANT ALL ON FUNCTION public.edit_session(p_session_id uuid, p_appointment_date timestamp without time zone, p_start_time timestamp without time zone, p_end_time timestamp without time zone, p_description text, p_location jsonb, p_new_invitees uuid[]) TO service_role;


--
-- Name: FUNCTION get_channels_for_profile(p_owner_profile_id text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_channels_for_profile(p_owner_profile_id text) TO anon;
GRANT ALL ON FUNCTION public.get_channels_for_profile(p_owner_profile_id text) TO authenticated;
GRANT ALL ON FUNCTION public.get_channels_for_profile(p_owner_profile_id text) TO service_role;


--
-- Name: FUNCTION get_composition_by_session_id(p_session_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_composition_by_session_id(p_session_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_composition_by_session_id(p_session_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_composition_by_session_id(p_session_id uuid) TO service_role;


--
-- Name: FUNCTION get_game_events_by_session_id(session_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_game_events_by_session_id(session_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_game_events_by_session_id(session_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_game_events_by_session_id(session_id uuid) TO service_role;


--
-- Name: FUNCTION get_invited_members(p_session_id uuid, q text, q_status public.session_invitation_status); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_invited_members(p_session_id uuid, q text, q_status public.session_invitation_status) TO anon;
GRANT ALL ON FUNCTION public.get_invited_members(p_session_id uuid, q text, q_status public.session_invitation_status) TO authenticated;
GRANT ALL ON FUNCTION public.get_invited_members(p_session_id uuid, q text, q_status public.session_invitation_status) TO service_role;


--
-- Name: FUNCTION get_medical_reports(p_team_id uuid, q text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_medical_reports(p_team_id uuid, q text) TO anon;
GRANT ALL ON FUNCTION public.get_medical_reports(p_team_id uuid, q text) TO authenticated;
GRANT ALL ON FUNCTION public.get_medical_reports(p_team_id uuid, q text) TO service_role;


--
-- Name: FUNCTION profile_id(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.profile_id() TO anon;
GRANT ALL ON FUNCTION public.profile_id() TO authenticated;
GRANT ALL ON FUNCTION public.profile_id() TO service_role;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uid() TO anon;
GRANT ALL ON FUNCTION public.uid() TO authenticated;
GRANT ALL ON FUNCTION public.uid() TO service_role;


--
-- Name: TABLE opportunities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.opportunities TO anon;
GRANT ALL ON TABLE public.opportunities TO authenticated;
GRANT ALL ON TABLE public.opportunities TO service_role;


--
-- Name: TABLE opportunity_applications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.opportunity_applications TO anon;
GRANT ALL ON TABLE public.opportunity_applications TO authenticated;
GRANT ALL ON TABLE public.opportunity_applications TO service_role;


--
-- Name: TABLE opportunity_requirements; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.opportunity_requirements TO anon;
GRANT ALL ON TABLE public.opportunity_requirements TO authenticated;
GRANT ALL ON TABLE public.opportunity_requirements TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE saved_opportunities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.saved_opportunities TO anon;
GRANT ALL ON TABLE public.saved_opportunities TO authenticated;
GRANT ALL ON TABLE public.saved_opportunities TO service_role;


--
-- Name: TABLE opportunity_view; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.opportunity_view TO anon;
GRANT ALL ON TABLE public.opportunity_view TO authenticated;
GRANT ALL ON TABLE public.opportunity_view TO service_role;


--
-- Name: FUNCTION get_nearby_opportunities(p_latitude real, p_longitude real, p_limit integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_nearby_opportunities(p_latitude real, p_longitude real, p_limit integer) TO anon;
GRANT ALL ON FUNCTION public.get_nearby_opportunities(p_latitude real, p_longitude real, p_limit integer) TO authenticated;
GRANT ALL ON FUNCTION public.get_nearby_opportunities(p_latitude real, p_longitude real, p_limit integer) TO service_role;


--
-- Name: FUNCTION get_opportunities_by_applicant(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_opportunities_by_applicant() TO anon;
GRANT ALL ON FUNCTION public.get_opportunities_by_applicant() TO authenticated;
GRANT ALL ON FUNCTION public.get_opportunities_by_applicant() TO service_role;


--
-- Name: FUNCTION get_opportunity_applicants(p_opportunity_id uuid, p_q text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_opportunity_applicants(p_opportunity_id uuid, p_q text) TO anon;
GRANT ALL ON FUNCTION public.get_opportunity_applicants(p_opportunity_id uuid, p_q text) TO authenticated;
GRANT ALL ON FUNCTION public.get_opportunity_applicants(p_opportunity_id uuid, p_q text) TO service_role;


--
-- Name: FUNCTION get_profile_avatar_url(p_profile_id uuid, user_type_val public.user_type); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_profile_avatar_url(p_profile_id uuid, user_type_val public.user_type) TO anon;
GRANT ALL ON FUNCTION public.get_profile_avatar_url(p_profile_id uuid, user_type_val public.user_type) TO authenticated;
GRANT ALL ON FUNCTION public.get_profile_avatar_url(p_profile_id uuid, user_type_val public.user_type) TO service_role;


--
-- Name: FUNCTION get_profile_display_name(p_profile_id uuid, user_type_val public.user_type); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_profile_display_name(p_profile_id uuid, user_type_val public.user_type) TO anon;
GRANT ALL ON FUNCTION public.get_profile_display_name(p_profile_id uuid, user_type_val public.user_type) TO authenticated;
GRANT ALL ON FUNCTION public.get_profile_display_name(p_profile_id uuid, user_type_val public.user_type) TO service_role;


--
-- Name: FUNCTION get_profile_experiences(p_sport_role public.individual_role, p_profile_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_profile_experiences(p_sport_role public.individual_role, p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_profile_experiences(p_sport_role public.individual_role, p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_profile_experiences(p_sport_role public.individual_role, p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION get_profile_id_by_team_member(team_member_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_profile_id_by_team_member(team_member_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_profile_id_by_team_member(team_member_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_profile_id_by_team_member(team_member_id uuid) TO service_role;


--
-- Name: FUNCTION get_ratings_by_session_id(p_session_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_ratings_by_session_id(p_session_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_ratings_by_session_id(p_session_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_ratings_by_session_id(p_session_id uuid) TO service_role;


--
-- Name: FUNCTION get_report_by_id(p_report_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_report_by_id(p_report_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_report_by_id(p_report_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_report_by_id(p_report_id uuid) TO service_role;


--
-- Name: FUNCTION get_reports(p_session_type text, p_team_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_reports(p_session_type text, p_team_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_reports(p_session_type text, p_team_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_reports(p_session_type text, p_team_id uuid) TO service_role;


--
-- Name: FUNCTION get_saved_opportunities(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_saved_opportunities() TO anon;
GRANT ALL ON FUNCTION public.get_saved_opportunities() TO authenticated;
GRANT ALL ON FUNCTION public.get_saved_opportunities() TO service_role;


--
-- Name: FUNCTION get_session_details_for_user(p_session_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_session_details_for_user(p_session_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_session_details_for_user(p_session_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_session_details_for_user(p_session_id uuid) TO service_role;


--
-- Name: FUNCTION get_sport_entity_profile(p_profile_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_sport_entity_profile(p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_sport_entity_profile(p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_sport_entity_profile(p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION get_team_chat_id(team_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_team_chat_id(team_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_team_chat_id(team_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_team_chat_id(team_id uuid) TO service_role;


--
-- Name: FUNCTION get_team_members(p_team_id uuid, q text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_team_members(p_team_id uuid, q text) TO anon;
GRANT ALL ON FUNCTION public.get_team_members(p_team_id uuid, q text) TO authenticated;
GRANT ALL ON FUNCTION public.get_team_members(p_team_id uuid, q text) TO service_role;


--
-- Name: FUNCTION get_team_profile(p_team_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_team_profile(p_team_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_team_profile(p_team_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_team_profile(p_team_id uuid) TO service_role;


--
-- Name: FUNCTION get_team_statistics(p_team_id uuid, p_matches_limit integer, p_order_descending boolean); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_team_statistics(p_team_id uuid, p_matches_limit integer, p_order_descending boolean) TO anon;
GRANT ALL ON FUNCTION public.get_team_statistics(p_team_id uuid, p_matches_limit integer, p_order_descending boolean) TO authenticated;
GRANT ALL ON FUNCTION public.get_team_statistics(p_team_id uuid, p_matches_limit integer, p_order_descending boolean) TO service_role;


--
-- Name: FUNCTION get_teams(p_profile_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.get_teams(p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION public.get_teams(p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_teams(p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION insert_notify_me(p_data jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.insert_notify_me(p_data jsonb) TO anon;
GRANT ALL ON FUNCTION public.insert_notify_me(p_data jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.insert_notify_me(p_data jsonb) TO service_role;


--
-- Name: FUNCTION is_user_in_team(p_team_id uuid, p_profile_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_user_in_team(p_team_id uuid, p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_user_in_team(p_team_id uuid, p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_user_in_team(p_team_id uuid, p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION is_user_team_admin(p_team_id uuid, p_profile_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.is_user_team_admin(p_team_id uuid, p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_user_team_admin(p_team_id uuid, p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_user_team_admin(p_team_id uuid, p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION join_channel(p_chat_id uuid, p_profile_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.join_channel(p_chat_id uuid, p_profile_id uuid) TO anon;
GRANT ALL ON FUNCTION public.join_channel(p_chat_id uuid, p_profile_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.join_channel(p_chat_id uuid, p_profile_id uuid) TO service_role;


--
-- Name: FUNCTION save_profile_experience(p_sport_role public.individual_role, p_experience_id uuid, p_sport_entity_id uuid, p_season_id uuid, p_category text, p_coach_role text, p_start_date date, p_end_date date); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.save_profile_experience(p_sport_role public.individual_role, p_experience_id uuid, p_sport_entity_id uuid, p_season_id uuid, p_category text, p_coach_role text, p_start_date date, p_end_date date) TO anon;
GRANT ALL ON FUNCTION public.save_profile_experience(p_sport_role public.individual_role, p_experience_id uuid, p_sport_entity_id uuid, p_season_id uuid, p_category text, p_coach_role text, p_start_date date, p_end_date date) TO authenticated;
GRANT ALL ON FUNCTION public.save_profile_experience(p_sport_role public.individual_role, p_experience_id uuid, p_sport_entity_id uuid, p_season_id uuid, p_category text, p_coach_role text, p_start_date date, p_end_date date) TO service_role;


--
-- Name: FUNCTION search_engine(p_query text, p_profile_types text[], p_min_age smallint, p_max_age smallint, p_location_city smallint, p_location_radius smallint, p_genders text[], p_player_categories text[], p_player_young_leagues text[], p_player_clubs uuid[], p_player_levels text[], p_player_positions text[], p_player_strong_foot text[], p_player_height_min smallint, p_player_height_max smallint, p_player_status text[], p_coach_categories text[], p_coach_young_leagues text[], p_coach_clubs uuid[], p_coach_levels text[], p_coach_roles text[], p_coach_certifications text[], p_referee_federations uuid[], p_referee_match_types text[], p_club_levels text[], p_federation_levels text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.search_engine(p_query text, p_profile_types text[], p_min_age smallint, p_max_age smallint, p_location_city smallint, p_location_radius smallint, p_genders text[], p_player_categories text[], p_player_young_leagues text[], p_player_clubs uuid[], p_player_levels text[], p_player_positions text[], p_player_strong_foot text[], p_player_height_min smallint, p_player_height_max smallint, p_player_status text[], p_coach_categories text[], p_coach_young_leagues text[], p_coach_clubs uuid[], p_coach_levels text[], p_coach_roles text[], p_coach_certifications text[], p_referee_federations uuid[], p_referee_match_types text[], p_club_levels text[], p_federation_levels text[]) TO anon;
GRANT ALL ON FUNCTION public.search_engine(p_query text, p_profile_types text[], p_min_age smallint, p_max_age smallint, p_location_city smallint, p_location_radius smallint, p_genders text[], p_player_categories text[], p_player_young_leagues text[], p_player_clubs uuid[], p_player_levels text[], p_player_positions text[], p_player_strong_foot text[], p_player_height_min smallint, p_player_height_max smallint, p_player_status text[], p_coach_categories text[], p_coach_young_leagues text[], p_coach_clubs uuid[], p_coach_levels text[], p_coach_roles text[], p_coach_certifications text[], p_referee_federations uuid[], p_referee_match_types text[], p_club_levels text[], p_federation_levels text[]) TO authenticated;
GRANT ALL ON FUNCTION public.search_engine(p_query text, p_profile_types text[], p_min_age smallint, p_max_age smallint, p_location_city smallint, p_location_radius smallint, p_genders text[], p_player_categories text[], p_player_young_leagues text[], p_player_clubs uuid[], p_player_levels text[], p_player_positions text[], p_player_strong_foot text[], p_player_height_min smallint, p_player_height_max smallint, p_player_status text[], p_coach_categories text[], p_coach_young_leagues text[], p_coach_clubs uuid[], p_coach_levels text[], p_coach_roles text[], p_coach_certifications text[], p_referee_federations uuid[], p_referee_match_types text[], p_club_levels text[], p_federation_levels text[]) TO service_role;


--
-- Name: FUNCTION send_message(p_chat_id uuid, p_message text, p_attachments jsonb); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.send_message(p_chat_id uuid, p_message text, p_attachments jsonb) TO anon;
GRANT ALL ON FUNCTION public.send_message(p_chat_id uuid, p_message text, p_attachments jsonb) TO authenticated;
GRANT ALL ON FUNCTION public.send_message(p_chat_id uuid, p_message text, p_attachments jsonb) TO service_role;


--
-- Name: FUNCTION set_preferred_language(p_language text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_preferred_language(p_language text) TO anon;
GRANT ALL ON FUNCTION public.set_preferred_language(p_language text) TO authenticated;
GRANT ALL ON FUNCTION public.set_preferred_language(p_language text) TO service_role;


--
-- Name: FUNCTION toggle_save_opportunity(p_opportunity_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.toggle_save_opportunity(p_opportunity_id uuid) TO anon;
GRANT ALL ON FUNCTION public.toggle_save_opportunity(p_opportunity_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.toggle_save_opportunity(p_opportunity_id uuid) TO service_role;


--
-- Name: FUNCTION trigger_member_session_invitation_notification(p_session_id uuid); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.trigger_member_session_invitation_notification(p_session_id uuid) TO anon;
GRANT ALL ON FUNCTION public.trigger_member_session_invitation_notification(p_session_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.trigger_member_session_invitation_notification(p_session_id uuid) TO service_role;


--
-- Name: FUNCTION update_last_updated(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_last_updated() TO anon;
GRANT ALL ON FUNCTION public.update_last_updated() TO authenticated;
GRANT ALL ON FUNCTION public.update_last_updated() TO service_role;


--
-- Name: FUNCTION update_opportunity_application_status(p_opportunity_id uuid, p_applicant_id uuid, p_status public.application_status); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_opportunity_application_status(p_opportunity_id uuid, p_applicant_id uuid, p_status public.application_status) TO anon;
GRANT ALL ON FUNCTION public.update_opportunity_application_status(p_opportunity_id uuid, p_applicant_id uuid, p_status public.application_status) TO authenticated;
GRANT ALL ON FUNCTION public.update_opportunity_application_status(p_opportunity_id uuid, p_applicant_id uuid, p_status public.application_status) TO service_role;


--
-- Name: FUNCTION update_profile_generated_columns(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.update_profile_generated_columns() TO anon;
GRANT ALL ON FUNCTION public.update_profile_generated_columns() TO authenticated;
GRANT ALL ON FUNCTION public.update_profile_generated_columns() TO service_role;


--
-- Name: FUNCTION user_opt_in_contacting(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.user_opt_in_contacting() TO anon;
GRANT ALL ON FUNCTION public.user_opt_in_contacting() TO authenticated;
GRANT ALL ON FUNCTION public.user_opt_in_contacting() TO service_role;


--
-- Name: FUNCTION validate_composition(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.validate_composition() TO anon;
GRANT ALL ON FUNCTION public.validate_composition() TO authenticated;
GRANT ALL ON FUNCTION public.validate_composition() TO service_role;


--
-- Name: TABLE communication_schedule_rules; Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON TABLE notifications.communication_schedule_rules TO anon;
GRANT ALL ON TABLE notifications.communication_schedule_rules TO authenticated;
GRANT ALL ON TABLE notifications.communication_schedule_rules TO service_role;


--
-- Name: TABLE communication_templates; Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON TABLE notifications.communication_templates TO anon;
GRANT ALL ON TABLE notifications.communication_templates TO authenticated;
GRANT ALL ON TABLE notifications.communication_templates TO service_role;


--
-- Name: TABLE communication_templates_assets; Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON TABLE notifications.communication_templates_assets TO anon;
GRANT ALL ON TABLE notifications.communication_templates_assets TO authenticated;
GRANT ALL ON TABLE notifications.communication_templates_assets TO service_role;


--
-- Name: TABLE lanaguages; Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON TABLE notifications.lanaguages TO anon;
GRANT ALL ON TABLE notifications.lanaguages TO authenticated;
GRANT ALL ON TABLE notifications.lanaguages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON TABLE notifications.schema_migrations TO anon;
GRANT ALL ON TABLE notifications.schema_migrations TO authenticated;
GRANT ALL ON TABLE notifications.schema_migrations TO service_role;


--
-- Name: TABLE user_communication_preferences; Type: ACL; Schema: notifications; Owner: postgres
--

GRANT ALL ON TABLE notifications.user_communication_preferences TO anon;
GRANT ALL ON TABLE notifications.user_communication_preferences TO authenticated;
GRANT ALL ON TABLE notifications.user_communication_preferences TO service_role;


--
-- Name: TABLE club_staff_profiles; Type: ACL; Schema: profiles; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE profiles.club_staff_profiles TO authenticated;


--
-- Name: TABLE coach_profiles; Type: ACL; Schema: profiles; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE profiles.coach_profiles TO authenticated;


--
-- Name: TABLE fan_profiles; Type: ACL; Schema: profiles; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE profiles.fan_profiles TO authenticated;


--
-- Name: TABLE player_profiles; Type: ACL; Schema: profiles; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE profiles.player_profiles TO authenticated;


--
-- Name: TABLE profile_roles; Type: ACL; Schema: profiles; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE profiles.profile_roles TO authenticated;


--
-- Name: TABLE referee_profiles; Type: ACL; Schema: profiles; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE profiles.referee_profiles TO authenticated;


--
-- Name: TABLE chat_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chat_members TO anon;
GRANT ALL ON TABLE public.chat_members TO authenticated;
GRANT ALL ON TABLE public.chat_members TO service_role;


--
-- Name: TABLE chats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chats TO anon;
GRANT ALL ON TABLE public.chats TO authenticated;
GRANT ALL ON TABLE public.chats TO service_role;


--
-- Name: TABLE team_members; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_members TO anon;
GRANT ALL ON TABLE public.team_members TO authenticated;
GRANT ALL ON TABLE public.team_members TO service_role;


--
-- Name: TABLE teams; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.teams TO anon;
GRANT ALL ON TABLE public.teams TO authenticated;
GRANT ALL ON TABLE public.teams TO service_role;


--
-- Name: TABLE chats_with_config; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.chats_with_config TO anon;
GRANT ALL ON TABLE public.chats_with_config TO authenticated;
GRANT ALL ON TABLE public.chats_with_config TO service_role;


--
-- Name: TABLE cities; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.cities TO anon;
GRANT ALL ON TABLE public.cities TO authenticated;
GRANT ALL ON TABLE public.cities TO service_role;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.countries TO anon;
GRANT ALL ON TABLE public.countries TO authenticated;
GRANT ALL ON TABLE public.countries TO service_role;


--
-- Name: TABLE feedback_tickets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.feedback_tickets TO anon;
GRANT ALL ON TABLE public.feedback_tickets TO authenticated;
GRANT ALL ON TABLE public.feedback_tickets TO service_role;


--
-- Name: TABLE medical_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.medical_reports TO anon;
GRANT ALL ON TABLE public.medical_reports TO authenticated;
GRANT ALL ON TABLE public.medical_reports TO service_role;


--
-- Name: TABLE members_evaluations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.members_evaluations TO anon;
GRANT ALL ON TABLE public.members_evaluations TO authenticated;
GRANT ALL ON TABLE public.members_evaluations TO service_role;


--
-- Name: TABLE message_attachments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.message_attachments TO anon;
GRANT ALL ON TABLE public.message_attachments TO authenticated;
GRANT ALL ON TABLE public.message_attachments TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.messages TO anon;
GRANT ALL ON TABLE public.messages TO authenticated;
GRANT ALL ON TABLE public.messages TO service_role;


--
-- Name: TABLE notify_me; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notify_me TO anon;
GRANT ALL ON TABLE public.notify_me TO authenticated;
GRANT ALL ON TABLE public.notify_me TO service_role;


--
-- Name: TABLE profile_experiences; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profile_experiences TO anon;
GRANT ALL ON TABLE public.profile_experiences TO authenticated;
GRANT ALL ON TABLE public.profile_experiences TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.schema_migrations TO anon;
GRANT ALL ON TABLE public.schema_migrations TO authenticated;
GRANT ALL ON TABLE public.schema_migrations TO service_role;


--
-- Name: TABLE seasons; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.seasons TO anon;
GRANT ALL ON TABLE public.seasons TO authenticated;
GRANT ALL ON TABLE public.seasons TO service_role;


--
-- Name: TABLE session_invitations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_invitations TO anon;
GRANT ALL ON TABLE public.session_invitations TO authenticated;
GRANT ALL ON TABLE public.session_invitations TO service_role;


--
-- Name: TABLE session_report_attendance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_report_attendance TO anon;
GRANT ALL ON TABLE public.session_report_attendance TO authenticated;
GRANT ALL ON TABLE public.session_report_attendance TO service_role;


--
-- Name: TABLE session_report_comments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_report_comments TO anon;
GRANT ALL ON TABLE public.session_report_comments TO authenticated;
GRANT ALL ON TABLE public.session_report_comments TO service_role;


--
-- Name: TABLE session_report_composition; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_report_composition TO anon;
GRANT ALL ON TABLE public.session_report_composition TO authenticated;
GRANT ALL ON TABLE public.session_report_composition TO service_role;


--
-- Name: TABLE session_report_game_stats; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_report_game_stats TO anon;
GRANT ALL ON TABLE public.session_report_game_stats TO authenticated;
GRANT ALL ON TABLE public.session_report_game_stats TO service_role;


--
-- Name: TABLE session_report_ratings; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_report_ratings TO anon;
GRANT ALL ON TABLE public.session_report_ratings TO authenticated;
GRANT ALL ON TABLE public.session_report_ratings TO service_role;


--
-- Name: TABLE session_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.session_reports TO anon;
GRANT ALL ON TABLE public.session_reports TO authenticated;
GRANT ALL ON TABLE public.session_reports TO service_role;


--
-- Name: TABLE sport_entity_profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sport_entity_profiles TO anon;
GRANT ALL ON TABLE public.sport_entity_profiles TO authenticated;
GRANT ALL ON TABLE public.sport_entity_profiles TO service_role;


--
-- Name: TABLE sports; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sports TO anon;
GRANT ALL ON TABLE public.sports TO authenticated;
GRANT ALL ON TABLE public.sports TO service_role;


--
-- Name: TABLE support_tickets; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.support_tickets TO anon;
GRANT ALL ON TABLE public.support_tickets TO authenticated;
GRANT ALL ON TABLE public.support_tickets TO service_role;


--
-- Name: TABLE team_sessions; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.team_sessions TO anon;
GRANT ALL ON TABLE public.team_sessions TO authenticated;
GRANT ALL ON TABLE public.team_sessions TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: notifications; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: notifications; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: notifications; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA notifications GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- PostgreSQL database dump complete
--

\unrestrict 4hlRe2dnLcNjCb9cP55nnMq87Vd81Io1keptP0MnhtcgYfUqDWYZK6idiFmMMkc

