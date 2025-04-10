#!/bin/bash
rm test_db.sqlite
sqlite3 test_db.sqlite < ../../foreign/Moo-Task-FileDB/etc/db/core.sql
sqlite3 test_db.sqlite < ../../foreign/Moo-Task-FileDB/etc/db/host.sql
sqlite3 test_db.sqlite < ../../foreign/Moo-Task-SubjectTagDB/etc/db/core.sql
sqlite3 test_db.sqlite < ./gl_core.sql
sqlite3 test_db.sqlite < ./gl_file_db_augment.sql

