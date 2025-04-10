select st.subject_id from tag t join subject_tag st on t.id = st.tag_id where lower(t.string) = 'blood'
intersect 
select st.subject_id from tag t join subject_tag st on t.id = st.tag_id where lower(t.string) = 'angel'
