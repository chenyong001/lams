-- Turn off autocommit, so nothing is committed if there is an error
SET AUTOCOMMIT = 0;
SET FOREIGN_KEY_CHECKS=0;
----------------------Put all sql statements below here-------------------------

-- LKC-40 
-- Remove logs belong to all other users except leader
CREATE TABLE temp_select AS SELECT group_leader_uid uid
		FROM tl_lascrt11_session WHERE group_leader_uid IS NOT NULL;
ALTER TABLE temp_select ADD INDEX index1 (uid ASC);
DELETE FROM tl_lascrt11_answer_log WHERE user_uid NOT IN (SELECT uid FROM temp_select);
DROP TABLE temp_select;

--Make ScratchieAnswerVisitLog belong to session and not user, thus being shared by all users
ALTER TABLE tl_lascrt11_answer_log DROP FOREIGN KEY FK_NEW_610529188_693580A441F9365D;
ALTER TABLE tl_lascrt11_answer_log DROP INDEX  FK_NEW_610529188_693580A441F9365D;
ALTER TABLE tl_lascrt11_answer_log DROP COLUMN user_uid;
ALTER TABLE tl_lascrt11_answer_log ADD INDEX sessionIdIndex (session_id);

-- Make mark belong to session and not user, thus being shared by all users
ALTER TABLE tl_lascrt11_session ADD COLUMN mark INTEGER DEFAULT 0;
UPDATE tl_lascrt11_session, tl_lascrt11_user
		SET tl_lascrt11_session.mark = tl_lascrt11_user.mark 
		WHERE tl_lascrt11_user.uid = tl_lascrt11_session.group_leader_uid;
ALTER TABLE tl_lascrt11_user DROP COLUMN mark;

-- Make scratching_finished flag belong to session and not user, thus being shared by all users
ALTER TABLE tl_lascrt11_session ADD COLUMN scratching_finished smallint DEFAULT 0;
UPDATE tl_lascrt11_session, tl_lascrt11_user
		SET tl_lascrt11_session.scratching_finished = tl_lascrt11_user.scratching_finished 
		WHERE tl_lascrt11_user.uid = tl_lascrt11_session.group_leader_uid;
ALTER TABLE tl_lascrt11_user DROP COLUMN scratching_finished;

----------------------Put all sql statements above here-------------------------

-- If there were no errors, commit and restore autocommit to on
COMMIT;
SET AUTOCOMMIT = 1;
SET FOREIGN_KEY_CHECKS=1;