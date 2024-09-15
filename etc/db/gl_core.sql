/* GL Core*/
/* preview file */
CREATE TABLE preview_file (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	preview_id INTEGER,
	original_id INTEGER
);
CREATE INDEX preview_file_preview_id ON preview_file(preview_id);
CREATE INDEX preview_file_original_id ON preview_file(original_id);


/* Subject */ 

CREATE TABLE subject_files (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	subject_id INTEGER,
	file_id INTEGER,
	file_type TEXT
);
CREATE INDEX subject_files_subject_id ON subject_files(subject_id);
CREATE INDEX subject_files_file_id ON subject_files(file_id);
CREATE INDEX subject_files_file_type ON subject_files(file_type);

CREATE TABLE file_meta (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	file_id INTEGER,
	is_thumbnail INTEGER DEFAULT 0,
	no_hash  INTEGER DEFAULT 0

);
CREATE INDEX file_meta_file_id ON file_meta(file_id);


