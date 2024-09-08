CREATE TABLE file (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL,
	dir_id INTEGER,
	file_type_id INTEGER,
	/* one hash may legitimately belong to more than one file, e.g. duplicate files in the db */
	hash_id INTEGER,
	size INTEGER
);
CREATE TABLE sqlite_sequence(name,seq);
CREATE INDEX file_name ON file(name);
CREATE INDEX file_dir_id ON file(dir_id);
CREATE INDEX file_file_type_id ON file(file_type_id);
CREATE INDEX file_hash_id ON file(hash_id);
CREATE INDEX file_size ON file(size);
CREATE TABLE file_type (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	suffix TEXT NOT NULL UNIQUE,
	mime_type TEXT NOT NULL
);
CREATE TABLE hash (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	file_id INTEGER,
	/* this may be overkill */
	hashed BOOLEAN CHECK (hashed IN (0, 1)),
	md5_string TEXT,
	sha1_string TEXT
);
CREATE INDEX hash_file_id ON hash(file_id);
CREATE INDEX hash_md5_string ON hash(md5_string);
CREATE INDEX hash_sha1_string ON hash(sha1_string);
CREATE TABLE dir (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL
);
CREATE INDEX dir_name ON dir(name);
CREATE TABLE host_dir_substitution (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	original_id INTEGER,
	alternate_id INTEGER
);
CREATE INDEX host_dir_substitution_original_id ON host_dir_substitution(original_id);
CREATE INDEX host_dir_substitution_alternate_id ON host_dir_substitution(alternate_id);
CREATE TABLE host (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	name TEXT NOT NULL
);
CREATE INDEX host_name ON host(name);
CREATE TABLE host_file (
	id INTEGER PRIMARY KEY AUTOINCREMENT,
	file_id INTEGER,
	host_id INTEGER
);
CREATE INDEX host_file_file_id ON host_file(file_id);
CREATE INDEX host_file_host_id ON host_file(host_id);
