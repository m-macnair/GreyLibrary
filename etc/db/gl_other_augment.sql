alter table subject_tag add column tagging_user_id INTEGER;
CREATE INDEX subject_tag_tagging_user_id on subject_tag(tagging_user_id);
