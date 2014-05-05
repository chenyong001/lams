-- CVS ID: $Id$
 
INSERT INTO lams_tool
(
tool_signature,
service_name,
tool_display_name,
description,
tool_identifier,
tool_version,
learning_library_id,
default_tool_content_id,
valid_flag,
grouping_support_type_id,
supports_run_offline_flag,
learner_url,
learner_preview_url,
learner_progress_url,
author_url,
monitor_url,
define_later_url,
export_pfolio_learner_url,
export_pfolio_class_url,
help_url,
language_file,
create_date_time,
modified_date_time,
supports_outputs
)
VALUES
(
'lalead11',
'leaderselectionService',
'Leaderselection',
'Leaderselection',
'leaderselection',
'@tool_version@',
NULL,
NULL,
0,
2,
1,
'tool/lalead11/learning.do?mode=learner',
'tool/lalead11/learning.do?mode=author',
'tool/lalead11/learning.do?mode=teacher',
'tool/lalead11/authoring.do',
'tool/lalead11/monitoring.do',
'tool/lalead11/authoring.do?mode=teacher',
'tool/lalead11/exportPortfolio?mode=learner',
'tool/lalead11/exportPortfolio?mode=teacher',
'http://wiki.lamsfoundation.org/display/lamsdocs/lalead11',
'org.lamsfoundation.lams.tool.leaderselection.ApplicationResources',
NOW(),
NOW(),
1
)
