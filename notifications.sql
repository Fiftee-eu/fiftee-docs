-- migrate:up
-- create schema notifications
CREATE SCHEMA notifications;

-- create table notifications
CREATE TABLE notifications.lanaguages (
    id TEXT PRIMARY KEY, -- Language code (ISO 639-1 format, e.g., 'en', 'fr')
    name TEXT NOT NULL, -- English name of the language
    native_name TEXT NOT NULL, -- Native name of the language (e.g., 'Français' for French)
    is_active BOOLEAN NOT NULL DEFAULT TRUE -- Whether this language is currently active/supported
);

COMMENT ON TABLE notifications.lanaguages IS 'Supported languages for notification localization';

COMMENT ON COLUMN notifications.lanaguages.id IS 'Language code in ISO 639-1 format';

COMMENT ON COLUMN notifications.lanaguages.name IS 'English name of the language';

COMMENT ON COLUMN notifications.lanaguages.native_name IS 'Native name of the language';

COMMENT ON COLUMN notifications.lanaguages.is_active IS 'Whether this language is currently active and supported';

INSERT INTO
    notifications.lanaguages (id, name, native_name)
VALUES ('en', 'English', 'English'),
    ('fr', 'French', 'Français'),
    ('nl', 'Dutch', 'Nederlands');

CREATE TYPE notifications.channel_type AS ENUM ('email', 'sms', 'push');

CREATE TYPE notifications.delivery_type AS ENUM ('immediate', 'scheduled', 'recurring');

CREATE TABLE notifications.communication_templates (
    id TEXT PRIMARY KEY, -- Unique template identifier (e.g., 'welcome_email', 'cart_reminder')
    channel notifications.channel_type NOT NULL, -- Communication channel type
    description TEXT DEFAULT '', -- Human-readable description of the template
    title_key TEXT NOT NULL, -- Localization key for the notification title
    body_key TEXT NOT NULL, -- Localization key for the notification body
    delivery_type notifications.delivery_type NOT NULL -- How the notification should be delivered
);

COMMENT ON TABLE notifications.communication_templates IS 'Templates for different types of communications';

COMMENT ON COLUMN notifications.communication_templates.id IS 'Unique template identifier (e.g., welcome_email, cart_reminder)';

COMMENT ON COLUMN notifications.communication_templates.channel IS 'Communication channel type (email, sms, push)';

COMMENT ON COLUMN notifications.communication_templates.description IS 'Human-readable description of what this template is for';

COMMENT ON COLUMN notifications.communication_templates.title_key IS 'Localization key for the notification title';

COMMENT ON COLUMN notifications.communication_templates.body_key IS 'Localization key for the notification body';

COMMENT ON COLUMN notifications.communication_templates.delivery_type IS 'How the notification should be delivered (immediate, scheduled, recurring)';

-- Scheduling Rules (when to send)
CREATE TABLE notifications.communication_schedule_rules (
    id TEXT PRIMARY KEY, -- Unique identifier for the schedule rule
    template_id TEXT REFERENCES notifications.communication_templates (id), -- Associated template
    delay TEXT, -- Delay after trigger (e.g., '1h', '2d', '1w')
    recurrence_pattern TEXT, -- Cron expression or simple pattern (e.g., '2d', '1w')
    max_occurrences INTEGER, -- Maximum number of times to send (NULL = unlimited)
    stop_after_duration TEXT, -- Stop sending after this duration (e.g., '30d')
    quiet_hours_start TIME WITH TIME ZONE, -- Start of quiet hours (no notifications)
    quiet_hours_end TIME WITH TIME ZONE -- End of quiet hours
);

COMMENT ON TABLE notifications.communication_schedule_rules IS 'Rules defining when and how often notifications should be sent';

COMMENT ON COLUMN notifications.communication_schedule_rules.id IS 'Unique identifier for the schedule rule';

COMMENT ON COLUMN notifications.communication_schedule_rules.template_id IS 'Reference to the communication template this rule applies to';

COMMENT ON COLUMN notifications.communication_schedule_rules.delay IS 'Delay after trigger event (e.g., 1h, 2d, 1w)';

COMMENT ON COLUMN notifications.communication_schedule_rules.recurrence_pattern IS 'Cron expression or simple pattern for recurring notifications';

COMMENT ON COLUMN notifications.communication_schedule_rules.max_occurrences IS 'Maximum number of times to send this notification (NULL for unlimited)';

COMMENT ON COLUMN notifications.communication_schedule_rules.stop_after_duration IS 'Stop sending notifications after this duration regardless of max_occurrences';

COMMENT ON COLUMN notifications.communication_schedule_rules.quiet_hours_start IS 'Start time for quiet hours when notifications should not be sent';

COMMENT ON COLUMN notifications.communication_schedule_rules.quiet_hours_end IS 'End time for quiet hours when notifications should not be sent';

CREATE TABLE notifications.communication_templates_assets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Unique identifier for the asset
    template_id TEXT NOT NULL REFERENCES notifications.communication_templates (id), -- Associated template
    asset_url TEXT, -- URL to an asset (image, icon, etc.)
    icon TEXT, -- Icon identifier or name
    color TEXT, -- Color code (hex, rgb, etc.)
    route TEXT, -- Deep link or route for navigation
    payload JSONB DEFAULT '{}' -- Additional data payload for the notification
);

COMMENT ON TABLE notifications.communication_templates_assets IS 'Assets and metadata associated with communication templates';

COMMENT ON COLUMN notifications.communication_templates_assets.id IS 'Unique identifier for the asset record';

COMMENT ON COLUMN notifications.communication_templates_assets.template_id IS 'Reference to the communication template this asset belongs to';

COMMENT ON COLUMN notifications.communication_templates_assets.asset_url IS 'URL to an external asset like an image or icon';

COMMENT ON COLUMN notifications.communication_templates_assets.icon IS 'Icon identifier or name for the notification';

COMMENT ON COLUMN notifications.communication_templates_assets.color IS 'Color code for the notification (hex, rgb, etc.)';

COMMENT ON COLUMN notifications.communication_templates_assets.route IS 'Deep link or route for navigation when notification is tapped';

COMMENT ON COLUMN notifications.communication_templates_assets.payload IS 'Additional JSON data payload for the notification';

CREATE TABLE notifications.user_communication_preferences (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid (), -- Unique identifier for the preference
    user_id UUID NOT NULL REFERENCES public.profiles (id), -- User this preference belongs to
    template_id TEXT NOT NULL REFERENCES notifications.communication_templates (id), -- Template this preference applies to
    is_active BOOLEAN NOT NULL DEFAULT TRUE -- Whether the user wants to receive this type of notification
);

COMMENT ON TABLE notifications.user_communication_preferences IS 'User preferences for different types of notifications';

COMMENT ON COLUMN notifications.user_communication_preferences.id IS 'Unique identifier for the preference record';

COMMENT ON COLUMN notifications.user_communication_preferences.user_id IS 'Reference to the user this preference belongs to';

COMMENT ON COLUMN notifications.user_communication_preferences.template_id IS 'Reference to the communication template this preference applies to';

COMMENT ON COLUMN notifications.user_communication_preferences.is_active IS 'Whether the user wants to receive notifications of this type';
