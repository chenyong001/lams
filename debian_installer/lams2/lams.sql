-- MySQL dump 10.11
--
-- Host: localhost    Database: lams
-- ------------------------------------------------------
-- Server version	5.0.45-Debian_1ubuntu3.3-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `lams_activity_category`
--

DROP TABLE IF EXISTS `lams_activity_category`;
CREATE TABLE `lams_activity_category` (
  `activity_category_id` int(3) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`activity_category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_activity_category`
--

LOCK TABLES `lams_activity_category` WRITE;
/*!40000 ALTER TABLE `lams_activity_category` DISABLE KEYS */;
INSERT INTO `lams_activity_category` VALUES (1,'SYSTEM'),(2,'COLLABORATION'),(3,'ASSESSMENT'),(4,'CONTENT'),(5,'SPLIT'),(6,'RESPONSE');
/*!40000 ALTER TABLE `lams_activity_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_activity_learners`
--

DROP TABLE IF EXISTS `lams_activity_learners`;
CREATE TABLE `lams_activity_learners` (
  `user_id` bigint(20) NOT NULL default '0',
  `activity_id` bigint(20) NOT NULL default '0',
  KEY `user_id` (`user_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `FK_TABLE_32_1` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`),
  CONSTRAINT `FK_TABLE_32_2` FOREIGN KEY (`activity_id`) REFERENCES `lams_learning_activity` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_activity_learners`
--

LOCK TABLES `lams_activity_learners` WRITE;
/*!40000 ALTER TABLE `lams_activity_learners` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_activity_learners` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_auth_method_type`
--

DROP TABLE IF EXISTS `lams_auth_method_type`;
CREATE TABLE `lams_auth_method_type` (
  `authentication_method_type_id` int(3) NOT NULL,
  `description` varchar(64) NOT NULL,
  PRIMARY KEY  (`authentication_method_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_auth_method_type`
--

LOCK TABLES `lams_auth_method_type` WRITE;
/*!40000 ALTER TABLE `lams_auth_method_type` DISABLE KEYS */;
INSERT INTO `lams_auth_method_type` VALUES (1,'LAMS'),(2,'WEB_AUTH'),(3,'LDAP');
/*!40000 ALTER TABLE `lams_auth_method_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_authentication_method`
--

DROP TABLE IF EXISTS `lams_authentication_method`;
CREATE TABLE `lams_authentication_method` (
  `authentication_method_id` bigint(20) NOT NULL,
  `authentication_method_type_id` int(3) NOT NULL default '0',
  `authentication_method_name` varchar(255) NOT NULL,
  PRIMARY KEY  (`authentication_method_id`),
  UNIQUE KEY `UQ_lams_authentication_method_1` (`authentication_method_name`),
  KEY `authentication_method_type_id` (`authentication_method_type_id`),
  CONSTRAINT `FK_lams_authorization_method_1` FOREIGN KEY (`authentication_method_type_id`) REFERENCES `lams_auth_method_type` (`authentication_method_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_authentication_method`
--

LOCK TABLES `lams_authentication_method` WRITE;
/*!40000 ALTER TABLE `lams_authentication_method` DISABLE KEYS */;
INSERT INTO `lams_authentication_method` VALUES (1,1,'LAMS-Database'),(2,2,'Oxford-WebAuth'),(3,3,'MQ-LDAP');
/*!40000 ALTER TABLE `lams_authentication_method` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_branch_activity_entry`
--

DROP TABLE IF EXISTS `lams_branch_activity_entry`;
CREATE TABLE `lams_branch_activity_entry` (
  `entry_id` bigint(20) NOT NULL auto_increment,
  `entry_ui_id` int(11) default NULL,
  `group_id` bigint(20) default NULL,
  `sequence_activity_id` bigint(20) NOT NULL,
  `branch_activity_id` bigint(20) NOT NULL,
  `condition_id` bigint(20) default NULL,
  PRIMARY KEY  (`entry_id`),
  KEY `group_id` (`group_id`),
  KEY `sequence_activity_id` (`sequence_activity_id`),
  KEY `branch_activity_id` (`branch_activity_id`),
  KEY `condition_id` (`condition_id`),
  CONSTRAINT `FK_lams_group_activity_1` FOREIGN KEY (`group_id`) REFERENCES `lams_group` (`group_id`),
  CONSTRAINT `FK_lams_branch_map_sequence` FOREIGN KEY (`sequence_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`),
  CONSTRAINT `FK_lams_branch_map_branch` FOREIGN KEY (`branch_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`),
  CONSTRAINT `FK_lams_branch_activity_entry_4` FOREIGN KEY (`condition_id`) REFERENCES `lams_branch_condition` (`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_branch_activity_entry`
--

LOCK TABLES `lams_branch_activity_entry` WRITE;
/*!40000 ALTER TABLE `lams_branch_activity_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_branch_activity_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_branch_condition`
--

DROP TABLE IF EXISTS `lams_branch_condition`;
CREATE TABLE `lams_branch_condition` (
  `condition_id` bigint(20) NOT NULL auto_increment,
  `condition_ui_id` int(11) default NULL,
  `order_id` int(11) default NULL,
  `name` varchar(255) NOT NULL,
  `display_name` varchar(255) default NULL,
  `type` varchar(30) NOT NULL,
  `start_value` varchar(255) default NULL,
  `end_value` varchar(255) default NULL,
  `exact_match_value` varchar(255) default NULL,
  PRIMARY KEY  (`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_branch_condition`
--

LOCK TABLES `lams_branch_condition` WRITE;
/*!40000 ALTER TABLE `lams_branch_condition` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_branch_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_configuration`
--

DROP TABLE IF EXISTS `lams_configuration`;
CREATE TABLE `lams_configuration` (
  `config_key` varchar(30) NOT NULL,
  `config_value` varchar(255) default NULL,
  `description_key` varchar(255) default NULL,
  `header_name` varchar(50) default NULL,
  `format` varchar(30) default NULL,
  `required` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_configuration`
--

LOCK TABLES `lams_configuration` WRITE;
/*!40000 ALTER TABLE `lams_configuration` DISABLE KEYS */;
INSERT INTO `lams_configuration` VALUES ('AdminScreenSize','800x600','config.admin.screen.size','config.header.look.feel','STRING',1),('AllowDirectLessonLaunch','false','config.allow.direct.lesson.launch','config.header.features','BOOLEAN',1),('AllowLiveEdit','true','config.allow.live.edit','config.header.features','BOOLEAN',1),('AuthoringActivitiesColour','true','config.authoring.activities.colour','config.header.look.feel','BOOLEAN',1),('AuthoringClientVersion','2.1.0.200807071045','config.authoring.client.version','config.header.versions','STRING',1),('AuthoringScreenSize','800x600','config.authoring.screen.size','config.header.look.feel','STRING',1),('CleanupPreviewOlderThanDays','7','config.cleanup.preview.older.than.days','config.header.system','LONG',1),('ContentRepositoryPath','/var/opt/lams/repository','config.content.repository.path','config.header.uploads','STRING',1),('CustomTabLink','','config.custom.tab.link','config.header.look.feel','STRING',0),('CustomTabTitle','','config.custom.tab.title','config.header.look.feel','STRING',0),('DefaultFlashTheme','default','config.default.flash.theme','config.header.look.feel','STRING',1),('DefaultHTMLTheme','defaultHTML','config.default.html.theme','config.header.look.feel','STRING',1),('DictionaryDateCreated','2008-05-19','config.dictionary.date.created','config.header.versions','STRING',1),('DumpDir','/var/opt/lams/dump','config.dump.dir','config.header.system','STRING',1),('EARDir','/usr/local/jboss-4.0.2/server/default/deploy/lams.ear','config.ear.dir','config.header.system','STRING',1),('EnableFlash','true','config.flash.enable','config.header.features','BOOLEAN',1),('ExecutableExtensions','.bat,.bin,.com,.cmd,.exe,.msi,.msp,.ocx,.pif,.scr,.sct,.sh,.shs,.vbs','config.executable.extensions','config.header.uploads','STRING',1),('HelpURL','http://wiki.lamsfoundation.org/display/lamsdocs/','config.help.url','config.header.system','STRING',1),('LamsSupportEmail','','config.lams.support.email','config.header.email','STRING',0),('LAMS_Community_enable','false','config.community.enable','config.header.features','BOOLEAN',1),('LDAPAddr1Attr','postalAddress','admin.user.address_line_1','config.header.ldap.attributes','STRING',0),('LDAPAddr2Attr','','admin.user.address_line_2','config.header.ldap.attributes','STRING',0),('LDAPAddr3Attr','','admin.user.address_line_3','config.header.ldap.attributes','STRING',0),('LDAPAuthorMap','Teacher;SeniorStaff;Principal','config.ldap.author.map','config.header.ldap.attributes','STRING',0),('LDAPCityAttr','l','admin.user.city','config.header.ldap.attributes','STRING',0),('LDAPCountryAttr','','admin.user.country','config.header.ldap.attributes','STRING',0),('LDAPDayPhoneAttr','telephoneNumber','admin.user.day_phone','config.header.ldap.attributes','STRING',0),('LDAPDisabledAttr','!accountStatus','sysadmin.disabled','config.header.ldap.attributes','STRING',0),('LDAPEmailAttr','mail','admin.user.email','config.header.ldap.attributes','STRING',0),('LDAPEncryptPasswordFromBrowser','true','config.ldap.encrypt.password.from.browser','config.header.ldap','BOOLEAN',1),('LDAPEveningPhoneAttr','homePhone','admin.user.evening_phone','config.header.ldap.attributes','STRING',0),('LDAPFaxAttr','facsimileTelephoneNumber','admin.user.fax','config.header.ldap.attributes','STRING',0),('LDAPFNameAttr','givenName','admin.user.first_name','config.header.ldap.attributes','STRING',0),('LDAPGroupAdminMap','Teacher;SeniorStaff','config.ldap.group.admin.map','config.header.ldap.attributes','STRING',0),('LDAPGroupManagerMap','Principal','config.ldap.group.manager.map','config.header.ldap.attributes','STRING',0),('LDAPLearnerMap','Student;SchoolSupportStaff;Teacher;SeniorStaff;Principal','config.ldap.learner.map','config.header.ldap.attributes','STRING',0),('LDAPLNameAttr','sn','admin.user.last_name','config.header.ldap.attributes','STRING',0),('LDAPLocaleAttr','preferredLanguage','admin.organisation.locale','config.header.ldap.attributes','STRING',0),('LDAPLoginAttr','uid','admin.user.login','config.header.ldap.attributes','STRING',0),('LDAPMobileAttr','mobile','admin.user.mobile_phone','config.header.ldap.attributes','STRING',0),('LDAPMonitorMap','SchoolSupportStaff;Teacher;SeniorStaff;Principal','config.ldap.monitor.map','config.header.ldap.attributes','STRING',0),('LDAPOnlyOneOrg','true','config.ldap.only.one.org','config.header.ldap','BOOLEAN',1),('LDAPOrgAttr','schoolCode','admin.course','config.header.ldap.attributes','STRING',0),('LDAPOrgField','code','config.ldap.org.field','config.header.ldap.attributes','STRING',0),('LDAPPostcodeAttr','postalCode','admin.user.postcode','config.header.ldap.attributes','STRING',0),('LDAPPrincipalDNPrefix','cn=','config.ldap.principal.dn.prefix','config.header.ldap','STRING',0),('LDAPPrincipalDNSuffix',',ou=Users,dc=melcoe,dc=mq,dc=edu,dc=au','config.ldap.principal.dn.suffix','config.header.ldap','STRING',0),('LDAPProviderURL','ldap://192.168.111.15','config.ldap.provider.url','config.header.ldap','STRING',0),('LDAPProvisioningEnabled','false','config.ldap.provisioning.enabled','config.header.ldap','BOOLEAN',1),('LDAPRolesAttr','memberOf','admin.user.roles','config.header.ldap.attributes','STRING',0),('LDAPSearchResultsPageSize','100','config.ldap.search.results.page.size','config.header.ldap','LONG',0),('LDAPSecurityAuthentication','simple','config.ldap.security.authentication','config.header.ldap','STRING',0),('LDAPSecurityProtocol','','config.ldap.security.protocol','config.header.ldap','STRING',0),('LDAPStateAttr','st','admin.user.state','config.header.ldap.attributes','STRING',0),('LDAPTruststorePassword','','config.ldap.truststore.password','config.header.ldap','STRING',0),('LDAPTruststorePath','','config.ldap.truststore.path','config.header.ldap','STRING',0),('LDAPUpdateOnLogin','true','config.ldap.update.on.login','config.header.ldap','BOOLEAN',1),('LearnerClientVersion','2.1.0.200807071045','config.learner.client.version','config.header.versions','STRING',1),('LearnerProgressBatchSize','10','config.learner.progress.batch.size','config.header.look.feel','LONG',1),('LearnerScreenSize','800x600','config.learner.screen.size','config.header.look.feel','STRING',1),('MonitorClientVersion','2.1.0.200807071045','config.monitor.client.version','config.header.versions','STRING',1),('MonitorScreenSize','800x600','config.monitor.screen.size','config.header.look.feel','STRING',1),('ServerLanguage','en_AU','config.server.language','config.header.look.feel','STRING',1),('ServerPageDirection','LTR','config.server.page.direction','config.header.look.feel','STRING',1),('ServerURL','http://shaun.melcoe.mq.edu.au/lams/','config.server.url','config.header.system','STRING',1),('ServerURLContextPath','lams/','config.server.url.context.path','config.header.system','STRING',1),('ServerVersionNumber','2.1.0.200807071045','config.server.version.number','config.header.versions','STRING',1),('SMTPServer','','config.smtp.server','config.header.email','STRING',0),('TempDir','/var/opt/lams/temp','config.temp.dir','config.header.system','STRING',1),('UploadFileMaxMemorySize','4096','config.upload.file.max.memory.size','config.header.uploads','LONG',1),('UploadFileMaxSize','1048576','config.upload.file.max.size','config.header.uploads','LONG',1),('UploadLargeFileMaxSize','10485760','config.upload.large.file.max.size','config.header.uploads','LONG',1),('UseCacheDebugListener','false','config.use.cache.debug.listener','config.header.system','BOOLEAN',1),('UserInactiveTimeout','86400','config.user.inactive.timeout','config.header.system','LONG',1),('Version','2.1.1','config.version','config.header.system','STRING',1),('XmppAdmin','admin','config.xmpp.admin','config.header.chat','STRING',0),('XmppConference','conference.shaun.melcoe.mq.edu.au','config.xmpp.conference','config.header.chat','STRING',0),('XmppDomain','shaun.melcoe.mq.edu.au','config.xmpp.domain','config.header.chat','STRING',0),('XmppPassword','wildfire','config.xmpp.password','config.header.chat','STRING',0);
/*!40000 ALTER TABLE `lams_configuration` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_copy_type`
--

DROP TABLE IF EXISTS `lams_copy_type`;
CREATE TABLE `lams_copy_type` (
  `copy_type_id` tinyint(4) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`copy_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_copy_type`
--

LOCK TABLES `lams_copy_type` WRITE;
/*!40000 ALTER TABLE `lams_copy_type` DISABLE KEYS */;
INSERT INTO `lams_copy_type` VALUES (1,'NONE'),(2,'LESSON'),(3,'PREVIEW');
/*!40000 ALTER TABLE `lams_copy_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_cr_credential`
--

DROP TABLE IF EXISTS `lams_cr_credential`;
CREATE TABLE `lams_cr_credential` (
  `credential_id` bigint(20) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY  (`credential_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Records the identification properties for a tool.';

--
-- Dumping data for table `lams_cr_credential`
--

LOCK TABLES `lams_cr_credential` WRITE;
/*!40000 ALTER TABLE `lams_cr_credential` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_cr_credential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_cr_node`
--

DROP TABLE IF EXISTS `lams_cr_node`;
CREATE TABLE `lams_cr_node` (
  `node_id` bigint(20) unsigned NOT NULL auto_increment,
  `workspace_id` bigint(20) unsigned NOT NULL,
  `path` varchar(255) default NULL,
  `type` varchar(255) NOT NULL,
  `created_date_time` datetime NOT NULL,
  `next_version_id` bigint(20) unsigned NOT NULL default '1',
  `parent_nv_id` bigint(20) unsigned default NULL,
  PRIMARY KEY  (`node_id`),
  KEY `workspace_id` (`workspace_id`),
  CONSTRAINT `FK_lams_cr_node_1` FOREIGN KEY (`workspace_id`) REFERENCES `lams_cr_workspace` (`workspace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='The main table containing the node definition';

--
-- Dumping data for table `lams_cr_node`
--

LOCK TABLES `lams_cr_node` WRITE;
/*!40000 ALTER TABLE `lams_cr_node` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_cr_node` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_cr_node_version`
--

DROP TABLE IF EXISTS `lams_cr_node_version`;
CREATE TABLE `lams_cr_node_version` (
  `nv_id` bigint(20) unsigned NOT NULL auto_increment,
  `node_id` bigint(20) unsigned NOT NULL,
  `version_id` bigint(20) unsigned NOT NULL,
  `created_date_time` datetime NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`nv_id`),
  KEY `node_id` (`node_id`),
  CONSTRAINT `FK_lams_cr_node_version_2` FOREIGN KEY (`node_id`) REFERENCES `lams_cr_node` (`node_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Represents a version of a node';

--
-- Dumping data for table `lams_cr_node_version`
--

LOCK TABLES `lams_cr_node_version` WRITE;
/*!40000 ALTER TABLE `lams_cr_node_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_cr_node_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_cr_node_version_property`
--

DROP TABLE IF EXISTS `lams_cr_node_version_property`;
CREATE TABLE `lams_cr_node_version_property` (
  `id` bigint(20) unsigned NOT NULL auto_increment,
  `nv_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(255) NOT NULL,
  `type` tinyint(4) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `nv_id` (`nv_id`),
  CONSTRAINT `FK_lams_cr_node_version_property_1` FOREIGN KEY (`nv_id`) REFERENCES `lams_cr_node_version` (`nv_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_cr_node_version_property`
--

LOCK TABLES `lams_cr_node_version_property` WRITE;
/*!40000 ALTER TABLE `lams_cr_node_version_property` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_cr_node_version_property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_cr_workspace`
--

DROP TABLE IF EXISTS `lams_cr_workspace`;
CREATE TABLE `lams_cr_workspace` (
  `workspace_id` bigint(20) unsigned NOT NULL auto_increment,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`workspace_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Content repository workspace';

--
-- Dumping data for table `lams_cr_workspace`
--

LOCK TABLES `lams_cr_workspace` WRITE;
/*!40000 ALTER TABLE `lams_cr_workspace` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_cr_workspace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_cr_workspace_credential`
--

DROP TABLE IF EXISTS `lams_cr_workspace_credential`;
CREATE TABLE `lams_cr_workspace_credential` (
  `wc_id` bigint(20) unsigned NOT NULL auto_increment,
  `workspace_id` bigint(20) unsigned NOT NULL,
  `credential_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY  (`wc_id`),
  KEY `workspace_id` (`workspace_id`),
  KEY `credential_id` (`credential_id`),
  CONSTRAINT `FK_lams_cr_workspace_credential_1` FOREIGN KEY (`workspace_id`) REFERENCES `lams_cr_workspace` (`workspace_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_cr_workspace_credential_2` FOREIGN KEY (`credential_id`) REFERENCES `lams_cr_credential` (`credential_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Maps tools access to workspaces';

--
-- Dumping data for table `lams_cr_workspace_credential`
--

LOCK TABLES `lams_cr_workspace_credential` WRITE;
/*!40000 ALTER TABLE `lams_cr_workspace_credential` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_cr_workspace_credential` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_css_property`
--

DROP TABLE IF EXISTS `lams_css_property`;
CREATE TABLE `lams_css_property` (
  `property_id` bigint(20) NOT NULL auto_increment,
  `style_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `value` varchar(100) NOT NULL,
  `style_subset` varchar(20) default NULL,
  `type` tinyint(4) NOT NULL,
  PRIMARY KEY  (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_css_property`
--

LOCK TABLES `lams_css_property` WRITE;
/*!40000 ALTER TABLE `lams_css_property` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_css_property` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_css_style`
--

DROP TABLE IF EXISTS `lams_css_style`;
CREATE TABLE `lams_css_style` (
  `style_id` bigint(20) NOT NULL auto_increment,
  `theme_ve_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`style_id`),
  KEY `theme_ve_id` (`theme_ve_id`),
  CONSTRAINT `FK_lams_css_style_1` FOREIGN KEY (`theme_ve_id`) REFERENCES `lams_css_theme_ve` (`theme_ve_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Groups lams_css_property into a CSSStyleDeclaration.';

--
-- Dumping data for table `lams_css_style`
--

LOCK TABLES `lams_css_style` WRITE;
/*!40000 ALTER TABLE `lams_css_style` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_css_style` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_css_theme_ve`
--

DROP TABLE IF EXISTS `lams_css_theme_ve`;
CREATE TABLE `lams_css_theme_ve` (
  `theme_ve_id` bigint(20) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `description` varchar(100) default NULL,
  `parent_id` bigint(20) default NULL,
  `theme_flag` tinyint(1) NOT NULL default '0',
  `image_directory` varchar(100) default NULL,
  PRIMARY KEY  (`theme_ve_id`),
  KEY `parent_id` (`parent_id`),
  CONSTRAINT `FK_lams_css_theme_ve_2` FOREIGN KEY (`parent_id`) REFERENCES `lams_css_theme_ve` (`theme_ve_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COMMENT='Stores both the Flash theme and visual element';

--
-- Dumping data for table `lams_css_theme_ve`
--

LOCK TABLES `lams_css_theme_ve` WRITE;
/*!40000 ALTER TABLE `lams_css_theme_ve` DISABLE KEYS */;
INSERT INTO `lams_css_theme_ve` VALUES (1,'default','Default Flash style',NULL,1,NULL),(2,'defaultHTML','Default HTML style',NULL,1,'css'),(3,'rams','RAMS Default Flash style',NULL,1,NULL),(4,'ramsthemeHTML','RAMS Default HTML sty;e',NULL,1,'ramsthemecss');
/*!40000 ALTER TABLE `lams_css_theme_ve` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_ext_course_class_map`
--

DROP TABLE IF EXISTS `lams_ext_course_class_map`;
CREATE TABLE `lams_ext_course_class_map` (
  `sid` int(11) NOT NULL auto_increment,
  `courseid` varchar(255) NOT NULL,
  `classid` bigint(20) NOT NULL,
  `ext_server_org_map_id` int(11) NOT NULL,
  PRIMARY KEY  (`sid`),
  KEY `classid` (`classid`),
  KEY `ext_server_org_map_id` (`ext_server_org_map_id`),
  CONSTRAINT `lams_ext_course_class_map_fk1` FOREIGN KEY (`ext_server_org_map_id`) REFERENCES `lams_ext_server_org_map` (`sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lams_ext_course_class_map_fk` FOREIGN KEY (`classid`) REFERENCES `lams_organisation` (`organisation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_ext_course_class_map`
--

LOCK TABLES `lams_ext_course_class_map` WRITE;
/*!40000 ALTER TABLE `lams_ext_course_class_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_ext_course_class_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_ext_server_org_map`
--

DROP TABLE IF EXISTS `lams_ext_server_org_map`;
CREATE TABLE `lams_ext_server_org_map` (
  `sid` int(11) NOT NULL auto_increment,
  `serverid` varchar(255) NOT NULL,
  `serverkey` text NOT NULL,
  `servername` varchar(255) NOT NULL,
  `serverdesc` text,
  `prefix` varchar(11) NOT NULL,
  `userinfo_url` text NOT NULL,
  `timeout_url` text NOT NULL,
  `disabled` bit(1) NOT NULL,
  `orgid` bigint(20) default NULL,
  PRIMARY KEY  (`sid`),
  UNIQUE KEY `serverid` (`serverid`),
  UNIQUE KEY `prefix` (`prefix`),
  KEY `orgid` (`orgid`),
  CONSTRAINT `lams_ext_server_org_map_fk` FOREIGN KEY (`orgid`) REFERENCES `lams_organisation` (`organisation_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_ext_server_org_map`
--

LOCK TABLES `lams_ext_server_org_map` WRITE;
/*!40000 ALTER TABLE `lams_ext_server_org_map` DISABLE KEYS */;
INSERT INTO `lams_ext_server_org_map` VALUES (1,'moodle','moodle','moodle','moodle','mdl','http://localhost/moodle/mod/lamstwo/userinfo.php?ts=%timestamp%&un=%username%&hs=%hash%','http://dummy','\0',7);
/*!40000 ALTER TABLE `lams_ext_server_org_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_ext_user_userid_map`
--

DROP TABLE IF EXISTS `lams_ext_user_userid_map`;
CREATE TABLE `lams_ext_user_userid_map` (
  `sid` int(11) NOT NULL auto_increment,
  `external_username` varchar(250) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `ext_server_org_map_id` int(11) NOT NULL,
  PRIMARY KEY  (`sid`),
  KEY `user_id` (`user_id`),
  KEY `ext_server_org_map_id` (`ext_server_org_map_id`),
  CONSTRAINT `lams_ext_user_userid_map_fk1` FOREIGN KEY (`ext_server_org_map_id`) REFERENCES `lams_ext_server_org_map` (`sid`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `lams_ext_user_userid_map_fk` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_ext_user_userid_map`
--

LOCK TABLES `lams_ext_user_userid_map` WRITE;
/*!40000 ALTER TABLE `lams_ext_user_userid_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_ext_user_userid_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_gate_activity_level`
--

DROP TABLE IF EXISTS `lams_gate_activity_level`;
CREATE TABLE `lams_gate_activity_level` (
  `gate_activity_level_id` int(11) NOT NULL default '0',
  `description` varchar(128) NOT NULL,
  PRIMARY KEY  (`gate_activity_level_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_gate_activity_level`
--

LOCK TABLES `lams_gate_activity_level` WRITE;
/*!40000 ALTER TABLE `lams_gate_activity_level` DISABLE KEYS */;
INSERT INTO `lams_gate_activity_level` VALUES (1,'LEARNER'),(2,'GROUP'),(3,'CLASS');
/*!40000 ALTER TABLE `lams_gate_activity_level` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_group`
--

DROP TABLE IF EXISTS `lams_group`;
CREATE TABLE `lams_group` (
  `group_id` bigint(20) NOT NULL auto_increment,
  `group_name` varchar(255) NOT NULL,
  `grouping_id` bigint(20) NOT NULL,
  `order_id` int(6) NOT NULL default '1',
  `group_ui_id` int(11) default NULL,
  PRIMARY KEY  (`group_id`),
  KEY `grouping_id` (`grouping_id`),
  CONSTRAINT `FK_lams_learning_group_1` FOREIGN KEY (`grouping_id`) REFERENCES `lams_grouping` (`grouping_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_group`
--

LOCK TABLES `lams_group` WRITE;
/*!40000 ALTER TABLE `lams_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_grouping`
--

DROP TABLE IF EXISTS `lams_grouping`;
CREATE TABLE `lams_grouping` (
  `grouping_id` bigint(20) NOT NULL auto_increment,
  `grouping_ui_id` int(11) default NULL,
  `grouping_type_id` int(11) NOT NULL,
  `number_of_groups` int(11) default NULL,
  `learners_per_group` int(11) default NULL,
  `staff_group_id` bigint(20) default '0',
  `max_number_of_groups` int(3) default NULL,
  PRIMARY KEY  (`grouping_id`),
  KEY `grouping_type_id` (`grouping_type_id`),
  CONSTRAINT `FK_lams_learning_grouping_1` FOREIGN KEY (`grouping_type_id`) REFERENCES `lams_grouping_type` (`grouping_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_grouping`
--

LOCK TABLES `lams_grouping` WRITE;
/*!40000 ALTER TABLE `lams_grouping` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_grouping` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_grouping_support_type`
--

DROP TABLE IF EXISTS `lams_grouping_support_type`;
CREATE TABLE `lams_grouping_support_type` (
  `grouping_support_type_id` int(3) NOT NULL,
  `description` varchar(64) NOT NULL,
  PRIMARY KEY  (`grouping_support_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_grouping_support_type`
--

LOCK TABLES `lams_grouping_support_type` WRITE;
/*!40000 ALTER TABLE `lams_grouping_support_type` DISABLE KEYS */;
INSERT INTO `lams_grouping_support_type` VALUES (1,'NONE'),(2,'OPTIONAL'),(3,'REQUIRED');
/*!40000 ALTER TABLE `lams_grouping_support_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_grouping_type`
--

DROP TABLE IF EXISTS `lams_grouping_type`;
CREATE TABLE `lams_grouping_type` (
  `grouping_type_id` int(11) NOT NULL,
  `description` varchar(128) NOT NULL,
  PRIMARY KEY  (`grouping_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_grouping_type`
--

LOCK TABLES `lams_grouping_type` WRITE;
/*!40000 ALTER TABLE `lams_grouping_type` DISABLE KEYS */;
INSERT INTO `lams_grouping_type` VALUES (1,'RANDOM_GROUPING'),(2,'CHOSEN_GROUPING'),(3,'CLASS_GROUPING');
/*!40000 ALTER TABLE `lams_grouping_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_input_activity`
--

DROP TABLE IF EXISTS `lams_input_activity`;
CREATE TABLE `lams_input_activity` (
  `activity_id` bigint(20) NOT NULL,
  `input_activity_id` bigint(20) NOT NULL,
  UNIQUE KEY `UQ_lams_input_activity_1` (`activity_id`,`input_activity_id`),
  KEY `activity_id` (`activity_id`),
  KEY `activity_id_2` (`activity_id`),
  CONSTRAINT `FK_lams_input_activity_1` FOREIGN KEY (`activity_id`) REFERENCES `lams_learning_activity` (`activity_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_input_activity_2` FOREIGN KEY (`activity_id`) REFERENCES `lams_learning_activity` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_input_activity`
--

LOCK TABLES `lams_input_activity` WRITE;
/*!40000 ALTER TABLE `lams_input_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_input_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_learner_progress`
--

DROP TABLE IF EXISTS `lams_learner_progress`;
CREATE TABLE `lams_learner_progress` (
  `learner_progress_id` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) NOT NULL,
  `lesson_id` bigint(20) NOT NULL,
  `lesson_completed_flag` tinyint(1) NOT NULL default '0',
  `waiting_flag` tinyint(4) NOT NULL,
  `start_date_time` datetime NOT NULL,
  `finish_date_time` datetime default NULL,
  `current_activity_id` bigint(20) default NULL,
  `next_activity_id` bigint(20) default NULL,
  `previous_activity_id` bigint(20) default NULL,
  `requires_restart_flag` tinyint(1) NOT NULL,
  PRIMARY KEY  (`learner_progress_id`),
  UNIQUE KEY `IX_lams_learner_progress_1` (`user_id`,`lesson_id`),
  KEY `user_id` (`user_id`),
  KEY `lesson_id` (`lesson_id`),
  KEY `current_activity_id` (`current_activity_id`),
  KEY `next_activity_id` (`next_activity_id`),
  KEY `previous_activity_id` (`previous_activity_id`),
  CONSTRAINT `FK_lams_learner_progress_1` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`),
  CONSTRAINT `FK_lams_learner_progress_2` FOREIGN KEY (`lesson_id`) REFERENCES `lams_lesson` (`lesson_id`),
  CONSTRAINT `FK_lams_learner_progress_3` FOREIGN KEY (`current_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`),
  CONSTRAINT `FK_lams_learner_progress_4` FOREIGN KEY (`next_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`),
  CONSTRAINT `FK_lams_learner_progress_5` FOREIGN KEY (`previous_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_learner_progress`
--

LOCK TABLES `lams_learner_progress` WRITE;
/*!40000 ALTER TABLE `lams_learner_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_learner_progress` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_learning_activity`
--

DROP TABLE IF EXISTS `lams_learning_activity`;
CREATE TABLE `lams_learning_activity` (
  `activity_id` bigint(20) NOT NULL auto_increment,
  `activity_ui_id` int(11) default NULL,
  `description` text,
  `title` varchar(255) default NULL,
  `help_text` text,
  `xcoord` int(11) default NULL,
  `ycoord` int(11) default NULL,
  `parent_activity_id` bigint(20) default NULL,
  `parent_ui_id` int(11) default NULL,
  `learning_activity_type_id` int(11) NOT NULL default '0',
  `grouping_support_type_id` int(3) NOT NULL,
  `apply_grouping_flag` tinyint(1) NOT NULL,
  `grouping_id` bigint(20) default NULL,
  `grouping_ui_id` int(11) default NULL,
  `order_id` int(11) default NULL,
  `define_later_flag` tinyint(4) NOT NULL default '0',
  `learning_design_id` bigint(20) default NULL,
  `learning_library_id` bigint(20) default NULL,
  `create_date_time` datetime NOT NULL,
  `run_offline_flag` tinyint(1) NOT NULL,
  `max_number_of_options` int(5) default NULL,
  `min_number_of_options` int(5) default NULL,
  `options_instructions` text,
  `tool_id` bigint(20) default NULL,
  `tool_content_id` bigint(20) default NULL,
  `activity_category_id` int(3) NOT NULL,
  `gate_activity_level_id` int(11) default NULL,
  `gate_open_flag` tinyint(1) default NULL,
  `gate_start_time_offset` bigint(38) default NULL,
  `gate_end_time_offset` bigint(38) default NULL,
  `gate_start_date_time` datetime default NULL,
  `gate_end_date_time` datetime default NULL,
  `library_activity_ui_image` varchar(255) default NULL,
  `create_grouping_id` bigint(20) default NULL,
  `create_grouping_ui_id` int(11) default NULL,
  `library_activity_id` bigint(20) default NULL,
  `language_file` varchar(255) default NULL,
  `system_tool_id` bigint(20) default NULL,
  `read_only` tinyint(4) default '0',
  `initialised` tinyint(4) default '0',
  `default_activity_id` bigint(20) default NULL,
  `start_xcoord` int(11) default NULL,
  `start_ycoord` int(11) default NULL,
  `end_xcoord` int(11) default NULL,
  `end_ycoord` int(11) default NULL,
  `stop_after_activity` tinyint(4) NOT NULL default '0',
  PRIMARY KEY  (`activity_id`),
  KEY `learning_library_id` (`learning_library_id`),
  KEY `learning_design_id` (`learning_design_id`),
  KEY `parent_activity_id` (`parent_activity_id`),
  KEY `learning_activity_type_id` (`learning_activity_type_id`),
  KEY `grouping_id` (`grouping_id`),
  KEY `tool_id` (`tool_id`),
  KEY `gate_activity_level_id` (`gate_activity_level_id`),
  KEY `create_grouping_id` (`create_grouping_id`),
  KEY `library_activity_id` (`library_activity_id`),
  KEY `activity_category_id` (`activity_category_id`),
  KEY `grouping_support_type_id` (`grouping_support_type_id`),
  KEY `system_tool_id` (`system_tool_id`),
  CONSTRAINT `FK_lams_learning_activity_7` FOREIGN KEY (`learning_library_id`) REFERENCES `lams_learning_library` (`learning_library_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_learning_activity_6` FOREIGN KEY (`learning_design_id`) REFERENCES `lams_learning_design` (`learning_design_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_learning_activity_2` FOREIGN KEY (`parent_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_learning_activity_3` FOREIGN KEY (`learning_activity_type_id`) REFERENCES `lams_learning_activity_type` (`learning_activity_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_learning_activity_6` FOREIGN KEY (`grouping_id`) REFERENCES `lams_grouping` (`grouping_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_learning_activity_8` FOREIGN KEY (`tool_id`) REFERENCES `lams_tool` (`tool_id`),
  CONSTRAINT `FK_lams_learning_activity_10` FOREIGN KEY (`gate_activity_level_id`) REFERENCES `lams_gate_activity_level` (`gate_activity_level_id`),
  CONSTRAINT `FK_lams_learning_activity_9` FOREIGN KEY (`create_grouping_id`) REFERENCES `lams_grouping` (`grouping_id`),
  CONSTRAINT `FK_lams_learning_activity_11` FOREIGN KEY (`library_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`),
  CONSTRAINT `FK_lams_learning_activity_12` FOREIGN KEY (`activity_category_id`) REFERENCES `lams_activity_category` (`activity_category_id`),
  CONSTRAINT `FK_lams_learning_activity_13` FOREIGN KEY (`grouping_support_type_id`) REFERENCES `lams_grouping_support_type` (`grouping_support_type_id`),
  CONSTRAINT `FK_lams_learning_activity_14` FOREIGN KEY (`system_tool_id`) REFERENCES `lams_system_tool` (`system_tool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_learning_activity`
--

LOCK TABLES `lams_learning_activity` WRITE;
/*!40000 ALTER TABLE `lams_learning_activity` DISABLE KEYS */;
INSERT INTO `lams_learning_activity` VALUES (1,NULL,'Forum/Message Board','Forum','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,1,'2008-07-07 10:47:32',0,NULL,NULL,NULL,1,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lafrum11/images/icon_forum.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.forum.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(2,NULL,'Displays a NoticeboardX','NoticeboardX','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,2,'2008-07-07 10:47:38',0,NULL,NULL,NULL,2,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lanb11/images/icon_htmlnb.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.noticeboard.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(3,NULL,'Allows creation and use of question and answer format','Question and Answer','Help text',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,3,'2008-07-07 10:47:42',0,NULL,NULL,NULL,3,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,'tool/laqa11/images/icon_questionanswer.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.qa.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(4,NULL,'Uploading of files by learners, for review by teachers.','Submit File','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,4,'2008-07-07 10:47:48',0,NULL,NULL,NULL,4,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lasbmt11/images/icon_reportsubmission.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.sbmt.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(5,NULL,'Chat Tool','Chat Tool','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,5,'2008-07-07 10:47:55',0,NULL,NULL,NULL,5,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lachat11/images/icon_chat.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.chat.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(6,NULL,'Share Resources','Share Resources','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,6,'2008-07-07 10:48:04',0,NULL,NULL,NULL,6,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'tool/larsrc11/images/icon_rsrc.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.rsrc.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(7,NULL,'Allows creation and use of voting format','Voting','Help text',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,7,'2008-07-07 10:48:09',0,NULL,NULL,NULL,7,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lavote11/images/icon_ranking.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.vote.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(8,NULL,'Notebook Tool','Notebook Tool','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,8,'2008-07-07 10:48:15',0,NULL,NULL,NULL,8,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lantbk11/images/icon_notebook.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.notebook.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(9,NULL,'Survey','Survey','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,9,'2008-07-07 10:48:22',0,NULL,NULL,NULL,9,NULL,6,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lasurv11/images/icon_survey.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.survey.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(10,NULL,'Scribe Tool','Scribe Tool','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,10,'2008-07-07 10:48:28',0,NULL,NULL,NULL,10,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lascrb11/images/icon_scribe.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.scribe.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(11,NULL,'TaskList','TaskList','Put some help text here.',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,11,'2008-07-07 10:48:36',0,NULL,NULL,NULL,11,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'tool/latask10/images/icon_taskList.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.taskList.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(12,NULL,'Allows creation and use of multiple choice questioning format','Multiple Choice Questions','Help text',NULL,NULL,NULL,NULL,1,2,0,NULL,NULL,NULL,0,NULL,12,'2008-07-07 10:48:40',0,NULL,NULL,NULL,12,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lamc11/images/icon_mcq.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.mc.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(13,NULL,'Combined Share Resources and Forum','Discuss Shared Resources','Learners to discuss items they have viewed via Share Resources.',NULL,NULL,NULL,NULL,6,2,0,NULL,NULL,NULL,0,NULL,13,'2008-07-07 10:48:41',0,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'images/icon_urlcontentmessageboard.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.library.llid13.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(14,NULL,'Share Resources','Share Resources','Share Resources',NULL,NULL,13,NULL,1,2,0,NULL,NULL,NULL,0,NULL,NULL,'2008-07-07 10:48:41',0,NULL,NULL,NULL,6,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'tool/larsrc11/images/icon_rsrc.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.rsrc.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(15,NULL,'Forum/Message Board','Forum','Forum/Message Board',NULL,NULL,13,NULL,1,2,0,NULL,NULL,NULL,0,NULL,NULL,'2008-07-07 10:48:41',0,NULL,NULL,NULL,1,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lafrum11/images/icon_forum.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.forum.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(16,NULL,'Combined Chat and Scribe','Prepare Group Report','Learners to prepare group report, discussing report in chat',NULL,NULL,NULL,NULL,6,2,0,NULL,NULL,NULL,0,NULL,14,'2008-07-07 10:48:42',0,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'images/icon_groupreporting.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.library.llid14.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(17,NULL,'Chat Tool','Chat Tool','Chat',NULL,NULL,16,NULL,1,2,0,NULL,NULL,NULL,0,NULL,NULL,'2008-07-07 10:48:42',0,NULL,NULL,NULL,5,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lachat11/images/icon_chat.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.chat.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(18,NULL,'Scribe Tool','Scribe Tool','Scribe',NULL,NULL,16,NULL,1,2,0,NULL,NULL,NULL,0,NULL,NULL,'2008-07-07 10:48:42',0,NULL,NULL,NULL,10,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lascrb11/images/icon_scribe.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.scribe.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(19,NULL,'Combined Chat and Scribe','Prepare Group Report','Learners to prepare group report, discussing report in chat',NULL,NULL,NULL,NULL,6,2,0,NULL,NULL,NULL,0,NULL,15,'2008-07-07 10:48:44',0,NULL,NULL,NULL,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,'images/icon_forum_and_scribe.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.library.llid15.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(20,NULL,'Forum/Message Board','Forum','Forum/Message Board',NULL,NULL,19,NULL,1,2,0,NULL,NULL,NULL,0,NULL,NULL,'2008-07-07 10:48:44',0,NULL,NULL,NULL,1,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lafrum11/images/icon_forum.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.forum.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0),(21,NULL,'Scribe Tool','Scribe Tool','Scribe',NULL,NULL,19,NULL,1,2,0,NULL,NULL,NULL,0,NULL,NULL,'2008-07-07 10:48:44',0,NULL,NULL,NULL,10,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,'tool/lascrb11/images/icon_scribe.swf',NULL,NULL,NULL,'org.lamsfoundation.lams.tool.scribe.ApplicationResources',NULL,0,0,NULL,NULL,NULL,NULL,NULL,0);
/*!40000 ALTER TABLE `lams_learning_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_learning_activity_type`
--

DROP TABLE IF EXISTS `lams_learning_activity_type`;
CREATE TABLE `lams_learning_activity_type` (
  `learning_activity_type_id` int(11) NOT NULL default '0',
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`learning_activity_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_learning_activity_type`
--

LOCK TABLES `lams_learning_activity_type` WRITE;
/*!40000 ALTER TABLE `lams_learning_activity_type` DISABLE KEYS */;
INSERT INTO `lams_learning_activity_type` VALUES (1,'TOOL'),(2,'GROUPING'),(3,'GATE_SYNCH'),(4,'GATE_SCHEDULE'),(5,'GATE_PERMISSION'),(6,'PARALLEL'),(7,'OPTIONS'),(8,'SEQUENCE'),(9,'GATE_SYSTEM'),(10,'BRANCHING_CHOSEN'),(11,'BRANCHING_GROUP'),(12,'BRANCHING_TOOL'),(13,'OPTIONS_WITH_SEQUENCES');
/*!40000 ALTER TABLE `lams_learning_activity_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_learning_design`
--

DROP TABLE IF EXISTS `lams_learning_design`;
CREATE TABLE `lams_learning_design` (
  `learning_design_id` bigint(20) NOT NULL auto_increment,
  `learning_design_ui_id` int(11) default NULL,
  `description` text,
  `title` varchar(255) default NULL,
  `first_activity_id` bigint(20) default NULL,
  `max_id` int(11) default NULL,
  `valid_design_flag` tinyint(4) NOT NULL,
  `read_only_flag` tinyint(4) NOT NULL,
  `date_read_only` datetime default NULL,
  `user_id` bigint(20) NOT NULL,
  `help_text` text,
  `online_instructions` text,
  `offline_instructions` text,
  `copy_type_id` tinyint(4) NOT NULL,
  `create_date_time` datetime NOT NULL,
  `version` varchar(56) default NULL,
  `original_learning_design_id` bigint(20) default NULL,
  `workspace_folder_id` bigint(20) default NULL,
  `duration` bigint(38) default NULL,
  `license_id` bigint(20) default NULL,
  `license_text` text,
  `last_modified_date_time` datetime default NULL,
  `content_folder_id` varchar(32) default NULL,
  `edit_override_lock` tinyint(4) default '0',
  `edit_override_user_id` bigint(20) default NULL,
  `design_version` int(11) default '1',
  PRIMARY KEY  (`learning_design_id`),
  KEY `user_id` (`user_id`),
  KEY `workspace_folder_id` (`workspace_folder_id`),
  KEY `license_id` (`license_id`),
  KEY `copy_type_id` (`copy_type_id`),
  KEY `edit_override_user_id` (`edit_override_user_id`),
  KEY `idx_design_parent_id` (`original_learning_design_id`),
  KEY `idx_design_first_act` (`first_activity_id`),
  CONSTRAINT `FK_lams_learning_design_3` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`),
  CONSTRAINT `FK_lams_learning_design_4` FOREIGN KEY (`workspace_folder_id`) REFERENCES `lams_workspace_folder` (`workspace_folder_id`),
  CONSTRAINT `FK_lams_learning_design_5` FOREIGN KEY (`license_id`) REFERENCES `lams_license` (`license_id`),
  CONSTRAINT `FK_lams_learning_design_6` FOREIGN KEY (`copy_type_id`) REFERENCES `lams_copy_type` (`copy_type_id`),
  CONSTRAINT `FK_lams_learning_design_7` FOREIGN KEY (`edit_override_user_id`) REFERENCES `lams_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_learning_design`
--

LOCK TABLES `lams_learning_design` WRITE;
/*!40000 ALTER TABLE `lams_learning_design` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_learning_design` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_learning_library`
--

DROP TABLE IF EXISTS `lams_learning_library`;
CREATE TABLE `lams_learning_library` (
  `learning_library_id` bigint(20) NOT NULL auto_increment,
  `description` text,
  `title` varchar(255) default NULL,
  `valid_flag` tinyint(1) NOT NULL default '1',
  `create_date_time` datetime NOT NULL,
  PRIMARY KEY  (`learning_library_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_learning_library`
--

LOCK TABLES `lams_learning_library` WRITE;
/*!40000 ALTER TABLE `lams_learning_library` DISABLE KEYS */;
INSERT INTO `lams_learning_library` VALUES (1,'Forum, also known Message Board','Forum',1,'2008-07-07 10:47:32'),(2,'Displays a Noticeboard','Noticeboard',1,'2008-07-07 10:47:38'),(3,'Question and Answer Learning Library Description','Question and Answer',1,'2008-07-07 10:47:42'),(4,'Uploading of files by learners, for review by teachers.','Submit file',1,'2008-07-07 10:47:48'),(5,'Chat Tool','Chat',1,'2008-07-07 10:47:55'),(6,'Share resources','Share resources',1,'2008-07-07 10:48:04'),(7,'Voting Learning Library Description','Voting',1,'2008-07-07 10:48:09'),(8,'Notebook Tool','Notebook',1,'2008-07-07 10:48:15'),(9,'Survey','Survey',1,'2008-07-07 10:48:22'),(10,'Scribe Tool','Scribe',0,'2008-07-07 10:48:28'),(11,'Share taskList','Share taskList',1,'2008-07-07 10:48:36'),(12,'MCQ Learning Library Description','MCQ',1,'2008-07-07 10:48:40'),(13,'Shared Resources and Forum','Resources and Forum',1,'2008-07-07 10:48:41'),(14,'Chat and Scribe','Chat and Scribe',1,'2008-07-07 10:48:42'),(15,'Forum and Scribe','Forum and Scribe',1,'2008-07-07 10:48:43');
/*!40000 ALTER TABLE `lams_learning_library` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_learning_transition`
--

DROP TABLE IF EXISTS `lams_learning_transition`;
CREATE TABLE `lams_learning_transition` (
  `transition_id` bigint(20) NOT NULL auto_increment,
  `transition_ui_id` int(11) default NULL,
  `description` text,
  `title` varchar(255) default NULL,
  `to_activity_id` bigint(20) NOT NULL,
  `from_activity_id` bigint(20) NOT NULL,
  `learning_design_id` bigint(20) NOT NULL default '0',
  `create_date_time` datetime NOT NULL,
  `to_ui_id` int(11) default NULL,
  `from_ui_id` int(11) default NULL,
  PRIMARY KEY  (`transition_id`),
  UNIQUE KEY `UQ_transition_activities` (`from_activity_id`,`to_activity_id`),
  KEY `from_activity_id` (`from_activity_id`),
  KEY `to_activity_id` (`to_activity_id`),
  KEY `learning_design_id` (`learning_design_id`),
  CONSTRAINT `FK_learning_transition_3` FOREIGN KEY (`from_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_learning_transition_2` FOREIGN KEY (`to_activity_id`) REFERENCES `lams_learning_activity` (`activity_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `lddefn_transition_ibfk_1` FOREIGN KEY (`learning_design_id`) REFERENCES `lams_learning_design` (`learning_design_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_learning_transition`
--

LOCK TABLES `lams_learning_transition` WRITE;
/*!40000 ALTER TABLE `lams_learning_transition` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_learning_transition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_lesson`
--

DROP TABLE IF EXISTS `lams_lesson`;
CREATE TABLE `lams_lesson` (
  `lesson_id` bigint(20) NOT NULL auto_increment,
  `learning_design_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `create_date_time` datetime NOT NULL,
  `organisation_id` bigint(20) default NULL,
  `class_grouping_id` bigint(20) default NULL,
  `lesson_state_id` int(3) NOT NULL,
  `start_date_time` datetime default NULL,
  `schedule_start_date_time` datetime default NULL,
  `end_date_time` datetime default NULL,
  `schedule_end_date_time` datetime default NULL,
  `previous_state_id` int(3) default NULL,
  `learner_exportport_avail` tinyint(1) default '1',
  `locked_for_edit` tinyint(4) default '0',
  `version` int(11) default '1',
  PRIMARY KEY  (`lesson_id`),
  KEY `learning_design_id` (`learning_design_id`),
  KEY `user_id` (`user_id`),
  KEY `organisation_id` (`organisation_id`),
  KEY `lesson_state_id` (`lesson_state_id`),
  KEY `class_grouping_id` (`class_grouping_id`),
  CONSTRAINT `FK_lams_lesson_1_1` FOREIGN KEY (`learning_design_id`) REFERENCES `lams_learning_design` (`learning_design_id`),
  CONSTRAINT `FK_lams_lesson_2` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`),
  CONSTRAINT `FK_lams_lesson_3` FOREIGN KEY (`organisation_id`) REFERENCES `lams_organisation` (`organisation_id`),
  CONSTRAINT `FK_lams_lesson_4` FOREIGN KEY (`lesson_state_id`) REFERENCES `lams_lesson_state` (`lesson_state_id`),
  CONSTRAINT `FK_lams_lesson_5` FOREIGN KEY (`class_grouping_id`) REFERENCES `lams_grouping` (`grouping_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_lesson`
--

LOCK TABLES `lams_lesson` WRITE;
/*!40000 ALTER TABLE `lams_lesson` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_lesson` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_lesson_learner`
--

DROP TABLE IF EXISTS `lams_lesson_learner`;
CREATE TABLE `lams_lesson_learner` (
  `lesson_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  KEY `lesson_id` (`lesson_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `FK_lams_lesson_learner_1` FOREIGN KEY (`lesson_id`) REFERENCES `lams_lesson` (`lesson_id`),
  CONSTRAINT `FK_lams_lesson_learner_2` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_lesson_learner`
--

LOCK TABLES `lams_lesson_learner` WRITE;
/*!40000 ALTER TABLE `lams_lesson_learner` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_lesson_learner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_lesson_state`
--

DROP TABLE IF EXISTS `lams_lesson_state`;
CREATE TABLE `lams_lesson_state` (
  `lesson_state_id` int(3) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`lesson_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_lesson_state`
--

LOCK TABLES `lams_lesson_state` WRITE;
/*!40000 ALTER TABLE `lams_lesson_state` DISABLE KEYS */;
INSERT INTO `lams_lesson_state` VALUES (1,'CREATED'),(2,'NOT_STARTED'),(3,'STARTED'),(4,'SUSPENDED'),(5,'FINISHED'),(6,'ARCHIVED'),(7,'REMOVED');
/*!40000 ALTER TABLE `lams_lesson_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_license`
--

DROP TABLE IF EXISTS `lams_license`;
CREATE TABLE `lams_license` (
  `license_id` bigint(20) NOT NULL,
  `name` varchar(200) NOT NULL,
  `code` varchar(20) NOT NULL,
  `url` varchar(256) default NULL,
  `default_flag` tinyint(1) NOT NULL default '0',
  `picture_url` varchar(256) default NULL,
  PRIMARY KEY  (`license_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_license`
--

LOCK TABLES `lams_license` WRITE;
/*!40000 ALTER TABLE `lams_license` DISABLE KEYS */;
INSERT INTO `lams_license` VALUES (1,'LAMS Recommended: CC Attribution-Noncommercial-ShareAlike 2.5','by-nc-sa','http://creativecommons.org/licenses/by-nc-sa/2.5/',1,'/images/license/byncsa.jpg'),(2,'CC Attribution-No Derivatives 2.5','by-nd','http://creativecommons.org/licenses/by-nd/2.5/',0,'/images/license/bynd.jpg'),(3,'CC Attribution-Noncommercial-No Derivatives 2.5','by-nc-nd','http://creativecommons.org/licenses/by-nc-nd/2.5/',0,'/images/license/byncnd.jpg'),(4,'CC Attribution-Noncommercial 2.5','by-nc','http://creativecommons.org/licenses/by-nc/2.5/',0,'/images/license/bync.jpg'),(5,'CC Attribution-ShareAlike 2.5','by-sa','http://creativecommons.org/licenses/by-sa/2.5/',0,'/images/license/byncsa.jpg'),(6,'Other Licensing Agreement','other','',0,'');
/*!40000 ALTER TABLE `lams_license` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_log_event`
--

DROP TABLE IF EXISTS `lams_log_event`;
CREATE TABLE `lams_log_event` (
  `log_event_id` bigint(20) NOT NULL auto_increment,
  `log_event_type_id` int(5) NOT NULL,
  `user_id` bigint(20) default NULL,
  `timestamp` datetime NOT NULL,
  `ref_id` bigint(20) default NULL,
  `message` varchar(255) default NULL,
  PRIMARY KEY  (`log_event_id`),
  KEY `log_event_type_id` (`log_event_type_id`),
  CONSTRAINT `FK_lams_event_log_1` FOREIGN KEY (`log_event_type_id`) REFERENCES `lams_log_event_type` (`log_event_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_log_event`
--

LOCK TABLES `lams_log_event` WRITE;
/*!40000 ALTER TABLE `lams_log_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_log_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_log_event_type`
--

DROP TABLE IF EXISTS `lams_log_event_type`;
CREATE TABLE `lams_log_event_type` (
  `log_event_type_id` int(5) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`log_event_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_log_event_type`
--

LOCK TABLES `lams_log_event_type` WRITE;
/*!40000 ALTER TABLE `lams_log_event_type` DISABLE KEYS */;
INSERT INTO `lams_log_event_type` VALUES (1,'LEARNER_LESSON_START'),(2,'LEARNER_LESSON_FINISH'),(3,'LEARNER_LESSON_EXIT'),(4,'LEARNER_LESSON_RESUME'),(5,'LEARNER_ACTIVITY_START'),(6,'LEARNER_ACTIVITY_FINISH');
/*!40000 ALTER TABLE `lams_log_event_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_notebook_entry`
--

DROP TABLE IF EXISTS `lams_notebook_entry`;
CREATE TABLE `lams_notebook_entry` (
  `uid` bigint(20) NOT NULL auto_increment,
  `external_id` bigint(20) default NULL,
  `external_id_type` int(11) default NULL,
  `external_signature` varchar(255) default NULL,
  `user_id` int(11) default NULL,
  `title` varchar(255) default NULL,
  `entry` text,
  `create_date` datetime default NULL,
  `last_modified` datetime default NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_notebook_entry`
--

LOCK TABLES `lams_notebook_entry` WRITE;
/*!40000 ALTER TABLE `lams_notebook_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_notebook_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_organisation`
--

DROP TABLE IF EXISTS `lams_organisation`;
CREATE TABLE `lams_organisation` (
  `organisation_id` bigint(20) NOT NULL auto_increment,
  `name` varchar(250) NOT NULL,
  `code` varchar(20) default NULL,
  `description` varchar(250) default NULL,
  `parent_organisation_id` bigint(20) default NULL,
  `organisation_type_id` int(3) NOT NULL default '0',
  `create_date` datetime NOT NULL,
  `created_by` bigint(20) NOT NULL,
  `workspace_id` bigint(20) default NULL,
  `organisation_state_id` int(3) NOT NULL,
  `admin_add_new_users` tinyint(1) NOT NULL default '0',
  `admin_browse_all_users` tinyint(1) NOT NULL default '0',
  `admin_change_status` tinyint(1) NOT NULL default '0',
  `admin_create_guest` tinyint(1) NOT NULL default '0',
  `locale_id` int(11) default NULL,
  `archived_date` datetime default NULL,
  `ordered_lesson_ids` text,
  PRIMARY KEY  (`organisation_id`),
  KEY `organisation_type_id` (`organisation_type_id`),
  KEY `workspace_id` (`workspace_id`),
  KEY `parent_organisation_id` (`parent_organisation_id`),
  KEY `organisation_state_id` (`organisation_state_id`),
  KEY `locale_id` (`locale_id`),
  CONSTRAINT `FK_lams_organisation_1` FOREIGN KEY (`organisation_type_id`) REFERENCES `lams_organisation_type` (`organisation_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_organisation_2` FOREIGN KEY (`workspace_id`) REFERENCES `lams_workspace` (`workspace_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_organisation_3` FOREIGN KEY (`parent_organisation_id`) REFERENCES `lams_organisation` (`organisation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_organisation_4` FOREIGN KEY (`organisation_state_id`) REFERENCES `lams_organisation_state` (`organisation_state_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_organisation_5` FOREIGN KEY (`locale_id`) REFERENCES `lams_supported_locale` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_organisation`
--

LOCK TABLES `lams_organisation` WRITE;
/*!40000 ALTER TABLE `lams_organisation` DISABLE KEYS */;
INSERT INTO `lams_organisation` VALUES (1,'Root',NULL,'Root Organisation',NULL,1,'2008-07-07 10:45:58',1,1,1,0,0,0,0,1,NULL,NULL),(2,'Playpen','PP101','Developers Playpen',1,2,'2008-07-07 10:45:58',1,2,1,0,0,0,0,1,NULL,NULL),(3,'Everybody',NULL,'All People In Course',2,3,'2008-07-07 10:45:58',1,NULL,1,0,0,0,0,1,NULL,NULL),(4,'Mathematics 1','MATH111','Mathematics 1',1,2,'2008-07-07 10:45:58',1,3,1,0,0,0,0,2,NULL,NULL),(5,'Tutorial Group A','TUTA','Tutorial Group A',4,3,'2008-07-07 10:45:58',1,NULL,1,0,0,0,0,2,NULL,NULL),(6,'Tutorial Group B','TUTB','Tutorial Group B',4,3,'2008-07-07 10:45:58',1,NULL,1,0,0,0,0,2,NULL,NULL),(7,'Moodle','Moodle','Moodle Test',1,2,'2008-07-07 10:45:58',1,50,2,0,0,0,0,1,NULL,NULL);
/*!40000 ALTER TABLE `lams_organisation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_organisation_state`
--

DROP TABLE IF EXISTS `lams_organisation_state`;
CREATE TABLE `lams_organisation_state` (
  `organisation_state_id` int(3) NOT NULL,
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`organisation_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_organisation_state`
--

LOCK TABLES `lams_organisation_state` WRITE;
/*!40000 ALTER TABLE `lams_organisation_state` DISABLE KEYS */;
INSERT INTO `lams_organisation_state` VALUES (1,'ACTIVE'),(2,'HIDDEN'),(3,'ARCHIVED'),(4,'REMOVED');
/*!40000 ALTER TABLE `lams_organisation_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_organisation_type`
--

DROP TABLE IF EXISTS `lams_organisation_type`;
CREATE TABLE `lams_organisation_type` (
  `organisation_type_id` int(3) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`organisation_type_id`),
  UNIQUE KEY `UQ_lams_organisation_type_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_organisation_type`
--

LOCK TABLES `lams_organisation_type` WRITE;
/*!40000 ALTER TABLE `lams_organisation_type` DISABLE KEYS */;
INSERT INTO `lams_organisation_type` VALUES (1,'ROOT ORGANISATION','root all other organisations: controlled by Sysadmin'),(2,'COURSE ORGANISATION','main organisation level - equivalent to an entire course.'),(3,'CLASS','runtime organisation level - lessons are run for classes.');
/*!40000 ALTER TABLE `lams_organisation_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_password_request`
--

DROP TABLE IF EXISTS `lams_password_request`;
CREATE TABLE `lams_password_request` (
  `request_id` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) NOT NULL,
  `request_key` varchar(32) NOT NULL,
  `request_date` datetime NOT NULL,
  PRIMARY KEY  (`request_id`),
  UNIQUE KEY `IX_lams_psswd_rqst_key` (`request_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_password_request`
--

LOCK TABLES `lams_password_request` WRITE;
/*!40000 ALTER TABLE `lams_password_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_password_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_privilege`
--

DROP TABLE IF EXISTS `lams_privilege`;
CREATE TABLE `lams_privilege` (
  `privilege_id` bigint(20) NOT NULL auto_increment,
  `code` varchar(10) NOT NULL,
  `description` varchar(255) default NULL,
  PRIMARY KEY  (`privilege_id`),
  UNIQUE KEY `IX_lams_privilege_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_privilege`
--

LOCK TABLES `lams_privilege` WRITE;
/*!40000 ALTER TABLE `lams_privilege` DISABLE KEYS */;
INSERT INTO `lams_privilege` VALUES (1,'Z','do anything'),(2,'A','add/remove/modify classes within the course'),(3,'B','create running instances of sequences and assign those to a class'),(4,'C','stop/start running sequences'),(5,'D','monitor the progress of learners'),(6,'E','participates in sequences'),(7,'F','export their progress on each running sequence'),(8,'G','write/create/delete permissions in course content folder'),(9,'H','read course content folder'),(10,'I','create new users'),(11,'J','create guest users'),(12,'K','change status of course'),(13,'L','browse all users in the system'),(14,'M','write/create/delete permissions in all course content folders');
/*!40000 ALTER TABLE `lams_privilege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_progress_attempted`
--

DROP TABLE IF EXISTS `lams_progress_attempted`;
CREATE TABLE `lams_progress_attempted` (
  `learner_progress_id` bigint(20) NOT NULL,
  `activity_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`learner_progress_id`,`activity_id`),
  KEY `learner_progress_id` (`learner_progress_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `FK_lams_progress_current_1` FOREIGN KEY (`learner_progress_id`) REFERENCES `lams_learner_progress` (`learner_progress_id`),
  CONSTRAINT `FK_lams_progress_current_2` FOREIGN KEY (`activity_id`) REFERENCES `lams_learning_activity` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_progress_attempted`
--

LOCK TABLES `lams_progress_attempted` WRITE;
/*!40000 ALTER TABLE `lams_progress_attempted` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_progress_attempted` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_progress_completed`
--

DROP TABLE IF EXISTS `lams_progress_completed`;
CREATE TABLE `lams_progress_completed` (
  `learner_progress_id` bigint(20) NOT NULL,
  `activity_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`learner_progress_id`,`activity_id`),
  KEY `learner_progress_id` (`learner_progress_id`),
  KEY `activity_id` (`activity_id`),
  CONSTRAINT `FK_lams_progress_completed_1` FOREIGN KEY (`learner_progress_id`) REFERENCES `lams_learner_progress` (`learner_progress_id`),
  CONSTRAINT `FK_lams_progress_completed_2` FOREIGN KEY (`activity_id`) REFERENCES `lams_learning_activity` (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_progress_completed`
--

LOCK TABLES `lams_progress_completed` WRITE;
/*!40000 ALTER TABLE `lams_progress_completed` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_progress_completed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_BLOB_TRIGGERS`
--

DROP TABLE IF EXISTS `lams_qtz_BLOB_TRIGGERS`;
CREATE TABLE `lams_qtz_BLOB_TRIGGERS` (
  `TRIGGER_NAME` varchar(80) NOT NULL,
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  `BLOB_DATA` blob,
  PRIMARY KEY  (`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `lams_qtz_BLOB_TRIGGERS_ibfk_1` FOREIGN KEY (`TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `lams_qtz_TRIGGERS` (`TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_BLOB_TRIGGERS`
--

LOCK TABLES `lams_qtz_BLOB_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_BLOB_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_BLOB_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_CALENDARS`
--

DROP TABLE IF EXISTS `lams_qtz_CALENDARS`;
CREATE TABLE `lams_qtz_CALENDARS` (
  `CALENDAR_NAME` varchar(80) NOT NULL,
  `CALENDAR` blob NOT NULL,
  PRIMARY KEY  (`CALENDAR_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_CALENDARS`
--

LOCK TABLES `lams_qtz_CALENDARS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_CALENDARS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_CALENDARS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_CRON_TRIGGERS`
--

DROP TABLE IF EXISTS `lams_qtz_CRON_TRIGGERS`;
CREATE TABLE `lams_qtz_CRON_TRIGGERS` (
  `TRIGGER_NAME` varchar(80) NOT NULL,
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  `CRON_EXPRESSION` varchar(80) NOT NULL,
  `TIME_ZONE_ID` varchar(80) default NULL,
  PRIMARY KEY  (`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `lams_qtz_CRON_TRIGGERS_ibfk_1` FOREIGN KEY (`TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `lams_qtz_TRIGGERS` (`TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_CRON_TRIGGERS`
--

LOCK TABLES `lams_qtz_CRON_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_CRON_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_CRON_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_FIRED_TRIGGERS`
--

DROP TABLE IF EXISTS `lams_qtz_FIRED_TRIGGERS`;
CREATE TABLE `lams_qtz_FIRED_TRIGGERS` (
  `ENTRY_ID` varchar(95) NOT NULL,
  `TRIGGER_NAME` varchar(80) NOT NULL,
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  `IS_VOLATILE` varchar(1) NOT NULL,
  `INSTANCE_NAME` varchar(80) NOT NULL,
  `FIRED_TIME` bigint(13) NOT NULL,
  `STATE` varchar(16) NOT NULL,
  `JOB_NAME` varchar(80) default NULL,
  `JOB_GROUP` varchar(80) default NULL,
  `IS_STATEFUL` varchar(1) default NULL,
  `REQUESTS_RECOVERY` varchar(1) default NULL,
  PRIMARY KEY  (`ENTRY_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_FIRED_TRIGGERS`
--

LOCK TABLES `lams_qtz_FIRED_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_FIRED_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_FIRED_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_JOB_DETAILS`
--

DROP TABLE IF EXISTS `lams_qtz_JOB_DETAILS`;
CREATE TABLE `lams_qtz_JOB_DETAILS` (
  `JOB_NAME` varchar(80) NOT NULL,
  `JOB_GROUP` varchar(80) NOT NULL,
  `DESCRIPTION` varchar(120) default NULL,
  `JOB_CLASS_NAME` varchar(128) NOT NULL,
  `IS_DURABLE` varchar(1) NOT NULL,
  `IS_VOLATILE` varchar(1) NOT NULL,
  `IS_STATEFUL` varchar(1) NOT NULL,
  `REQUESTS_RECOVERY` varchar(1) NOT NULL,
  `JOB_DATA` blob,
  PRIMARY KEY  (`JOB_NAME`,`JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_JOB_DETAILS`
--

LOCK TABLES `lams_qtz_JOB_DETAILS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_JOB_DETAILS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_JOB_DETAILS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_JOB_LISTENERS`
--

DROP TABLE IF EXISTS `lams_qtz_JOB_LISTENERS`;
CREATE TABLE `lams_qtz_JOB_LISTENERS` (
  `JOB_NAME` varchar(80) NOT NULL,
  `JOB_GROUP` varchar(80) NOT NULL,
  `JOB_LISTENER` varchar(80) NOT NULL,
  PRIMARY KEY  (`JOB_NAME`,`JOB_GROUP`,`JOB_LISTENER`),
  CONSTRAINT `lams_qtz_JOB_LISTENERS_ibfk_1` FOREIGN KEY (`JOB_NAME`, `JOB_GROUP`) REFERENCES `lams_qtz_JOB_DETAILS` (`JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_JOB_LISTENERS`
--

LOCK TABLES `lams_qtz_JOB_LISTENERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_JOB_LISTENERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_JOB_LISTENERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_LOCKS`
--

DROP TABLE IF EXISTS `lams_qtz_LOCKS`;
CREATE TABLE `lams_qtz_LOCKS` (
  `LOCK_NAME` varchar(40) NOT NULL,
  PRIMARY KEY  (`LOCK_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_LOCKS`
--

LOCK TABLES `lams_qtz_LOCKS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_LOCKS` DISABLE KEYS */;
INSERT INTO `lams_qtz_LOCKS` VALUES ('CALENDAR_ACCESS'),('JOB_ACCESS'),('MISFIRE_ACCESS'),('STATE_ACCESS'),('TRIGGER_ACCESS');
/*!40000 ALTER TABLE `lams_qtz_LOCKS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_PAUSED_TRIGGER_GRPS`
--

DROP TABLE IF EXISTS `lams_qtz_PAUSED_TRIGGER_GRPS`;
CREATE TABLE `lams_qtz_PAUSED_TRIGGER_GRPS` (
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  PRIMARY KEY  (`TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_PAUSED_TRIGGER_GRPS`
--

LOCK TABLES `lams_qtz_PAUSED_TRIGGER_GRPS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_PAUSED_TRIGGER_GRPS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_PAUSED_TRIGGER_GRPS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_SCHEDULER_STATE`
--

DROP TABLE IF EXISTS `lams_qtz_SCHEDULER_STATE`;
CREATE TABLE `lams_qtz_SCHEDULER_STATE` (
  `INSTANCE_NAME` varchar(80) NOT NULL,
  `LAST_CHECKIN_TIME` bigint(13) NOT NULL,
  `CHECKIN_INTERVAL` bigint(13) NOT NULL,
  `RECOVERER` varchar(80) default NULL,
  PRIMARY KEY  (`INSTANCE_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_SCHEDULER_STATE`
--

LOCK TABLES `lams_qtz_SCHEDULER_STATE` WRITE;
/*!40000 ALTER TABLE `lams_qtz_SCHEDULER_STATE` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_SCHEDULER_STATE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_SIMPLE_TRIGGERS`
--

DROP TABLE IF EXISTS `lams_qtz_SIMPLE_TRIGGERS`;
CREATE TABLE `lams_qtz_SIMPLE_TRIGGERS` (
  `TRIGGER_NAME` varchar(80) NOT NULL,
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  `REPEAT_COUNT` bigint(7) NOT NULL,
  `REPEAT_INTERVAL` bigint(12) NOT NULL,
  `TIMES_TRIGGERED` bigint(7) NOT NULL,
  PRIMARY KEY  (`TRIGGER_NAME`,`TRIGGER_GROUP`),
  CONSTRAINT `lams_qtz_SIMPLE_TRIGGERS_ibfk_1` FOREIGN KEY (`TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `lams_qtz_TRIGGERS` (`TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_SIMPLE_TRIGGERS`
--

LOCK TABLES `lams_qtz_SIMPLE_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_SIMPLE_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_SIMPLE_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_TRIGGERS`
--

DROP TABLE IF EXISTS `lams_qtz_TRIGGERS`;
CREATE TABLE `lams_qtz_TRIGGERS` (
  `TRIGGER_NAME` varchar(80) NOT NULL,
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  `JOB_NAME` varchar(80) NOT NULL,
  `JOB_GROUP` varchar(80) NOT NULL,
  `IS_VOLATILE` varchar(1) NOT NULL,
  `DESCRIPTION` varchar(120) default NULL,
  `NEXT_FIRE_TIME` bigint(13) default NULL,
  `PREV_FIRE_TIME` bigint(13) default NULL,
  `TRIGGER_STATE` varchar(16) NOT NULL,
  `TRIGGER_TYPE` varchar(8) NOT NULL,
  `START_TIME` bigint(13) NOT NULL,
  `END_TIME` bigint(13) default NULL,
  `CALENDAR_NAME` varchar(80) default NULL,
  `MISFIRE_INSTR` smallint(2) default NULL,
  `JOB_DATA` blob,
  PRIMARY KEY  (`TRIGGER_NAME`,`TRIGGER_GROUP`),
  KEY `JOB_NAME` (`JOB_NAME`,`JOB_GROUP`),
  CONSTRAINT `lams_qtz_TRIGGERS_ibfk_1` FOREIGN KEY (`JOB_NAME`, `JOB_GROUP`) REFERENCES `lams_qtz_JOB_DETAILS` (`JOB_NAME`, `JOB_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_TRIGGERS`
--

LOCK TABLES `lams_qtz_TRIGGERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_TRIGGERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_TRIGGERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_qtz_TRIGGER_LISTENERS`
--

DROP TABLE IF EXISTS `lams_qtz_TRIGGER_LISTENERS`;
CREATE TABLE `lams_qtz_TRIGGER_LISTENERS` (
  `TRIGGER_NAME` varchar(80) NOT NULL,
  `TRIGGER_GROUP` varchar(80) NOT NULL,
  `TRIGGER_LISTENER` varchar(80) NOT NULL,
  PRIMARY KEY  (`TRIGGER_NAME`,`TRIGGER_GROUP`,`TRIGGER_LISTENER`),
  CONSTRAINT `lams_qtz_TRIGGER_LISTENERS_ibfk_1` FOREIGN KEY (`TRIGGER_NAME`, `TRIGGER_GROUP`) REFERENCES `lams_qtz_TRIGGERS` (`TRIGGER_NAME`, `TRIGGER_GROUP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_qtz_TRIGGER_LISTENERS`
--

LOCK TABLES `lams_qtz_TRIGGER_LISTENERS` WRITE;
/*!40000 ALTER TABLE `lams_qtz_TRIGGER_LISTENERS` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_qtz_TRIGGER_LISTENERS` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_role`
--

DROP TABLE IF EXISTS `lams_role`;
CREATE TABLE `lams_role` (
  `role_id` int(6) NOT NULL default '0',
  `name` varchar(64) NOT NULL,
  `description` text,
  `create_date` datetime NOT NULL,
  PRIMARY KEY  (`role_id`),
  KEY `gname` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_role`
--

LOCK TABLES `lams_role` WRITE;
/*!40000 ALTER TABLE `lams_role` DISABLE KEYS */;
INSERT INTO `lams_role` VALUES (1,'SYSADMIN','LAMS System Adminstrator','2008-07-07 10:45:58'),(2,'GROUP MANAGER','Group Manager','2008-07-07 10:45:58'),(3,'AUTHOR','Authors Learning Designs','2008-07-07 10:45:58'),(4,'MONITOR','Member of Staff','2008-07-07 10:45:58'),(5,'LEARNER','Student','2008-07-07 10:45:58'),(6,'GROUP ADMIN','Group Administrator','2008-07-07 10:45:58'),(7,'AUTHOR ADMIN','Author Administrator','2008-07-07 10:45:58');
/*!40000 ALTER TABLE `lams_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_role_privilege`
--

DROP TABLE IF EXISTS `lams_role_privilege`;
CREATE TABLE `lams_role_privilege` (
  `rp_id` bigint(20) NOT NULL auto_increment,
  `role_id` int(6) NOT NULL,
  `privilege_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`rp_id`),
  KEY `privilege_id` (`privilege_id`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `FK_lams_role_privilege_1` FOREIGN KEY (`privilege_id`) REFERENCES `lams_privilege` (`privilege_id`),
  CONSTRAINT `FK_lams_role_privilege_2` FOREIGN KEY (`role_id`) REFERENCES `lams_role` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_role_privilege`
--

LOCK TABLES `lams_role_privilege` WRITE;
/*!40000 ALTER TABLE `lams_role_privilege` DISABLE KEYS */;
INSERT INTO `lams_role_privilege` VALUES (1,1,1),(2,2,2),(3,2,3),(4,2,4),(5,2,5),(6,2,8),(7,2,9),(8,2,10),(9,2,12),(10,2,13),(11,3,8),(12,3,9),(13,4,3),(14,4,4),(15,4,5),(16,5,6),(17,5,7),(18,6,2),(19,6,10),(20,6,12),(21,6,13),(22,7,14);
/*!40000 ALTER TABLE `lams_role_privilege` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_supported_locale`
--

DROP TABLE IF EXISTS `lams_supported_locale`;
CREATE TABLE `lams_supported_locale` (
  `locale_id` int(11) NOT NULL auto_increment,
  `language_iso_code` varchar(2) NOT NULL COMMENT 'ISO 639-1 Language Code (2 letter version) Java only supports 2 letter properly, not the 3 letter codes.',
  `country_iso_code` varchar(2) default NULL COMMENT 'ISO 3166 Country Code. Cannot use in unique key as allows null.',
  `description` varchar(255) NOT NULL,
  `direction` varchar(3) NOT NULL,
  `fckeditor_code` varchar(10) default NULL,
  PRIMARY KEY  (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COMMENT='Describes the valid language/country combinations.';

--
-- Dumping data for table `lams_supported_locale`
--

LOCK TABLES `lams_supported_locale` WRITE;
/*!40000 ALTER TABLE `lams_supported_locale` DISABLE KEYS */;
INSERT INTO `lams_supported_locale` VALUES (1,'en','AU','English (Australia)','LTR','en-au'),(2,'es','ES','Español','LTR','es'),(3,'mi','NZ','Māori','LTR','en-au'),(4,'de','DE','Deutsch','LTR','de'),(5,'zh','CN','简体中文','LTR','zh-cn'),(6,'fr','FR','Français','LTR','fr'),(7,'it','IT','Italiano','LTR','it'),(8,'no','NO','Norsk','LTR','no'),(9,'sv','SE','Svenska','LTR','sv'),(10,'ko','KR','한국어','LTR','ko'),(11,'pl','PL','Polski','LTR','pl'),(12,'pt','BR','Português (Brasil)','LTR','pt-br'),(13,'hu','HU','Magyar','LTR','hu'),(14,'bg','BG','Български','LTR','bg'),(15,'cy','GB','Cymraeg (Cymru)','LTR','en-au'),(16,'th','TH','Thai','LTR','th'),(17,'el','GR','Ελληνικά','LTR','el'),(18,'nl','BE','Nederlands (België)','LTR','nl'),(19,'ar','JO','عربي','RTL','ar'),(20,'da','DK','Dansk','LTR','da'),(21,'ru','RU','Русский','LTR','ru'),(22,'vi','VN','Tiếng Việt','LTR','vi'),(23,'zh','TW','Chinese (Taiwan)','LTR','zh'),(24,'ja','JP','日本語','LTR','ja'),(25,'ms','MY','Malay (Malaysia)','LTR','ms');
/*!40000 ALTER TABLE `lams_supported_locale` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_system_tool`
--

DROP TABLE IF EXISTS `lams_system_tool`;
CREATE TABLE `lams_system_tool` (
  `system_tool_id` bigint(20) NOT NULL auto_increment,
  `learning_activity_type_id` int(11) NOT NULL,
  `tool_display_name` varchar(255) NOT NULL,
  `description` text,
  `learner_url` text,
  `learner_preview_url` text COMMENT 'Learner screen for preview a learning design. ',
  `learner_progress_url` text COMMENT 'Teacher''s view of a learner''s screen.',
  `export_pfolio_learner_url` text,
  `export_pfolio_class_url` text,
  `monitor_url` text,
  `contribute_url` text,
  `help_url` text,
  `create_date_time` datetime NOT NULL,
  `admin_url` text,
  PRIMARY KEY  (`system_tool_id`),
  UNIQUE KEY `UQ_systool_activity_type` (`learning_activity_type_id`),
  KEY `learning_activity_type_id` (`learning_activity_type_id`),
  CONSTRAINT `FK_lams_system_tool` FOREIGN KEY (`learning_activity_type_id`) REFERENCES `lams_learning_activity_type` (`learning_activity_type_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_system_tool`
--

LOCK TABLES `lams_system_tool` WRITE;
/*!40000 ALTER TABLE `lams_system_tool` DISABLE KEYS */;
INSERT INTO `lams_system_tool` VALUES (1,2,'Grouping','All types of grouping including random and chosen.','learning/grouping.do?method=performGrouping','learning/grouping.do?method=performGrouping','learning/grouping.do?method=viewGrouping&mode=teacher','learning/groupingExportPortfolio?mode=learner','learning/groupingExportPortfolio?mode=teacher','monitoring/grouping.do?method=startGrouping','monitoring/grouping.do?method=startGrouping',NULL,'2008-07-07 10:45:58',NULL),(2,3,'Sync Gate','Gate: Synchronise Learners.','learning/gate.do?method=knockGate','learning/gate.do?method=knockGate',NULL,NULL,'monitoring/gateExportPortfolio?mode=teacher','monitoring/gate.do?method=viewGate','monitoring/gate.do?method=viewGate',NULL,'2008-07-07 10:45:58',NULL),(3,4,'Schedule Gate','Gate: Opens/shuts at particular times.','learning/gate.do?method=knockGate','learning/gate.do?method=knockGate',NULL,NULL,'monitoring/gateExportPortfolio?mode=teacher','monitoring/gate.do?method=viewGate','monitoring/gate.do?method=viewGate',NULL,'2008-07-07 10:45:58',NULL),(4,5,'Permission Gate','Gate: Opens under teacher or staff control.','learning/gate.do?method=knockGate','learning/gate.do?method=knockGate',NULL,NULL,'monitoring/gateExportPortfolio?mode=teacher','monitoring/gate.do?method=viewGate','monitoring/gate.do?method=viewGate',NULL,'2008-07-07 10:45:58',NULL),(5,9,'System Gate','Gate: Opens under system control.','learning/gate.do?method=knockGate','learning/gate.do?method=knockGate',NULL,NULL,'monitoring/gateExportPortfolio?mode=teacher','monitoring/gate.do?method=viewGate','monitoring/gate.do?method=viewGate',NULL,'2008-07-07 10:45:58',NULL),(6,10,'Monitor Chosen Branching','Select between multiple sequence activities, with the branch chosen in monitoring.','learning/branching.do?method=performBranching','learning/branching.do?method=performBranching','monitoring/complexProgress.do',NULL,'monitoring/branchingExportPortfolio?mode=teacher','monitoring/chosenBranching.do?method=assignBranch','monitoring/chosenBranching.do?method=assignBranch',NULL,'2008-07-07 10:45:58',NULL),(7,11,'Group Based Branching','Select between multiple sequence activities, with the branch chosen by an existing group.','learning/branching.do?method=performBranching','learning/branching.do?method=performBranching','monitoring/complexProgress.do',NULL,'monitoring/branchingExportPortfolio?mode=teacher','monitoring/groupedBranching.do?method=viewBranching','monitoring/groupedBranching.do?method=assignBranch',NULL,'2008-07-07 10:45:58',NULL),(8,12,'Tool Output Based Branching','Select between multiple sequence activities, with the branch chosen on results of another activity.','learning/branching.do?method=performBranching','learning/branching.do?method=performBranching','monitoring/complexProgress.do',NULL,'monitoring/branchingExportPortfolio?mode=teacher','monitoring/toolBranching.do?method=viewBranching','monitoring/toolBranching.do?method=viewBranching',NULL,'2008-07-07 10:45:58',NULL),(9,8,'Sequence','A sequence of activities','learning/SequenceActivity.do','learning/SequenceActivity.do','monitoring/complexProgress.do',NULL,'monitoring/sequenceExportPortfolio?mode=teacher','monitoring/sequence.do?method=viewSequence','monitoring/sequence.do?method=viewSequence',NULL,'2008-07-07 10:45:58',NULL);
/*!40000 ALTER TABLE `lams_system_tool` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_tool`
--

DROP TABLE IF EXISTS `lams_tool`;
CREATE TABLE `lams_tool` (
  `tool_id` bigint(20) NOT NULL auto_increment,
  `tool_signature` varchar(64) NOT NULL,
  `service_name` varchar(255) NOT NULL,
  `tool_display_name` varchar(255) NOT NULL,
  `description` text,
  `tool_identifier` varchar(64) NOT NULL,
  `tool_version` varchar(10) NOT NULL,
  `learning_library_id` bigint(20) default NULL,
  `default_tool_content_id` bigint(20) default NULL,
  `valid_flag` tinyint(1) NOT NULL default '1',
  `grouping_support_type_id` int(3) NOT NULL,
  `supports_run_offline_flag` tinyint(1) NOT NULL,
  `learner_url` text NOT NULL,
  `learner_preview_url` text COMMENT 'Learner screen for preview a learning design. ',
  `learner_progress_url` text COMMENT 'Teacher''s view of a learner''s screen.',
  `author_url` text NOT NULL,
  `define_later_url` text,
  `export_pfolio_learner_url` text,
  `export_pfolio_class_url` text,
  `monitor_url` text,
  `contribute_url` text,
  `moderation_url` text,
  `help_url` text,
  `create_date_time` datetime NOT NULL,
  `language_file` varchar(255) default NULL,
  `modified_date_time` datetime default NULL,
  `classpath_addition` varchar(255) default NULL,
  `context_file` varchar(255) default NULL,
  `admin_url` text,
  `supports_outputs` tinyint(1) default '0',
  PRIMARY KEY  (`tool_id`),
  UNIQUE KEY `UQ_lams_tool_sig` (`tool_signature`),
  UNIQUE KEY `UQ_lams_tool_class_name` (`service_name`),
  KEY `learning_library_id` (`learning_library_id`),
  KEY `grouping_support_type_id` (`grouping_support_type_id`),
  CONSTRAINT `FK_lams_tool_1` FOREIGN KEY (`learning_library_id`) REFERENCES `lams_learning_library` (`learning_library_id`),
  CONSTRAINT `FK_lams_tool_2` FOREIGN KEY (`grouping_support_type_id`) REFERENCES `lams_grouping_support_type` (`grouping_support_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_tool`
--

LOCK TABLES `lams_tool` WRITE;
/*!40000 ALTER TABLE `lams_tool` DISABLE KEYS */;
INSERT INTO `lams_tool` VALUES (1,'lafrum11','forumService','Forum','Forum / Message Boards','forum','20080220',1,1,1,2,1,'tool/lafrum11/learning/viewForum.do?mode=learner','tool/lafrum11/learning/viewForum.do?mode=author','tool/lafrum11/learning/viewForum.do?mode=teacher','tool/lafrum11/authoring.do','tool/lafrum11/defineLater.do','tool/lafrum11/exportPortfolio?mode=learner','tool/lafrum11/exportPortfolio?mode=teacher','tool/lafrum11/monitoring.do','tool/lafrum11/contribute.do','tool/lafrum11/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/lafrum11','2008-07-07 10:47:32','org.lamsfoundation.lams.tool.forum.ApplicationResources','2008-07-07 10:47:32','lams-tool-lafrum11.jar','/org/lamsfoundation/lams/tool/forum/forumApplicationContext.xml',NULL,1),(2,'lanb11','nbService','NoticeboardX','Displays a NoticeboardX','nb','20080601',2,2,1,2,1,'tool/lanb11/starter/learner.do?mode=learner','tool/lanb11/starter/learner.do?mode=author','tool/lanb11/starter/learner.do?mode=teacher','tool/lanb11/authoring.do','tool/lanb11/authoring.do?defineLater=true','tool/lanb11/portfolioExport?mode=learner','tool/lanb11/portfolioExport?mode=teacher','tool/lanb11/monitoring.do',NULL,NULL,'http://wiki.lamsfoundation.org/display/lamsdocs/lanb11','2008-07-07 10:47:38','org.lamsfoundation.lams.tool.noticeboard.ApplicationResources','2008-07-07 10:47:38','lams-tool-lanb11.jar','/org/lamsfoundation/lams/tool/noticeboard/applicationContext.xml',NULL,0),(3,'laqa11','qaService','Question and Answer','Q/A Tool','qa','20080108',3,3,1,2,1,'tool/laqa11/learningStarter.do?mode=learner','tool/laqa11/learningStarter.do?mode=author','tool/laqa11/learningStarter.do?mode=teacher','tool/laqa11/authoringStarter.do','tool/laqa11/defineLaterStarter.do','tool/laqa11/exportPortfolio?mode=learner','tool/laqa11/exportPortfolio?mode=teacher','tool/laqa11/monitoringStarter.do','tool/laqa11/monitoringStarter.do','tool/laqa11/monitoringStarter.do','http://wiki.lamsfoundation.org/display/lamsdocs/laqa11','2008-07-07 10:47:42','org.lamsfoundation.lams.tool.qa.ApplicationResources','2008-07-07 10:47:42','lams-tool-laqa11.jar','/org/lamsfoundation/lams/tool/qa/qaApplicationContext.xml',NULL,0),(4,'lasbmt11','submitFilesService','Submit File','Submit File Tool Description','submitfile','20080509',4,4,1,2,1,'tool/lasbmt11/learner.do?mode=learner','tool/lasbmt11/learner.do?mode=author','tool/lasbmt11/learner.do?mode=teacher','tool/lasbmt11/authoring.do','tool/lasbmt11/definelater.do?mode=teacher','tool/lasbmt11/exportPortfolio?mode=learner','tool/lasbmt11/exportPortfolio?mode=teacher','tool/lasbmt11/monitoring.do','tool/lasbmt11/contribute.do','tool/lasbmt11/moderation.do','http://wiki.lamsfoundation.org/display/lamsdocs/lasbmt11','2008-07-07 10:47:48','org.lamsfoundation.lams.tool.sbmt.ApplicationResources','2008-07-07 10:47:48','lams-tool-lasbmt11.jar','/org/lamsfoundation/lams/tool/sbmt/submitFilesApplicationContext.xml',NULL,0),(5,'lachat11','chatService','Chat','Chat','chat','20080813',5,5,1,2,1,'tool/lachat11/learning.do?mode=learner','tool/lachat11/learning.do?mode=author','tool/lachat11/learning.do?mode=teacher','tool/lachat11/authoring.do','tool/lachat11/authoring.do?mode=teacher','tool/lachat11/exportPortfolio?mode=learner','tool/lachat11/exportPortfolio?mode=teacher','tool/lachat11/monitoring.do','tool/lachat11/contribute.do','tool/lachat11/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/lachat11','2008-07-07 10:47:55','org.lamsfoundation.lams.tool.chat.ApplicationResources','2008-07-07 10:47:55','lams-tool-lachat11.jar','/org/lamsfoundation/lams/tool/chat/chatApplicationContext.xml',NULL,0),(6,'larsrc11','resourceService','Shared Resources','Shared Resources','sharedresources','20080229',6,6,1,2,1,'tool/larsrc11/learning/start.do?mode=learner','tool/larsrc11/learning/start.do?mode=author','tool/larsrc11/learning/start.do?mode=teacher','tool/larsrc11/authoring/start.do','tool/larsrc11/definelater.do','tool/larsrc11/exportPortfolio?mode=learner','tool/larsrc11/exportPortfolio?mode=teacher','tool/larsrc11/monitoring/summary.do','tool/larsrc11/contribute.do','tool/larsrc11/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/larsrc11','2008-07-07 10:48:04','org.lamsfoundation.lams.tool.rsrc.ApplicationResources','2008-07-07 10:48:04','lams-tool-larsrc11.jar','/org/lamsfoundation/lams/tool/rsrc/rsrcApplicationContext.xml',NULL,0),(7,'lavote11','voteService','Voting','Voting','vote','20080326',7,7,1,2,1,'tool/lavote11/learningStarter.do?mode=learner','tool/lavote11/learningStarter.do?mode=author','tool/lavote11/learningStarter.do?mode=teacher','tool/lavote11/authoringStarter.do','tool/lavote11/defineLaterStarter.do','tool/lavote11/exportPortfolio?mode=learner','tool/lavote11/exportPortfolio?mode=teacher','tool/lavote11/monitoringStarter.do','tool/lavote11/monitoringStarter.do','tool/lavote11/monitoringStarter.do','http://wiki.lamsfoundation.org/display/lamsdocs/lavote11','2008-07-07 10:48:09','org.lamsfoundation.lams.tool.vote.ApplicationResources','2008-07-07 10:48:09','lams-tool-lavote11.jar','/org/lamsfoundation/lams/tool/vote/voteApplicationContext.xml',NULL,1),(8,'lantbk11','notebookService','Notebook','Notebook','notebook','20080229',8,8,1,2,1,'tool/lantbk11/learning.do?mode=learner','tool/lantbk11/learning.do?mode=author','tool/lantbk11/learning.do?mode=teacher','tool/lantbk11/authoring.do','tool/lantbk11/authoring.do?mode=teacher','tool/lantbk11/exportPortfolio?mode=learner','tool/lantbk11/exportPortfolio?mode=teacher','tool/lantbk11/monitoring.do','tool/lantbk11/contribute.do','tool/lantbk11/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/lantbk11','2008-07-07 10:48:15','org.lamsfoundation.lams.tool.notebook.ApplicationResources','2008-07-07 10:48:15','lams-tool-lantbk11.jar','/org/lamsfoundation/lams/tool/notebook/notebookApplicationContext.xml',NULL,0),(9,'lasurv11','lasurvSurveyService','Survey','Survey','survey','20080229',9,9,1,2,1,'tool/lasurv11/learning/start.do?mode=learner','tool/lasurv11/learning/start.do?mode=author','tool/lasurv11/learning/start.do?mode=teacher','tool/lasurv11/authoring/start.do','tool/lasurv11/definelater.do','tool/lasurv11/exportPortfolio?mode=learner','tool/lasurv11/exportPortfolio?mode=teacher','tool/lasurv11/monitoring/summary.do','tool/lasurv11/contribute.do','tool/lasurv11/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/lasurv11','2008-07-07 10:48:22','org.lamsfoundation.lams.tool.survey.ApplicationResources','2008-07-07 10:48:22','lams-tool-lasurv11.jar','/org/lamsfoundation/lams/tool/survey/surveyApplicationContext.xml',NULL,0),(10,'lascrb11','lascrbScribeService','Scribe','Scribe','scribe','20080229',10,10,1,2,1,'tool/lascrb11/learning.do?mode=learner','tool/lascrb11/learning.do?mode=author','tool/lascrb11/learning.do?mode=teacher','tool/lascrb11/authoring.do','tool/lascrb11/authoring.do?mode=teacher','tool/lascrb11/exportPortfolio?mode=learner','tool/lascrb11/exportPortfolio?mode=teacher','tool/lascrb11/monitoring.do','tool/lascrb11/contribute.do','tool/lascrb11/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/lascrb11','2008-07-07 10:48:28','org.lamsfoundation.lams.tool.scribe.ApplicationResources','2008-07-07 10:48:28','lams-tool-lascrb11.jar','/org/lamsfoundation/lams/tool/scribe/scribeApplicationContext.xml',NULL,0),(11,'latask10','lataskTaskListService','Shared TaskList','Shared TaskList','sharedtaskList','20080211',11,11,1,2,1,'tool/latask10/learning/start.do?mode=learner','tool/latask10/learning/start.do?mode=author','tool/latask10/learning/start.do?mode=teacher','tool/latask10/authoring/start.do','tool/latask10/definelater.do','tool/latask10/exportPortfolio?mode=learner','tool/latask10/exportPortfolio?mode=teacher','tool/latask10/monitoring/summary.do','tool/latask10/contribute.do','tool/latask10/moderate.do','http://wiki.lamsfoundation.org/display/lamsdocs/latask10','2008-07-07 10:48:36','org.lamsfoundation.lams.tool.taskList.ApplicationResources','2008-07-07 10:48:36','lams-tool-latask10.jar','/org/lamsfoundation/lams/tool/taskList/taskListApplicationContext.xml',NULL,1),(12,'lamc11','mcService','MCQ','Multiple Choice Questions','mc','20070820',12,12,1,2,1,'tool/lamc11/learningStarter.do?mode=learner','tool/lamc11/learningStarter.do?mode=author','tool/lamc11/learningStarter.do?mode=teacher','tool/lamc11/authoringStarter.do','tool/lamc11/defineLaterStarter.do','tool/lamc11/exportPortfolio?mode=learner','tool/lamc11/exportPortfolio?mode=teacher','tool/lamc11/monitoringStarter.do','tool/lamc11/monitoringStarter.do','tool/lamc11/monitoringStarter.do','http://wiki.lamsfoundation.org/display/lamsdocs/lamc11','2008-07-07 10:48:40','org.lamsfoundation.lams.tool.mc.ApplicationResources','2008-07-07 10:48:40','lams-tool-lamc11.jar','/org/lamsfoundation/lams/tool/mc/mcApplicationContext.xml',NULL,1);
/*!40000 ALTER TABLE `lams_tool` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_tool_content`
--

DROP TABLE IF EXISTS `lams_tool_content`;
CREATE TABLE `lams_tool_content` (
  `tool_content_id` bigint(20) NOT NULL auto_increment,
  `tool_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`tool_content_id`),
  KEY `tool_id` (`tool_id`),
  CONSTRAINT `FK_lams_tool_content_1` FOREIGN KEY (`tool_id`) REFERENCES `lams_tool` (`tool_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_tool_content`
--

LOCK TABLES `lams_tool_content` WRITE;
/*!40000 ALTER TABLE `lams_tool_content` DISABLE KEYS */;
INSERT INTO `lams_tool_content` VALUES (1,1),(2,2),(3,3),(4,4),(5,5),(6,6),(7,7),(8,8),(9,9),(10,10),(11,11),(12,12);
/*!40000 ALTER TABLE `lams_tool_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_tool_import_support`
--

DROP TABLE IF EXISTS `lams_tool_import_support`;
CREATE TABLE `lams_tool_import_support` (
  `id` bigint(20) NOT NULL auto_increment,
  `installed_tool_signature` varchar(15) NOT NULL,
  `supports_tool_signature` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_tool_import_support`
--

LOCK TABLES `lams_tool_import_support` WRITE;
/*!40000 ALTER TABLE `lams_tool_import_support` DISABLE KEYS */;
INSERT INTO `lams_tool_import_support` VALUES (1,'lafrum11','messageboard'),(2,'lamc11','simpleassessment'),(3,'lanb11','noticeboard'),(4,'lanb11','htmlnb'),(5,'laqa11','qa'),(6,'lasbmt11','reportsubmission'),(7,'lachat11','chat'),(8,'larsrc11','urlcontent'),(11,'lavote11','ranking'),(12,'lantbk11','journal'),(13,'lascrb11','groupreporting'),(14,'lasurv11','survey');
/*!40000 ALTER TABLE `lams_tool_import_support` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_tool_session`
--

DROP TABLE IF EXISTS `lams_tool_session`;
CREATE TABLE `lams_tool_session` (
  `tool_session_id` bigint(20) NOT NULL auto_increment,
  `tool_session_name` varchar(255) NOT NULL,
  `tool_session_type_id` int(3) NOT NULL,
  `lesson_id` bigint(20) NOT NULL,
  `activity_id` bigint(20) NOT NULL,
  `tool_session_state_id` int(3) NOT NULL,
  `create_date_time` datetime NOT NULL,
  `group_id` bigint(20) default NULL,
  `user_id` bigint(20) default NULL,
  `unique_key` varchar(128) NOT NULL,
  PRIMARY KEY  (`tool_session_id`),
  UNIQUE KEY `UQ_lams_tool_session_1` (`unique_key`),
  KEY `tool_session_state_id` (`tool_session_state_id`),
  KEY `user_id` (`user_id`),
  KEY `tool_session_type_id` (`tool_session_type_id`),
  KEY `activity_id` (`activity_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `FK_lams_tool_session_4` FOREIGN KEY (`tool_session_state_id`) REFERENCES `lams_tool_session_state` (`tool_session_state_id`),
  CONSTRAINT `FK_lams_tool_session_5` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`),
  CONSTRAINT `FK_lams_tool_session_7` FOREIGN KEY (`tool_session_type_id`) REFERENCES `lams_tool_session_type` (`tool_session_type_id`),
  CONSTRAINT `FK_lams_tool_session_8` FOREIGN KEY (`activity_id`) REFERENCES `lams_learning_activity` (`activity_id`),
  CONSTRAINT `FK_lams_tool_session_1` FOREIGN KEY (`group_id`) REFERENCES `lams_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_tool_session`
--

LOCK TABLES `lams_tool_session` WRITE;
/*!40000 ALTER TABLE `lams_tool_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_tool_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_tool_session_state`
--

DROP TABLE IF EXISTS `lams_tool_session_state`;
CREATE TABLE `lams_tool_session_state` (
  `tool_session_state_id` int(3) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`tool_session_state_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_tool_session_state`
--

LOCK TABLES `lams_tool_session_state` WRITE;
/*!40000 ALTER TABLE `lams_tool_session_state` DISABLE KEYS */;
INSERT INTO `lams_tool_session_state` VALUES (1,'STARTED'),(2,'ENDED');
/*!40000 ALTER TABLE `lams_tool_session_state` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_tool_session_type`
--

DROP TABLE IF EXISTS `lams_tool_session_type`;
CREATE TABLE `lams_tool_session_type` (
  `tool_session_type_id` int(3) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`tool_session_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_tool_session_type`
--

LOCK TABLES `lams_tool_session_type` WRITE;
/*!40000 ALTER TABLE `lams_tool_session_type` DISABLE KEYS */;
INSERT INTO `lams_tool_session_type` VALUES (1,'NON_GROUPED'),(2,'GROUPED');
/*!40000 ALTER TABLE `lams_tool_session_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_user`
--

DROP TABLE IF EXISTS `lams_user`;
CREATE TABLE `lams_user` (
  `user_id` bigint(20) NOT NULL auto_increment,
  `login` varchar(255) NOT NULL,
  `password` varchar(50) NOT NULL,
  `title` varchar(32) default NULL,
  `first_name` varchar(128) default NULL,
  `last_name` varchar(128) default NULL,
  `address_line_1` varchar(64) default NULL,
  `address_line_2` varchar(64) default NULL,
  `address_line_3` varchar(64) default NULL,
  `city` varchar(64) default NULL,
  `state` varchar(64) default NULL,
  `postcode` varchar(10) default NULL,
  `country` varchar(64) default NULL,
  `day_phone` varchar(64) default NULL,
  `evening_phone` varchar(64) default NULL,
  `mobile_phone` varchar(64) default NULL,
  `fax` varchar(64) default NULL,
  `email` varchar(128) default NULL,
  `disabled_flag` tinyint(1) NOT NULL default '0',
  `create_date` datetime NOT NULL,
  `authentication_method_id` bigint(20) NOT NULL default '0',
  `workspace_id` bigint(20) default NULL,
  `flash_theme_id` bigint(20) default NULL,
  `html_theme_id` bigint(20) default NULL,
  `chat_id` varchar(255) default NULL COMMENT 'ID used for Jabber',
  `locale_id` int(11) default NULL,
  `portrait_uuid` bigint(20) default NULL,
  `change_password` tinyint(4) default '0',
  `enable_flash` tinyint(1) default '1',
  PRIMARY KEY  (`user_id`),
  UNIQUE KEY `UQ_lams_user_login` (`login`),
  KEY `authentication_method_id` (`authentication_method_id`),
  KEY `workspace_id` (`workspace_id`),
  KEY `flash_theme_id` (`flash_theme_id`),
  KEY `html_theme_id` (`html_theme_id`),
  KEY `locale_id` (`locale_id`),
  KEY `login` (`login`),
  KEY `email` (`email`),
  CONSTRAINT `FK_lams_user_1` FOREIGN KEY (`authentication_method_id`) REFERENCES `lams_authentication_method` (`authentication_method_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_user_2` FOREIGN KEY (`workspace_id`) REFERENCES `lams_workspace` (`workspace_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_user_4` FOREIGN KEY (`flash_theme_id`) REFERENCES `lams_css_theme_ve` (`theme_ve_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_user_5` FOREIGN KEY (`html_theme_id`) REFERENCES `lams_css_theme_ve` (`theme_ve_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_user_6` FOREIGN KEY (`locale_id`) REFERENCES `lams_supported_locale` (`locale_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_user`
--

LOCK TABLES `lams_user` WRITE;
/*!40000 ALTER TABLE `lams_user` DISABLE KEYS */;
INSERT INTO `lams_user` VALUES (1,'sysadmin','a159b7ae81ba3552af61e9731b20870515944538','The','System','Administrator',NULL,NULL,NULL,'Sydney','NSW',NULL,'Australia',NULL,NULL,NULL,NULL,'sysadmin@x.x',0,'2008-07-07 10:45:58',1,51,1,2,NULL,1,NULL,0,1),(5,'test1','b444ac06613fc8d63795be9ad0beaf55011936ac','Dr','One','Test','1','Test Ave',NULL,'Nowhere','NSW',NULL,'Australia','0211111111','0211111112','0411111111','0211111113','test1@xx.os',0,'2004-12-23 00:00:00',1,5,1,2,NULL,1,NULL,0,1),(6,'test2','109f4b3c50d7b0df729d299bc6f8e9ef9066971f','Dr','Two','Test','2','Test Ave',NULL,'Nowhere','NSW',NULL,'Australia','0211111111','0211111112','0411111111','0211111113','test2@xx.os',0,'2004-12-23 00:00:00',1,6,1,2,NULL,1,NULL,0,1),(7,'test3','3ebfa301dc59196f18593c45e519287a23297589','Dr','Three','Test','3','Test Ave',NULL,'Nowhere','NSW',NULL,'Australia','0211111111','0211111112','0411111111','0211111113','test3@xx.os',0,'2004-12-23 00:00:00',1,7,1,2,NULL,1,NULL,0,1),(8,'test4','1ff2b3704aede04eecb51e50ca698efd50a1379b','Dr','Four','Test','4','Test Ave',NULL,'Nowhere','NSW',NULL,'Australia','0211111111','0211111112','0411111111','0211111113','test4@xx.os',0,'2004-12-23 00:00:00',1,8,1,2,NULL,1,NULL,0,1);
/*!40000 ALTER TABLE `lams_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_user_group`
--

DROP TABLE IF EXISTS `lams_user_group`;
CREATE TABLE `lams_user_group` (
  `user_id` bigint(20) NOT NULL,
  `group_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`user_id`,`group_id`),
  KEY `user_id` (`user_id`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `FK_lams_user_group_1` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`),
  CONSTRAINT `FK_lams_user_group_2` FOREIGN KEY (`group_id`) REFERENCES `lams_group` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_user_group`
--

LOCK TABLES `lams_user_group` WRITE;
/*!40000 ALTER TABLE `lams_user_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_user_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_user_organisation`
--

DROP TABLE IF EXISTS `lams_user_organisation`;
CREATE TABLE `lams_user_organisation` (
  `user_organisation_id` bigint(20) NOT NULL auto_increment,
  `organisation_id` bigint(20) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`user_organisation_id`),
  KEY `organisation_id` (`organisation_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `FK_lams_user_organisation_1` FOREIGN KEY (`organisation_id`) REFERENCES `lams_organisation` (`organisation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_user_organisation_2` FOREIGN KEY (`user_id`) REFERENCES `lams_user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_user_organisation`
--

LOCK TABLES `lams_user_organisation` WRITE;
/*!40000 ALTER TABLE `lams_user_organisation` DISABLE KEYS */;
INSERT INTO `lams_user_organisation` VALUES (1,1,1),(5,2,5),(6,2,6),(7,2,7),(8,2,8),(12,3,5),(13,3,6),(14,3,7),(15,3,8),(19,4,5),(20,4,6),(21,4,7),(22,4,8),(26,5,5),(27,5,6),(28,6,7),(29,6,8);
/*!40000 ALTER TABLE `lams_user_organisation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_user_organisation_collapsed`
--

DROP TABLE IF EXISTS `lams_user_organisation_collapsed`;
CREATE TABLE `lams_user_organisation_collapsed` (
  `user_organisation_id` bigint(20) NOT NULL,
  `collapsed` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`user_organisation_id`),
  CONSTRAINT `FK_lams_user_organisation_collapsed_1` FOREIGN KEY (`user_organisation_id`) REFERENCES `lams_user_organisation` (`user_organisation_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_user_organisation_collapsed`
--

LOCK TABLES `lams_user_organisation_collapsed` WRITE;
/*!40000 ALTER TABLE `lams_user_organisation_collapsed` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_user_organisation_collapsed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_user_organisation_role`
--

DROP TABLE IF EXISTS `lams_user_organisation_role`;
CREATE TABLE `lams_user_organisation_role` (
  `user_organisation_role_id` bigint(20) NOT NULL auto_increment,
  `user_organisation_id` bigint(20) NOT NULL,
  `role_id` int(6) NOT NULL,
  PRIMARY KEY  (`user_organisation_role_id`),
  KEY `role_id` (`role_id`),
  KEY `user_organisation_id` (`user_organisation_id`),
  CONSTRAINT `FK_lams_user_organisation_role_2` FOREIGN KEY (`role_id`) REFERENCES `lams_role` (`role_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_user_organisation_role_3` FOREIGN KEY (`user_organisation_id`) REFERENCES `lams_user_organisation` (`user_organisation_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_user_organisation_role`
--

LOCK TABLES `lams_user_organisation_role` WRITE;
/*!40000 ALTER TABLE `lams_user_organisation_role` DISABLE KEYS */;
INSERT INTO `lams_user_organisation_role` VALUES (1,1,1),(5,5,3),(6,6,3),(7,7,3),(8,8,3),(12,5,4),(13,6,4),(14,7,4),(15,8,4),(19,5,5),(20,6,5),(21,7,5),(22,8,5),(26,12,4),(27,13,4),(28,14,4),(33,12,5),(34,13,5),(35,14,5),(36,15,5),(40,19,3),(41,20,3),(42,21,3),(43,22,3),(47,19,4),(48,20,4),(49,21,4),(50,22,4),(54,19,5),(55,20,5),(56,21,5),(57,22,5),(61,26,4),(62,27,4),(63,28,4),(64,29,4),(68,26,5),(69,27,5),(70,28,5),(71,29,5);
/*!40000 ALTER TABLE `lams_user_organisation_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_wkspc_fld_content_type`
--

DROP TABLE IF EXISTS `lams_wkspc_fld_content_type`;
CREATE TABLE `lams_wkspc_fld_content_type` (
  `content_type_id` int(3) NOT NULL auto_increment,
  `description` varchar(64) NOT NULL,
  PRIMARY KEY  (`content_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_wkspc_fld_content_type`
--

LOCK TABLES `lams_wkspc_fld_content_type` WRITE;
/*!40000 ALTER TABLE `lams_wkspc_fld_content_type` DISABLE KEYS */;
INSERT INTO `lams_wkspc_fld_content_type` VALUES (1,'FILE'),(2,'PACKAGE');
/*!40000 ALTER TABLE `lams_wkspc_fld_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_wkspc_wkspc_folder`
--

DROP TABLE IF EXISTS `lams_wkspc_wkspc_folder`;
CREATE TABLE `lams_wkspc_wkspc_folder` (
  `id` bigint(20) NOT NULL auto_increment,
  `workspace_id` bigint(20) default NULL,
  `workspace_folder_id` bigint(20) default NULL,
  PRIMARY KEY  (`id`),
  KEY `workspace_id` (`workspace_id`),
  KEY `workspace_folder_id` (`workspace_folder_id`),
  CONSTRAINT `FK_lams_ww_folder_1` FOREIGN KEY (`workspace_id`) REFERENCES `lams_workspace` (`workspace_id`),
  CONSTRAINT `FK_lams_ww_folder_2` FOREIGN KEY (`workspace_folder_id`) REFERENCES `lams_workspace_folder` (`workspace_folder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_wkspc_wkspc_folder`
--

LOCK TABLES `lams_wkspc_wkspc_folder` WRITE;
/*!40000 ALTER TABLE `lams_wkspc_wkspc_folder` DISABLE KEYS */;
INSERT INTO `lams_wkspc_wkspc_folder` VALUES (1,1,1),(2,2,2),(3,2,22),(4,3,3),(5,3,23),(7,5,5),(8,6,6),(9,7,7),(10,8,8),(11,50,40),(12,51,45);
/*!40000 ALTER TABLE `lams_wkspc_wkspc_folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_workspace`
--

DROP TABLE IF EXISTS `lams_workspace`;
CREATE TABLE `lams_workspace` (
  `workspace_id` bigint(20) NOT NULL auto_increment,
  `default_fld_id` bigint(20) default NULL,
  `def_run_seq_fld_id` bigint(20) default NULL,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`workspace_id`),
  KEY `def_run_seq_fld_id` (`def_run_seq_fld_id`),
  KEY `default_fld_id` (`default_fld_id`),
  CONSTRAINT `FK_lams_workspace_1` FOREIGN KEY (`def_run_seq_fld_id`) REFERENCES `lams_workspace_folder` (`workspace_folder_id`),
  CONSTRAINT `FK_lams_workspace_2` FOREIGN KEY (`default_fld_id`) REFERENCES `lams_workspace_folder` (`workspace_folder_id`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_workspace`
--

LOCK TABLES `lams_workspace` WRITE;
/*!40000 ALTER TABLE `lams_workspace` DISABLE KEYS */;
INSERT INTO `lams_workspace` VALUES (1,1,NULL,'ROOT'),(2,2,22,'Developers Playpen'),(3,3,23,'MATH111'),(5,5,NULL,'One Test'),(6,6,NULL,'Two Test'),(7,7,NULL,'Three Test'),(8,8,NULL,'Four Test'),(50,40,41,'Moodle Test'),(51,45,NULL,'System Administrator');
/*!40000 ALTER TABLE `lams_workspace` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_workspace_folder`
--

DROP TABLE IF EXISTS `lams_workspace_folder`;
CREATE TABLE `lams_workspace_folder` (
  `workspace_folder_id` bigint(20) NOT NULL auto_increment,
  `parent_folder_id` bigint(20) default NULL,
  `name` varchar(255) NOT NULL,
  `user_id` bigint(20) NOT NULL,
  `create_date_time` datetime NOT NULL,
  `last_modified_date_time` datetime default NULL,
  `lams_workspace_folder_type_id` int(3) NOT NULL,
  PRIMARY KEY  (`workspace_folder_id`),
  KEY `parent_folder_id` (`parent_folder_id`),
  KEY `lams_workspace_folder_type_id` (`lams_workspace_folder_type_id`),
  CONSTRAINT `FK_lams_workspace_folder_2` FOREIGN KEY (`parent_folder_id`) REFERENCES `lams_workspace_folder` (`workspace_folder_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_lams_workspace_folder_4` FOREIGN KEY (`lams_workspace_folder_type_id`) REFERENCES `lams_workspace_folder_type` (`lams_workspace_folder_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_workspace_folder`
--

LOCK TABLES `lams_workspace_folder` WRITE;
/*!40000 ALTER TABLE `lams_workspace_folder` DISABLE KEYS */;
INSERT INTO `lams_workspace_folder` VALUES (1,NULL,'ROOT',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(2,1,'Developers Playpen',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(3,1,'MATH111',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(5,NULL,'One Test',5,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(6,NULL,'Two Test',6,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(7,NULL,'Three Test',7,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(8,NULL,'Four Test',8,'2004-12-23 00:00:00','2004-12-23 00:00:00',1),(22,2,'Lesson Sequence Folder',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',2),(23,3,'Lesson Sequence Folder',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',2),(40,1,'Moodle Test',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',2),(41,40,'Lesson Sequence Folder',1,'2004-12-23 00:00:00','2004-12-23 00:00:00',2),(45,NULL,'System Administrator',1,'2006-11-01 00:00:00','2006-11-01 00:00:00',1);
/*!40000 ALTER TABLE `lams_workspace_folder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_workspace_folder_content`
--

DROP TABLE IF EXISTS `lams_workspace_folder_content`;
CREATE TABLE `lams_workspace_folder_content` (
  `folder_content_id` bigint(20) NOT NULL auto_increment,
  `content_type_id` int(3) NOT NULL,
  `name` varchar(64) NOT NULL,
  `description` varchar(64) NOT NULL,
  `create_date_time` datetime NOT NULL,
  `last_modified_date` datetime NOT NULL,
  `workspace_folder_id` bigint(20) NOT NULL,
  `uuid` bigint(20) default NULL,
  `version_id` bigint(20) default NULL,
  `mime_type` varchar(10) NOT NULL,
  PRIMARY KEY  (`folder_content_id`),
  UNIQUE KEY `unique_content_name` (`name`,`workspace_folder_id`,`mime_type`),
  UNIQUE KEY `unique_node_version` (`workspace_folder_id`,`uuid`,`version_id`),
  KEY `workspace_folder_id` (`workspace_folder_id`),
  KEY `content_type_id` (`content_type_id`),
  CONSTRAINT `FK_lams_workspace_folder_content_1` FOREIGN KEY (`workspace_folder_id`) REFERENCES `lams_workspace_folder` (`workspace_folder_id`),
  CONSTRAINT `FK_lams_workspace_folder_content_2` FOREIGN KEY (`content_type_id`) REFERENCES `lams_wkspc_fld_content_type` (`content_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_workspace_folder_content`
--

LOCK TABLES `lams_workspace_folder_content` WRITE;
/*!40000 ALTER TABLE `lams_workspace_folder_content` DISABLE KEYS */;
/*!40000 ALTER TABLE `lams_workspace_folder_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lams_workspace_folder_type`
--

DROP TABLE IF EXISTS `lams_workspace_folder_type`;
CREATE TABLE `lams_workspace_folder_type` (
  `lams_workspace_folder_type_id` int(3) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY  (`lams_workspace_folder_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lams_workspace_folder_type`
--

LOCK TABLES `lams_workspace_folder_type` WRITE;
/*!40000 ALTER TABLE `lams_workspace_folder_type` DISABLE KEYS */;
INSERT INTO `lams_workspace_folder_type` VALUES (1,'NORMAL'),(2,'RUN SEQUENCES');
/*!40000 ALTER TABLE `lams_workspace_folder_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lachat11_attachment`
--

DROP TABLE IF EXISTS `tl_lachat11_attachment`;
CREATE TABLE `tl_lachat11_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `chat_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK9ED6CB2E1A3926E3` (`chat_uid`),
  CONSTRAINT `FK9ED6CB2E1A3926E3` FOREIGN KEY (`chat_uid`) REFERENCES `tl_lachat11_chat` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lachat11_attachment`
--

LOCK TABLES `tl_lachat11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_lachat11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lachat11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lachat11_chat`
--

DROP TABLE IF EXISTS `tl_lachat11_chat`;
CREATE TABLE `tl_lachat11_chat` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `title` varchar(255) default NULL,
  `instructions` text,
  `run_offline` bit(1) default NULL,
  `lock_on_finished` bit(1) default NULL,
  `reflect_on_activity` bit(1) default NULL,
  `reflect_instructions` text,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` bit(1) default NULL,
  `define_later` bit(1) default NULL,
  `tool_content_id` bigint(20) default NULL,
  `filtering_enabled` bit(1) default NULL,
  `filter_keywords` text,
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lachat11_chat`
--

LOCK TABLES `tl_lachat11_chat` WRITE;
/*!40000 ALTER TABLE `tl_lachat11_chat` DISABLE KEYS */;
INSERT INTO `tl_lachat11_chat` VALUES (1,NULL,NULL,NULL,'Chat','Instructions','\0','\0','\0',NULL,'','','\0','\0',5,'\0',NULL);
/*!40000 ALTER TABLE `tl_lachat11_chat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lachat11_message`
--

DROP TABLE IF EXISTS `tl_lachat11_message`;
CREATE TABLE `tl_lachat11_message` (
  `uid` bigint(20) NOT NULL auto_increment,
  `chat_session_uid` bigint(20) NOT NULL,
  `from_user_uid` bigint(20) default NULL,
  `to_user_uid` bigint(20) default NULL,
  `type` varchar(255) default NULL,
  `body` text,
  `send_date` datetime default NULL,
  `hidden` bit(1) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKCC08C1DC2AF61E05` (`to_user_uid`),
  KEY `FKCC08C1DC9C8469FC` (`chat_session_uid`),
  KEY `FKCC08C1DCCF3BF9B6` (`from_user_uid`),
  CONSTRAINT `FKCC08C1DCCF3BF9B6` FOREIGN KEY (`from_user_uid`) REFERENCES `tl_lachat11_user` (`uid`),
  CONSTRAINT `FKCC08C1DC2AF61E05` FOREIGN KEY (`to_user_uid`) REFERENCES `tl_lachat11_user` (`uid`),
  CONSTRAINT `FKCC08C1DC9C8469FC` FOREIGN KEY (`chat_session_uid`) REFERENCES `tl_lachat11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lachat11_message`
--

LOCK TABLES `tl_lachat11_message` WRITE;
/*!40000 ALTER TABLE `tl_lachat11_message` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lachat11_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lachat11_session`
--

DROP TABLE IF EXISTS `tl_lachat11_session`;
CREATE TABLE `tl_lachat11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `status` int(11) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  `chat_uid` bigint(20) default NULL,
  `jabber_room` varchar(250) default NULL,
  `room_created` bit(1) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK96E446B1A3926E3` (`chat_uid`),
  CONSTRAINT `FK96E446B1A3926E3` FOREIGN KEY (`chat_uid`) REFERENCES `tl_lachat11_chat` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lachat11_session`
--

LOCK TABLES `tl_lachat11_session` WRITE;
/*!40000 ALTER TABLE `tl_lachat11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lachat11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lachat11_user`
--

DROP TABLE IF EXISTS `tl_lachat11_user`;
CREATE TABLE `tl_lachat11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `jabber_id` varchar(255) default NULL,
  `finishedActivity` bit(1) default NULL,
  `jabber_nickname` varchar(255) default NULL,
  `chat_session_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK4EB82169C8469FC` (`chat_session_uid`),
  CONSTRAINT `FK4EB82169C8469FC` FOREIGN KEY (`chat_session_uid`) REFERENCES `tl_lachat11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lachat11_user`
--

LOCK TABLES `tl_lachat11_user` WRITE;
/*!40000 ALTER TABLE `tl_lachat11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lachat11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_attachment`
--

DROP TABLE IF EXISTS `tl_lafrum11_attachment`;
CREATE TABLE `tl_lafrum11_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `forum_uid` bigint(20) default NULL,
  `message_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK389AD9A2FE939F2A` (`message_uid`),
  KEY `FK389AD9A2131CE31E` (`forum_uid`),
  CONSTRAINT `FK389AD9A2131CE31E` FOREIGN KEY (`forum_uid`) REFERENCES `tl_lafrum11_forum` (`uid`),
  CONSTRAINT `FK389AD9A2FE939F2A` FOREIGN KEY (`message_uid`) REFERENCES `tl_lafrum11_message` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_attachment`
--

LOCK TABLES `tl_lafrum11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lafrum11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_forum`
--

DROP TABLE IF EXISTS `tl_lafrum11_forum`;
CREATE TABLE `tl_lafrum11_forum` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `title` varchar(255) default NULL,
  `allow_anonym` smallint(6) default NULL,
  `run_offline` smallint(6) default NULL,
  `lock_on_finished` smallint(6) default NULL,
  `instructions` text,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` smallint(6) default NULL,
  `define_later` smallint(6) default NULL,
  `content_id` bigint(20) default NULL,
  `allow_edit` smallint(6) default NULL,
  `allow_rich_editor` smallint(6) default NULL,
  `allow_new_topic` smallint(6) default NULL,
  `allow_upload` smallint(6) default NULL,
  `maximum_reply` int(11) default NULL,
  `minimum_reply` int(11) default NULL,
  `limited_of_chars` int(11) default NULL,
  `limited_input_flag` smallint(6) default NULL,
  `reflect_instructions` varchar(255) default NULL,
  `reflect_on_activity` smallint(6) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `content_id` (`content_id`),
  KEY `FK87917942E42F4351` (`create_by`),
  CONSTRAINT `FK87917942E42F4351` FOREIGN KEY (`create_by`) REFERENCES `tl_lafrum11_forum_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_forum`
--

LOCK TABLES `tl_lafrum11_forum` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_forum` DISABLE KEYS */;
INSERT INTO `tl_lafrum11_forum` VALUES (1,NULL,NULL,NULL,'Forum',0,0,0,'Instructions',NULL,NULL,0,0,1,1,0,1,0,1,0,5000,1,NULL,0);
/*!40000 ALTER TABLE `tl_lafrum11_forum` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_forum_user`
--

DROP TABLE IF EXISTS `tl_lafrum11_forum_user`;
CREATE TABLE `tl_lafrum11_forum_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `session_id` bigint(20) default NULL,
  `login_name` varchar(255) default NULL,
  `session_finished` smallint(6) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK7B83A4A85F0116B6` (`session_id`),
  CONSTRAINT `FK7B83A4A85F0116B6` FOREIGN KEY (`session_id`) REFERENCES `tl_lafrum11_tool_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_forum_user`
--

LOCK TABLES `tl_lafrum11_forum_user` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_forum_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lafrum11_forum_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_message`
--

DROP TABLE IF EXISTS `tl_lafrum11_message`;
CREATE TABLE `tl_lafrum11_message` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `last_reply_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `modified_by` bigint(20) default NULL,
  `subject` varchar(255) default NULL,
  `body` text,
  `is_authored` smallint(6) default NULL,
  `is_anonymous` smallint(6) default NULL,
  `forum_session_uid` bigint(20) default NULL,
  `parent_uid` bigint(20) default NULL,
  `forum_uid` bigint(20) default NULL,
  `reply_number` int(11) default NULL,
  `hide_flag` smallint(6) default NULL,
  `report_id` bigint(20) default NULL,
  `authored_parent_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK4A6067E8E42F4351` (`create_by`),
  KEY `FK4A6067E897F0DB46` (`report_id`),
  KEY `FK4A6067E8131CE31E` (`forum_uid`),
  KEY `FK4A6067E824089E4D` (`parent_uid`),
  KEY `FK4A6067E89357B45B` (`forum_session_uid`),
  KEY `FK4A6067E8647A7264` (`modified_by`),
  KEY `IX_msg_auth_parent` (`authored_parent_uid`),
  CONSTRAINT `FK4A6067E8131CE31E` FOREIGN KEY (`forum_uid`) REFERENCES `tl_lafrum11_forum` (`uid`),
  CONSTRAINT `FK4A6067E824089E4D` FOREIGN KEY (`parent_uid`) REFERENCES `tl_lafrum11_message` (`uid`),
  CONSTRAINT `FK4A6067E8647A7264` FOREIGN KEY (`modified_by`) REFERENCES `tl_lafrum11_forum_user` (`uid`),
  CONSTRAINT `FK4A6067E89357B45B` FOREIGN KEY (`forum_session_uid`) REFERENCES `tl_lafrum11_tool_session` (`uid`),
  CONSTRAINT `FK4A6067E897F0DB46` FOREIGN KEY (`report_id`) REFERENCES `tl_lafrum11_report` (`uid`),
  CONSTRAINT `FK4A6067E8E42F4351` FOREIGN KEY (`create_by`) REFERENCES `tl_lafrum11_forum_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_message`
--

LOCK TABLES `tl_lafrum11_message` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_message` DISABLE KEYS */;
INSERT INTO `tl_lafrum11_message` VALUES (1,'2008-07-07 10:47:32','2008-07-07 10:47:32','2008-07-07 10:47:32',NULL,NULL,'Topic Heading','Topic message',1,0,NULL,NULL,1,0,0,NULL,NULL);
/*!40000 ALTER TABLE `tl_lafrum11_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_message_seq`
--

DROP TABLE IF EXISTS `tl_lafrum11_message_seq`;
CREATE TABLE `tl_lafrum11_message_seq` (
  `uid` bigint(20) NOT NULL auto_increment,
  `root_message_uid` bigint(20) default NULL,
  `message_uid` bigint(20) default NULL,
  `message_level` smallint(6) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKD2C71F88FE939F2A` (`message_uid`),
  KEY `FKD2C71F8845213B4D` (`root_message_uid`),
  CONSTRAINT `FKD2C71F8845213B4D` FOREIGN KEY (`root_message_uid`) REFERENCES `tl_lafrum11_message` (`uid`),
  CONSTRAINT `FKD2C71F88FE939F2A` FOREIGN KEY (`message_uid`) REFERENCES `tl_lafrum11_message` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_message_seq`
--

LOCK TABLES `tl_lafrum11_message_seq` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_message_seq` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lafrum11_message_seq` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_report`
--

DROP TABLE IF EXISTS `tl_lafrum11_report`;
CREATE TABLE `tl_lafrum11_report` (
  `uid` bigint(20) NOT NULL auto_increment,
  `comment` text,
  `release_date` datetime default NULL,
  `mark` float default NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_report`
--

LOCK TABLES `tl_lafrum11_report` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lafrum11_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lafrum11_tool_session`
--

DROP TABLE IF EXISTS `tl_lafrum11_tool_session`;
CREATE TABLE `tl_lafrum11_tool_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `version` int(11) NOT NULL,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `status` int(11) default NULL,
  `mark_released` smallint(6) default NULL,
  `forum_uid` bigint(20) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK5A04D7AE131CE31E` (`forum_uid`),
  CONSTRAINT `FK5A04D7AE131CE31E` FOREIGN KEY (`forum_uid`) REFERENCES `tl_lafrum11_forum` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lafrum11_tool_session`
--

LOCK TABLES `tl_lafrum11_tool_session` WRITE;
/*!40000 ALTER TABLE `tl_lafrum11_tool_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lafrum11_tool_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_content`
--

DROP TABLE IF EXISTS `tl_lamc11_content`;
CREATE TABLE `tl_lamc11_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `content_id` bigint(20) NOT NULL,
  `title` text,
  `instructions` text,
  `creation_date` datetime default NULL,
  `update_date` datetime default NULL,
  `reflect` tinyint(1) NOT NULL default '0',
  `questions_sequenced` tinyint(1) NOT NULL default '0',
  `created_by` bigint(20) NOT NULL default '0',
  `run_offline` tinyint(1) NOT NULL default '0',
  `define_later` tinyint(1) NOT NULL default '0',
  `offline_instructions` text,
  `online_instructions` text,
  `content_in_use` tinyint(1) NOT NULL default '0',
  `retries` tinyint(1) NOT NULL default '0',
  `pass_mark` int(11) default NULL,
  `show_report` tinyint(1) NOT NULL default '0',
  `reflectionSubject` text,
  `showMarks` tinyint(1) NOT NULL default '0',
  `randomize` tinyint(1) NOT NULL default '0',
  `displayAnswers` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `UQ_tl_lamc11_content_1` (`content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_content`
--

LOCK TABLES `tl_lamc11_content` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_content` DISABLE KEYS */;
INSERT INTO `tl_lamc11_content` VALUES (1,12,'MCQ','Instructions','2008-07-07 10:48:40',NULL,0,0,1,0,0,'','',0,0,0,0,NULL,0,0,1);
/*!40000 ALTER TABLE `tl_lamc11_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_options_content`
--

DROP TABLE IF EXISTS `tl_lamc11_options_content`;
CREATE TABLE `tl_lamc11_options_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `correct_option` tinyint(1) NOT NULL default '0',
  `mc_que_content_id` bigint(20) NOT NULL,
  `mc_que_option_text` varchar(250) default NULL,
  `displayOrder` int(5) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `mc_que_content_id` (`mc_que_content_id`),
  CONSTRAINT `FK_tl_lamc11_options_content_1` FOREIGN KEY (`mc_que_content_id`) REFERENCES `tl_lamc11_que_content` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_options_content`
--

LOCK TABLES `tl_lamc11_options_content` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_options_content` DISABLE KEYS */;
INSERT INTO `tl_lamc11_options_content` VALUES (1,0,1,'Answer 1',1),(2,1,1,'Answer 2',2);
/*!40000 ALTER TABLE `tl_lamc11_options_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_que_content`
--

DROP TABLE IF EXISTS `tl_lamc11_que_content`;
CREATE TABLE `tl_lamc11_que_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `question` text,
  `mark` int(5) NOT NULL default '1',
  `display_order` int(5) default NULL,
  `mc_content_id` bigint(20) NOT NULL,
  `feedback` text,
  PRIMARY KEY  (`uid`),
  KEY `mc_content_id` (`mc_content_id`),
  CONSTRAINT `FK_tl_lamc11_que_content_1` FOREIGN KEY (`mc_content_id`) REFERENCES `tl_lamc11_content` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_que_content`
--

LOCK TABLES `tl_lamc11_que_content` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_que_content` DISABLE KEYS */;
INSERT INTO `tl_lamc11_que_content` VALUES (1,'A Sample question?',1,1,1,NULL);
/*!40000 ALTER TABLE `tl_lamc11_que_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_que_usr`
--

DROP TABLE IF EXISTS `tl_lamc11_que_usr`;
CREATE TABLE `tl_lamc11_que_usr` (
  `uid` bigint(20) NOT NULL auto_increment,
  `que_usr_id` bigint(20) NOT NULL,
  `mc_session_id` bigint(20) NOT NULL,
  `username` varchar(255) default NULL,
  `fullname` varchar(255) default NULL,
  `responseFinalised` tinyint(1) NOT NULL default '0',
  `viewSummaryRequested` tinyint(1) NOT NULL default '0',
  `last_attempt_order` int(11) default NULL,
  `last_attempt_total_mark` int(11) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `mc_session_id` (`mc_session_id`),
  CONSTRAINT `FK_tl_lamc11_que_usr_1` FOREIGN KEY (`mc_session_id`) REFERENCES `tl_lamc11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_que_usr`
--

LOCK TABLES `tl_lamc11_que_usr` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_que_usr` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lamc11_que_usr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_session`
--

DROP TABLE IF EXISTS `tl_lamc11_session`;
CREATE TABLE `tl_lamc11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `mc_session_id` bigint(20) NOT NULL,
  `session_start_date` datetime default NULL,
  `session_end_date` datetime default NULL,
  `session_name` varchar(100) default NULL,
  `session_status` varchar(100) default NULL,
  `mc_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `UQ_tl_lamc11_session_1` (`mc_session_id`),
  KEY `mc_content_id` (`mc_content_id`),
  CONSTRAINT `FK_tl_lamc_session_1` FOREIGN KEY (`mc_content_id`) REFERENCES `tl_lamc11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_session`
--

LOCK TABLES `tl_lamc11_session` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lamc11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_uploadedfile`
--

DROP TABLE IF EXISTS `tl_lamc11_uploadedfile`;
CREATE TABLE `tl_lamc11_uploadedfile` (
  `submissionId` bigint(20) NOT NULL auto_increment,
  `uuid` varchar(255) NOT NULL,
  `mc_content_id` bigint(20) NOT NULL,
  `isOnline_File` tinyint(1) NOT NULL,
  `filename` varchar(255) NOT NULL,
  PRIMARY KEY  (`submissionId`),
  KEY `mc_content_id` (`mc_content_id`),
  CONSTRAINT `FK_tl_lamc11_uploadedFile` FOREIGN KEY (`mc_content_id`) REFERENCES `tl_lamc11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_uploadedfile`
--

LOCK TABLES `tl_lamc11_uploadedfile` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_uploadedfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lamc11_uploadedfile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lamc11_usr_attempt`
--

DROP TABLE IF EXISTS `tl_lamc11_usr_attempt`;
CREATE TABLE `tl_lamc11_usr_attempt` (
  `uid` bigint(20) NOT NULL auto_increment,
  `que_usr_id` bigint(20) NOT NULL,
  `mc_que_content_id` bigint(20) NOT NULL,
  `mc_que_option_id` bigint(20) NOT NULL,
  `attempt_time` datetime default NULL,
  `isAttemptCorrect` tinyint(1) NOT NULL default '0',
  `mark` varchar(255) default NULL,
  `passed` tinyint(1) NOT NULL default '0',
  `attemptOrder` int(11) NOT NULL default '1',
  `finished` tinyint(1) default '0',
  PRIMARY KEY  (`uid`),
  KEY `mc_que_content_id` (`mc_que_content_id`),
  KEY `mc_que_option_id` (`mc_que_option_id`),
  KEY `que_usr_id` (`que_usr_id`),
  CONSTRAINT `FK_tl_lamc11_usr_attempt_2` FOREIGN KEY (`mc_que_content_id`) REFERENCES `tl_lamc11_que_content` (`uid`),
  CONSTRAINT `FK_tl_lamc11_usr_attempt_3` FOREIGN KEY (`mc_que_option_id`) REFERENCES `tl_lamc11_options_content` (`uid`),
  CONSTRAINT `FK_tl_lamc11_usr_attempt_4` FOREIGN KEY (`que_usr_id`) REFERENCES `tl_lamc11_que_usr` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lamc11_usr_attempt`
--

LOCK TABLES `tl_lamc11_usr_attempt` WRITE;
/*!40000 ALTER TABLE `tl_lamc11_usr_attempt` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lamc11_usr_attempt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lanb11_attachment`
--

DROP TABLE IF EXISTS `tl_lanb11_attachment`;
CREATE TABLE `tl_lanb11_attachment` (
  `attachment_id` bigint(20) NOT NULL auto_increment,
  `nb_content_uid` bigint(20) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `uuid` bigint(20) NOT NULL,
  `version_id` bigint(20) default NULL,
  `online_file` tinyint(1) NOT NULL,
  PRIMARY KEY  (`attachment_id`),
  KEY `nb_content_uid` (`nb_content_uid`),
  CONSTRAINT `FK_tl_lanb11_attachment_1` FOREIGN KEY (`nb_content_uid`) REFERENCES `tl_lanb11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lanb11_attachment`
--

LOCK TABLES `tl_lanb11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_lanb11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lanb11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lanb11_content`
--

DROP TABLE IF EXISTS `tl_lanb11_content`;
CREATE TABLE `tl_lanb11_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `nb_content_id` bigint(20) NOT NULL,
  `title` text,
  `content` text,
  `online_instructions` text,
  `offline_instructions` text,
  `define_later` tinyint(1) default NULL,
  `force_offline` tinyint(1) default NULL,
  `reflect_on_activity` tinyint(1) default NULL,
  `reflect_instructions` text,
  `content_in_use` tinyint(1) default NULL,
  `creator_user_id` bigint(20) default NULL,
  `date_created` datetime default NULL,
  `date_updated` datetime default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `nb_content_id` (`nb_content_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lanb11_content`
--

LOCK TABLES `tl_lanb11_content` WRITE;
/*!40000 ALTER TABLE `tl_lanb11_content` DISABLE KEYS */;
INSERT INTO `tl_lanb11_content` VALUES (1,2,'Noticeboard','Content','','',0,0,0,'Reflect on noticeboard',0,NULL,'2008-07-07 10:47:38',NULL);
/*!40000 ALTER TABLE `tl_lanb11_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lanb11_session`
--

DROP TABLE IF EXISTS `tl_lanb11_session`;
CREATE TABLE `tl_lanb11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `nb_session_id` bigint(20) NOT NULL,
  `nb_session_name` varchar(255) NOT NULL,
  `nb_content_uid` bigint(20) NOT NULL,
  `session_start_date` datetime default NULL,
  `session_end_date` datetime default NULL,
  `session_status` varchar(100) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `nb_session_id` (`nb_session_id`),
  KEY `nb_content_uid` (`nb_content_uid`),
  CONSTRAINT `FK_tl_lanb11_session_1` FOREIGN KEY (`nb_content_uid`) REFERENCES `tl_lanb11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lanb11_session`
--

LOCK TABLES `tl_lanb11_session` WRITE;
/*!40000 ALTER TABLE `tl_lanb11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lanb11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lanb11_user`
--

DROP TABLE IF EXISTS `tl_lanb11_user`;
CREATE TABLE `tl_lanb11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) NOT NULL,
  `nb_session_uid` bigint(20) NOT NULL,
  `username` varchar(255) default NULL,
  `fullname` varchar(255) default NULL,
  `user_status` varchar(50) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `nb_session_uid` (`nb_session_uid`),
  CONSTRAINT `FK_tl_lanb11_user_1` FOREIGN KEY (`nb_session_uid`) REFERENCES `tl_lanb11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lanb11_user`
--

LOCK TABLES `tl_lanb11_user` WRITE;
/*!40000 ALTER TABLE `tl_lanb11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lanb11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lantbk11_attachment`
--

DROP TABLE IF EXISTS `tl_lantbk11_attachment`;
CREATE TABLE `tl_lantbk11_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `notebook_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK12090F57FC940906` (`notebook_uid`),
  CONSTRAINT `FK12090F57FC940906` FOREIGN KEY (`notebook_uid`) REFERENCES `tl_lantbk11_notebook` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lantbk11_attachment`
--

LOCK TABLES `tl_lantbk11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_lantbk11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lantbk11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lantbk11_notebook`
--

DROP TABLE IF EXISTS `tl_lantbk11_notebook`;
CREATE TABLE `tl_lantbk11_notebook` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `title` varchar(255) default NULL,
  `instructions` text,
  `run_offline` bit(1) default NULL,
  `lock_on_finished` bit(1) default NULL,
  `allow_rich_editor` bit(1) default NULL,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` bit(1) default NULL,
  `define_later` bit(1) default NULL,
  `tool_content_id` bigint(20) default NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lantbk11_notebook`
--

LOCK TABLES `tl_lantbk11_notebook` WRITE;
/*!40000 ALTER TABLE `tl_lantbk11_notebook` DISABLE KEYS */;
INSERT INTO `tl_lantbk11_notebook` VALUES (1,NULL,NULL,NULL,'Notebook','Instructions','\0','\0','\0','','','\0','\0',8);
/*!40000 ALTER TABLE `tl_lantbk11_notebook` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lantbk11_session`
--

DROP TABLE IF EXISTS `tl_lantbk11_session`;
CREATE TABLE `tl_lantbk11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `status` int(11) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  `notebook_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKB7C198E2FC940906` (`notebook_uid`),
  CONSTRAINT `FKB7C198E2FC940906` FOREIGN KEY (`notebook_uid`) REFERENCES `tl_lantbk11_notebook` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lantbk11_session`
--

LOCK TABLES `tl_lantbk11_session` WRITE;
/*!40000 ALTER TABLE `tl_lantbk11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lantbk11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lantbk11_user`
--

DROP TABLE IF EXISTS `tl_lantbk11_user`;
CREATE TABLE `tl_lantbk11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `finishedActivity` bit(1) default NULL,
  `notebook_session_uid` bigint(20) default NULL,
  `entry_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKCB8A58FFA3B0FADF` (`notebook_session_uid`),
  CONSTRAINT `FKCB8A58FFA3B0FADF` FOREIGN KEY (`notebook_session_uid`) REFERENCES `tl_lantbk11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lantbk11_user`
--

LOCK TABLES `tl_lantbk11_user` WRITE;
/*!40000 ALTER TABLE `tl_lantbk11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lantbk11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_laqa11_content`
--

DROP TABLE IF EXISTS `tl_laqa11_content`;
CREATE TABLE `tl_laqa11_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `qa_content_id` bigint(20) NOT NULL,
  `title` text,
  `instructions` text,
  `creation_date` datetime default NULL,
  `update_date` datetime default NULL,
  `reflect` tinyint(1) NOT NULL default '0',
  `questions_sequenced` tinyint(1) NOT NULL default '0',
  `username_visible` tinyint(1) NOT NULL default '0',
  `created_by` bigint(20) NOT NULL default '0',
  `run_offline` tinyint(1) default '0',
  `define_later` tinyint(1) NOT NULL default '0',
  `synch_in_monitor` tinyint(1) NOT NULL default '0',
  `offline_instructions` text,
  `online_instructions` text,
  `content_inUse` tinyint(1) default '0',
  `reflectionSubject` text,
  `lockWhenFinished` tinyint(1) NOT NULL default '1',
  `showOtherAnswers` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_laqa11_content`
--

LOCK TABLES `tl_laqa11_content` WRITE;
/*!40000 ALTER TABLE `tl_laqa11_content` DISABLE KEYS */;
INSERT INTO `tl_laqa11_content` VALUES (1,3,'Q&A','Instructions','2008-07-07 10:47:42',NULL,0,0,0,0,0,0,0,NULL,NULL,0,NULL,0,1);
/*!40000 ALTER TABLE `tl_laqa11_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_laqa11_que_content`
--

DROP TABLE IF EXISTS `tl_laqa11_que_content`;
CREATE TABLE `tl_laqa11_que_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `question` text,
  `feedback` text,
  `display_order` int(5) default '1',
  `qa_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `qa_content_id` (`qa_content_id`),
  CONSTRAINT `FK_tl_laqa11_que_content_1` FOREIGN KEY (`qa_content_id`) REFERENCES `tl_laqa11_content` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_laqa11_que_content`
--

LOCK TABLES `tl_laqa11_que_content` WRITE;
/*!40000 ALTER TABLE `tl_laqa11_que_content` DISABLE KEYS */;
INSERT INTO `tl_laqa11_que_content` VALUES (1,'Sample Question 1?',NULL,1,1);
/*!40000 ALTER TABLE `tl_laqa11_que_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_laqa11_que_usr`
--

DROP TABLE IF EXISTS `tl_laqa11_que_usr`;
CREATE TABLE `tl_laqa11_que_usr` (
  `uid` bigint(20) NOT NULL auto_increment,
  `que_usr_id` bigint(20) NOT NULL,
  `username` varchar(255) default NULL,
  `responseFinalized` tinyint(1) NOT NULL default '0',
  `qa_session_id` bigint(20) NOT NULL,
  `fullname` varchar(255) default NULL,
  `learnerFinished` tinyint(1) NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `qa_session_id` (`qa_session_id`),
  CONSTRAINT `FK_tl_laqa11_que_usr_1` FOREIGN KEY (`qa_session_id`) REFERENCES `tl_laqa11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_laqa11_que_usr`
--

LOCK TABLES `tl_laqa11_que_usr` WRITE;
/*!40000 ALTER TABLE `tl_laqa11_que_usr` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_laqa11_que_usr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_laqa11_session`
--

DROP TABLE IF EXISTS `tl_laqa11_session`;
CREATE TABLE `tl_laqa11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `qa_session_id` bigint(20) NOT NULL,
  `session_start_date` datetime default NULL,
  `session_end_date` datetime default NULL,
  `session_name` varchar(100) default NULL,
  `session_status` varchar(100) default NULL,
  `qa_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `qa_content_id` (`qa_content_id`),
  CONSTRAINT `FK_tl_laqa11_session_1` FOREIGN KEY (`qa_content_id`) REFERENCES `tl_laqa11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_laqa11_session`
--

LOCK TABLES `tl_laqa11_session` WRITE;
/*!40000 ALTER TABLE `tl_laqa11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_laqa11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_laqa11_uploadedfile`
--

DROP TABLE IF EXISTS `tl_laqa11_uploadedfile`;
CREATE TABLE `tl_laqa11_uploadedfile` (
  `submissionId` bigint(20) NOT NULL auto_increment,
  `uuid` varchar(255) NOT NULL,
  `isOnline_File` tinyint(1) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `qa_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`submissionId`),
  KEY `qa_content_id` (`qa_content_id`),
  CONSTRAINT `FK_tl_laqa11_uploadedfile_1` FOREIGN KEY (`qa_content_id`) REFERENCES `tl_laqa11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_laqa11_uploadedfile`
--

LOCK TABLES `tl_laqa11_uploadedfile` WRITE;
/*!40000 ALTER TABLE `tl_laqa11_uploadedfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_laqa11_uploadedfile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_laqa11_usr_resp`
--

DROP TABLE IF EXISTS `tl_laqa11_usr_resp`;
CREATE TABLE `tl_laqa11_usr_resp` (
  `response_id` bigint(20) NOT NULL auto_increment,
  `hidden` tinyint(1) default '0',
  `answer` text,
  `time_zone` varchar(255) default NULL,
  `attempt_time` datetime default NULL,
  `que_usr_id` bigint(20) NOT NULL,
  `qa_que_content_id` bigint(20) NOT NULL,
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`response_id`),
  KEY `que_usr_id` (`que_usr_id`),
  KEY `qa_que_content_id` (`qa_que_content_id`),
  CONSTRAINT `FK_tl_laqa11_usr_resp_3` FOREIGN KEY (`que_usr_id`) REFERENCES `tl_laqa11_que_usr` (`uid`),
  CONSTRAINT `FK_tl_laqa11_usr_resp_2` FOREIGN KEY (`qa_que_content_id`) REFERENCES `tl_laqa11_que_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_laqa11_usr_resp`
--

LOCK TABLES `tl_laqa11_usr_resp` WRITE;
/*!40000 ALTER TABLE `tl_laqa11_usr_resp` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_laqa11_usr_resp` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_attachment`
--

DROP TABLE IF EXISTS `tl_larsrc11_attachment`;
CREATE TABLE `tl_larsrc11_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `resource_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK1E7009430E79035` (`resource_uid`),
  CONSTRAINT `FK1E7009430E79035` FOREIGN KEY (`resource_uid`) REFERENCES `tl_larsrc11_resource` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_attachment`
--

LOCK TABLES `tl_larsrc11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_larsrc11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_item_instruction`
--

DROP TABLE IF EXISTS `tl_larsrc11_item_instruction`;
CREATE TABLE `tl_larsrc11_item_instruction` (
  `uid` bigint(20) NOT NULL auto_increment,
  `description` varchar(255) default NULL,
  `sequence_id` int(11) default NULL,
  `item_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKA5665013980570ED` (`item_uid`),
  CONSTRAINT `FKA5665013980570ED` FOREIGN KEY (`item_uid`) REFERENCES `tl_larsrc11_resource_item` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_item_instruction`
--

LOCK TABLES `tl_larsrc11_item_instruction` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_item_instruction` DISABLE KEYS */;
INSERT INTO `tl_larsrc11_item_instruction` VALUES (1,'Use Google to search the web',0,1);
/*!40000 ALTER TABLE `tl_larsrc11_item_instruction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_item_log`
--

DROP TABLE IF EXISTS `tl_larsrc11_item_log`;
CREATE TABLE `tl_larsrc11_item_log` (
  `uid` bigint(20) NOT NULL auto_increment,
  `access_date` datetime default NULL,
  `resource_item_uid` bigint(20) default NULL,
  `user_uid` bigint(20) default NULL,
  `complete` tinyint(4) default NULL,
  `session_id` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK693580A438BF8DFE` (`resource_item_uid`),
  KEY `FK693580A441F9365D` (`user_uid`),
  CONSTRAINT `FK693580A441F9365D` FOREIGN KEY (`user_uid`) REFERENCES `tl_larsrc11_user` (`uid`),
  CONSTRAINT `FK693580A438BF8DFE` FOREIGN KEY (`resource_item_uid`) REFERENCES `tl_larsrc11_resource_item` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_item_log`
--

LOCK TABLES `tl_larsrc11_item_log` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_item_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_larsrc11_item_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_resource`
--

DROP TABLE IF EXISTS `tl_larsrc11_resource`;
CREATE TABLE `tl_larsrc11_resource` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `title` varchar(255) default NULL,
  `run_offline` tinyint(4) default NULL,
  `lock_on_finished` tinyint(4) default NULL,
  `instructions` text,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` tinyint(4) default NULL,
  `define_later` tinyint(4) default NULL,
  `content_id` bigint(20) default NULL,
  `allow_add_files` tinyint(4) default NULL,
  `allow_add_urls` tinyint(4) default NULL,
  `mini_view_resource_number` int(11) default NULL,
  `allow_auto_run` tinyint(4) default NULL,
  `reflect_instructions` varchar(255) default NULL,
  `reflect_on_activity` smallint(6) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `content_id` (`content_id`),
  KEY `FK89093BF758092FB` (`create_by`),
  CONSTRAINT `FK89093BF758092FB` FOREIGN KEY (`create_by`) REFERENCES `tl_larsrc11_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_resource`
--

LOCK TABLES `tl_larsrc11_resource` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_resource` DISABLE KEYS */;
INSERT INTO `tl_larsrc11_resource` VALUES (1,NULL,NULL,NULL,'Resources',0,0,'Instructions ',NULL,NULL,0,0,6,0,0,0,0,NULL,0);
/*!40000 ALTER TABLE `tl_larsrc11_resource` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_resource_item`
--

DROP TABLE IF EXISTS `tl_larsrc11_resource_item`;
CREATE TABLE `tl_larsrc11_resource_item` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_uuid` bigint(20) default NULL,
  `file_version_id` bigint(20) default NULL,
  `description` varchar(255) default NULL,
  `ims_schema` varchar(255) default NULL,
  `init_item` varchar(255) default NULL,
  `organization_xml` text,
  `title` varchar(255) default NULL,
  `url` text,
  `create_by` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `create_by_author` tinyint(4) default NULL,
  `is_hide` tinyint(4) default NULL,
  `item_type` smallint(6) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `open_url_new_window` tinyint(4) default NULL,
  `resource_uid` bigint(20) default NULL,
  `session_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKF52D1F93758092FB` (`create_by`),
  KEY `FKF52D1F9330E79035` (`resource_uid`),
  KEY `FKF52D1F93EC0D3147` (`session_uid`),
  CONSTRAINT `FKF52D1F93EC0D3147` FOREIGN KEY (`session_uid`) REFERENCES `tl_larsrc11_session` (`uid`),
  CONSTRAINT `FKF52D1F9330E79035` FOREIGN KEY (`resource_uid`) REFERENCES `tl_larsrc11_resource` (`uid`),
  CONSTRAINT `FKF52D1F93758092FB` FOREIGN KEY (`create_by`) REFERENCES `tl_larsrc11_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_resource_item`
--

LOCK TABLES `tl_larsrc11_resource_item` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_resource_item` DISABLE KEYS */;
INSERT INTO `tl_larsrc11_resource_item` VALUES (1,NULL,NULL,NULL,NULL,NULL,NULL,'Web Search','http://www.google.com ',NULL,'2008-07-07 10:48:04',1,0,1,NULL,NULL,0,1,NULL);
/*!40000 ALTER TABLE `tl_larsrc11_resource_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_session`
--

DROP TABLE IF EXISTS `tl_larsrc11_session`;
CREATE TABLE `tl_larsrc11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `status` int(11) default NULL,
  `resource_uid` bigint(20) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK24AA78C530E79035` (`resource_uid`),
  CONSTRAINT `FK24AA78C530E79035` FOREIGN KEY (`resource_uid`) REFERENCES `tl_larsrc11_resource` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_session`
--

LOCK TABLES `tl_larsrc11_session` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_larsrc11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_larsrc11_user`
--

DROP TABLE IF EXISTS `tl_larsrc11_user`;
CREATE TABLE `tl_larsrc11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `session_finished` smallint(6) default NULL,
  `session_uid` bigint(20) default NULL,
  `resource_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK30113BFCEC0D3147` (`session_uid`),
  KEY `FK30113BFC309ED320` (`resource_uid`),
  CONSTRAINT `FK30113BFC309ED320` FOREIGN KEY (`resource_uid`) REFERENCES `tl_larsrc11_resource` (`uid`),
  CONSTRAINT `FK30113BFCEC0D3147` FOREIGN KEY (`session_uid`) REFERENCES `tl_larsrc11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_larsrc11_user`
--

LOCK TABLES `tl_larsrc11_user` WRITE;
/*!40000 ALTER TABLE `tl_larsrc11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_larsrc11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasbmt11_content`
--

DROP TABLE IF EXISTS `tl_lasbmt11_content`;
CREATE TABLE `tl_lasbmt11_content` (
  `content_id` bigint(20) NOT NULL,
  `title` varchar(64) NOT NULL,
  `instruction` text,
  `define_later` smallint(6) NOT NULL,
  `run_offline` smallint(6) NOT NULL,
  `offline_instruction` text,
  `online_instruction` text,
  `content_in_use` smallint(6) default NULL,
  `lock_on_finished` smallint(6) default NULL,
  `reflect_instructions` varchar(255) default NULL,
  `reflect_on_activity` smallint(6) default NULL,
  `limit_upload` smallint(6) default NULL,
  `limit_upload_number` int(11) default NULL,
  `created` datetime default NULL,
  `created_by` bigint(20) default NULL,
  `updated` datetime default NULL,
  PRIMARY KEY  (`content_id`),
  KEY `FKAEF329AC172BC670` (`created_by`),
  CONSTRAINT `FKAEF329AC172BC670` FOREIGN KEY (`created_by`) REFERENCES `tl_lasbmt11_user` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasbmt11_content`
--

LOCK TABLES `tl_lasbmt11_content` WRITE;
/*!40000 ALTER TABLE `tl_lasbmt11_content` DISABLE KEYS */;
INSERT INTO `tl_lasbmt11_content` VALUES (4,'Submit Files','Instructions',0,0,NULL,NULL,0,0,NULL,0,0,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tl_lasbmt11_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasbmt11_instruction_files`
--

DROP TABLE IF EXISTS `tl_lasbmt11_instruction_files`;
CREATE TABLE `tl_lasbmt11_instruction_files` (
  `uid` bigint(20) NOT NULL auto_increment,
  `uuid` bigint(20) default NULL,
  `version_id` bigint(20) default NULL,
  `type` varchar(20) default NULL,
  `name` varchar(255) default NULL,
  `content_id` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKA75538F9785A173A` (`content_id`),
  CONSTRAINT `FKA75538F9785A173A` FOREIGN KEY (`content_id`) REFERENCES `tl_lasbmt11_content` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasbmt11_instruction_files`
--

LOCK TABLES `tl_lasbmt11_instruction_files` WRITE;
/*!40000 ALTER TABLE `tl_lasbmt11_instruction_files` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasbmt11_instruction_files` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasbmt11_report`
--

DROP TABLE IF EXISTS `tl_lasbmt11_report`;
CREATE TABLE `tl_lasbmt11_report` (
  `report_id` bigint(20) NOT NULL auto_increment,
  `comments` varchar(250) default NULL,
  `marks` float default NULL,
  `date_marks_released` datetime default NULL,
  PRIMARY KEY  (`report_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasbmt11_report`
--

LOCK TABLES `tl_lasbmt11_report` WRITE;
/*!40000 ALTER TABLE `tl_lasbmt11_report` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasbmt11_report` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasbmt11_session`
--

DROP TABLE IF EXISTS `tl_lasbmt11_session`;
CREATE TABLE `tl_lasbmt11_session` (
  `session_id` bigint(20) NOT NULL,
  `status` int(11) NOT NULL,
  `content_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  PRIMARY KEY  (`session_id`),
  KEY `FKEC8C77C9785A173A` (`content_id`),
  CONSTRAINT `FKEC8C77C9785A173A` FOREIGN KEY (`content_id`) REFERENCES `tl_lasbmt11_content` (`content_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasbmt11_session`
--

LOCK TABLES `tl_lasbmt11_session` WRITE;
/*!40000 ALTER TABLE `tl_lasbmt11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasbmt11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasbmt11_submission_details`
--

DROP TABLE IF EXISTS `tl_lasbmt11_submission_details`;
CREATE TABLE `tl_lasbmt11_submission_details` (
  `submission_id` bigint(20) NOT NULL auto_increment,
  `filePath` varchar(250) default NULL,
  `fileDescription` varchar(250) default NULL,
  `date_of_submission` datetime default NULL,
  `uuid` bigint(20) default NULL,
  `version_id` bigint(20) default NULL,
  `session_id` bigint(20) default NULL,
  `learner_id` bigint(20) default NULL,
  PRIMARY KEY  (`submission_id`),
  KEY `FK1411A53CFFD5A38B` (`learner_id`),
  KEY `FK1411A53C93C861A` (`session_id`),
  CONSTRAINT `FK1411A53C93C861A` FOREIGN KEY (`session_id`) REFERENCES `tl_lasbmt11_session` (`session_id`),
  CONSTRAINT `FK1411A53CFFD5A38B` FOREIGN KEY (`learner_id`) REFERENCES `tl_lasbmt11_user` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasbmt11_submission_details`
--

LOCK TABLES `tl_lasbmt11_submission_details` WRITE;
/*!40000 ALTER TABLE `tl_lasbmt11_submission_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasbmt11_submission_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasbmt11_user`
--

DROP TABLE IF EXISTS `tl_lasbmt11_user`;
CREATE TABLE `tl_lasbmt11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` int(11) default NULL,
  `finished` bit(1) default NULL,
  `session_id` bigint(20) default NULL,
  `first_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `last_name` varchar(255) default NULL,
  `content_id` bigint(20) default NULL,
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasbmt11_user`
--

LOCK TABLES `tl_lasbmt11_user` WRITE;
/*!40000 ALTER TABLE `tl_lasbmt11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasbmt11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lascrb11_attachment`
--

DROP TABLE IF EXISTS `tl_lascrb11_attachment`;
CREATE TABLE `tl_lascrb11_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `scribe_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK57953706B3FA1495` (`scribe_uid`),
  CONSTRAINT `FK57953706B3FA1495` FOREIGN KEY (`scribe_uid`) REFERENCES `tl_lascrb11_scribe` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lascrb11_attachment`
--

LOCK TABLES `tl_lascrb11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_lascrb11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lascrb11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lascrb11_heading`
--

DROP TABLE IF EXISTS `tl_lascrb11_heading`;
CREATE TABLE `tl_lascrb11_heading` (
  `uid` bigint(20) NOT NULL auto_increment,
  `heading` text,
  `scribe_uid` bigint(20) default NULL,
  `display_order` int(11) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK428A22FFB3FA1495` (`scribe_uid`),
  CONSTRAINT `FK428A22FFB3FA1495` FOREIGN KEY (`scribe_uid`) REFERENCES `tl_lascrb11_scribe` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lascrb11_heading`
--

LOCK TABLES `tl_lascrb11_heading` WRITE;
/*!40000 ALTER TABLE `tl_lascrb11_heading` DISABLE KEYS */;
INSERT INTO `tl_lascrb11_heading` VALUES (1,'Scribe Heading',1,0);
/*!40000 ALTER TABLE `tl_lascrb11_heading` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lascrb11_report_entry`
--

DROP TABLE IF EXISTS `tl_lascrb11_report_entry`;
CREATE TABLE `tl_lascrb11_report_entry` (
  `uid` bigint(20) NOT NULL auto_increment,
  `entry_text` text,
  `scribe_heading_uid` bigint(20) default NULL,
  `scribe_session_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK5439FACAEA50D086` (`scribe_heading_uid`),
  KEY `FK5439FACA1C266FAE` (`scribe_session_uid`),
  CONSTRAINT `FK5439FACA1C266FAE` FOREIGN KEY (`scribe_session_uid`) REFERENCES `tl_lascrb11_session` (`uid`),
  CONSTRAINT `FK5439FACAEA50D086` FOREIGN KEY (`scribe_heading_uid`) REFERENCES `tl_lascrb11_heading` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lascrb11_report_entry`
--

LOCK TABLES `tl_lascrb11_report_entry` WRITE;
/*!40000 ALTER TABLE `tl_lascrb11_report_entry` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lascrb11_report_entry` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lascrb11_scribe`
--

DROP TABLE IF EXISTS `tl_lascrb11_scribe`;
CREATE TABLE `tl_lascrb11_scribe` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `title` varchar(255) default NULL,
  `instructions` text,
  `run_offline` bit(1) default NULL,
  `lock_on_finished` bit(1) default NULL,
  `auto_select_scribe` bit(1) default NULL,
  `reflect_on_activity` bit(1) default NULL,
  `reflect_instructions` text,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` bit(1) default NULL,
  `define_later` bit(1) default NULL,
  `tool_content_id` bigint(20) default NULL,
  `aggregated_reports` bit(1) default '\0',
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lascrb11_scribe`
--

LOCK TABLES `tl_lascrb11_scribe` WRITE;
/*!40000 ALTER TABLE `tl_lascrb11_scribe` DISABLE KEYS */;
INSERT INTO `tl_lascrb11_scribe` VALUES (1,NULL,NULL,NULL,'Scribe','Instructions','\0','','','\0',NULL,'','','\0','\0',10,'\0');
/*!40000 ALTER TABLE `tl_lascrb11_scribe` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lascrb11_session`
--

DROP TABLE IF EXISTS `tl_lascrb11_session`;
CREATE TABLE `tl_lascrb11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `version` int(11) NOT NULL,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `status` int(11) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  `scribe_uid` bigint(20) default NULL,
  `appointed_scribe_uid` bigint(20) default NULL,
  `force_complete` bit(1) default NULL,
  `report_submitted` bit(1) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK89732793B3FA1495` (`scribe_uid`),
  KEY `FK89732793E46919FF` (`appointed_scribe_uid`),
  CONSTRAINT `FK89732793E46919FF` FOREIGN KEY (`appointed_scribe_uid`) REFERENCES `tl_lascrb11_user` (`uid`),
  CONSTRAINT `FK89732793B3FA1495` FOREIGN KEY (`scribe_uid`) REFERENCES `tl_lascrb11_scribe` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lascrb11_session`
--

LOCK TABLES `tl_lascrb11_session` WRITE;
/*!40000 ALTER TABLE `tl_lascrb11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lascrb11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lascrb11_user`
--

DROP TABLE IF EXISTS `tl_lascrb11_user`;
CREATE TABLE `tl_lascrb11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `finishedActivity` bit(1) default NULL,
  `scribe_session_uid` bigint(20) default NULL,
  `report_approved` bit(1) default NULL,
  `started_activity` bit(1) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK187DAFEE1C266FAE` (`scribe_session_uid`),
  CONSTRAINT `FK187DAFEE1C266FAE` FOREIGN KEY (`scribe_session_uid`) REFERENCES `tl_lascrb11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lascrb11_user`
--

LOCK TABLES `tl_lascrb11_user` WRITE;
/*!40000 ALTER TABLE `tl_lascrb11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lascrb11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_answer`
--

DROP TABLE IF EXISTS `tl_lasurv11_answer`;
CREATE TABLE `tl_lasurv11_answer` (
  `uid` bigint(20) NOT NULL auto_increment,
  `question_uid` bigint(20) default NULL,
  `user_uid` bigint(20) default NULL,
  `answer_choices` varchar(255) default NULL,
  `udpate_date` datetime default NULL,
  `answer_text` text,
  PRIMARY KEY  (`uid`),
  KEY `FK6DAAFE3BB1423DC1` (`user_uid`),
  KEY `FK6DAAFE3B25F3BB77` (`question_uid`),
  CONSTRAINT `FK6DAAFE3B25F3BB77` FOREIGN KEY (`question_uid`) REFERENCES `tl_lasurv11_question` (`uid`),
  CONSTRAINT `FK6DAAFE3BB1423DC1` FOREIGN KEY (`user_uid`) REFERENCES `tl_lasurv11_user` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_answer`
--

LOCK TABLES `tl_lasurv11_answer` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasurv11_answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_attachment`
--

DROP TABLE IF EXISTS `tl_lasurv11_attachment`;
CREATE TABLE `tl_lasurv11_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `survey_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKD92A9120D14146E5` (`survey_uid`),
  CONSTRAINT `FKD92A9120D14146E5` FOREIGN KEY (`survey_uid`) REFERENCES `tl_lasurv11_survey` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_attachment`
--

LOCK TABLES `tl_lasurv11_attachment` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasurv11_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_option`
--

DROP TABLE IF EXISTS `tl_lasurv11_option`;
CREATE TABLE `tl_lasurv11_option` (
  `uid` bigint(20) NOT NULL auto_increment,
  `description` text,
  `sequence_id` int(11) default NULL,
  `question_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK85AB46F26966134F` (`question_uid`),
  CONSTRAINT `FK85AB46F26966134F` FOREIGN KEY (`question_uid`) REFERENCES `tl_lasurv11_question` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_option`
--

LOCK TABLES `tl_lasurv11_option` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_option` DISABLE KEYS */;
INSERT INTO `tl_lasurv11_option` VALUES (1,'Option 1',0,1),(2,'Option 2',1,1),(3,'Option 3',2,1),(4,'Option 1',0,2),(5,'Option 2',1,2),(6,'Option 3',2,2);
/*!40000 ALTER TABLE `tl_lasurv11_option` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_question`
--

DROP TABLE IF EXISTS `tl_lasurv11_question`;
CREATE TABLE `tl_lasurv11_question` (
  `uid` bigint(20) NOT NULL auto_increment,
  `sequence_id` int(11) default NULL,
  `description` text,
  `create_by` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `question_type` smallint(6) default NULL,
  `append_text` smallint(6) default NULL,
  `optional` smallint(6) default NULL,
  `allow_multiple_answer` smallint(6) default NULL,
  `survey_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK872D4F23D14146E5` (`survey_uid`),
  KEY `FK872D4F23E4C99A5F` (`create_by`),
  CONSTRAINT `FK872D4F23E4C99A5F` FOREIGN KEY (`create_by`) REFERENCES `tl_lasurv11_user` (`uid`),
  CONSTRAINT `FK872D4F23D14146E5` FOREIGN KEY (`survey_uid`) REFERENCES `tl_lasurv11_survey` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_question`
--

LOCK TABLES `tl_lasurv11_question` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_question` DISABLE KEYS */;
INSERT INTO `tl_lasurv11_question` VALUES (1,1,'Sample Multiple choice - only one response allowed?',NULL,'2008-07-07 10:48:22',1,0,0,0,1),(2,2,'Sample Multiple choice - multiple response allowed?',NULL,'2008-07-07 10:48:22',2,0,0,1,1),(3,3,'Sample Free text question?',NULL,'2008-07-07 10:48:22',3,0,0,0,1);
/*!40000 ALTER TABLE `tl_lasurv11_question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_session`
--

DROP TABLE IF EXISTS `tl_lasurv11_session`;
CREATE TABLE `tl_lasurv11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `survey_uid` bigint(20) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FKF08793B9D14146E5` (`survey_uid`),
  CONSTRAINT `FKF08793B9D14146E5` FOREIGN KEY (`survey_uid`) REFERENCES `tl_lasurv11_survey` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_session`
--

LOCK TABLES `tl_lasurv11_session` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasurv11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_survey`
--

DROP TABLE IF EXISTS `tl_lasurv11_survey`;
CREATE TABLE `tl_lasurv11_survey` (
  `uid` bigint(20) NOT NULL auto_increment,
  `title` varchar(255) default NULL,
  `run_offline` smallint(6) default NULL,
  `lock_on_finished` smallint(6) default NULL,
  `instructions` text,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` smallint(6) default NULL,
  `define_later` smallint(6) default NULL,
  `content_id` bigint(20) default NULL,
  `reflect_instructions` varchar(255) default NULL,
  `reflect_on_activity` smallint(6) default NULL,
  `show_questions_on_one_page` smallint(6) default NULL,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `content_id` (`content_id`),
  KEY `FK8CC465D7E4C99A5F` (`create_by`),
  CONSTRAINT `FK8CC465D7E4C99A5F` FOREIGN KEY (`create_by`) REFERENCES `tl_lasurv11_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_survey`
--

LOCK TABLES `tl_lasurv11_survey` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_survey` DISABLE KEYS */;
INSERT INTO `tl_lasurv11_survey` VALUES (1,'Survey',0,1,'Instructions',NULL,NULL,0,0,9,NULL,0,1,NULL,NULL,NULL);
/*!40000 ALTER TABLE `tl_lasurv11_survey` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lasurv11_user`
--

DROP TABLE IF EXISTS `tl_lasurv11_user`;
CREATE TABLE `tl_lasurv11_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `session_uid` bigint(20) default NULL,
  `survey_uid` bigint(20) default NULL,
  `session_finished` smallint(6) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK633F25884F803F63` (`session_uid`),
  KEY `FK633F2588D14146E5` (`survey_uid`),
  CONSTRAINT `FK633F2588D14146E5` FOREIGN KEY (`survey_uid`) REFERENCES `tl_lasurv11_survey` (`uid`),
  CONSTRAINT `FK633F25884F803F63` FOREIGN KEY (`session_uid`) REFERENCES `tl_lasurv11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lasurv11_user`
--

LOCK TABLES `tl_lasurv11_user` WRITE;
/*!40000 ALTER TABLE `tl_lasurv11_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lasurv11_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_attachment`
--

DROP TABLE IF EXISTS `tl_latask10_attachment`;
CREATE TABLE `tl_latask10_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `taskList_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_NEW_174079138_1E7009430E79035` (`taskList_uid`),
  CONSTRAINT `FK_NEW_174079138_1E7009430E79035` FOREIGN KEY (`taskList_uid`) REFERENCES `tl_latask10_taskList` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_attachment`
--

LOCK TABLES `tl_latask10_attachment` WRITE;
/*!40000 ALTER TABLE `tl_latask10_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_condition`
--

DROP TABLE IF EXISTS `tl_latask10_condition`;
CREATE TABLE `tl_latask10_condition` (
  `condition_uid` bigint(20) NOT NULL auto_increment,
  `sequence_id` int(11) default NULL,
  `taskList_uid` bigint(20) default NULL,
  `name` varchar(255) default NULL,
  PRIMARY KEY  (`condition_uid`),
  KEY `FK_tl_latask10_condition_1` (`taskList_uid`),
  CONSTRAINT `FK_tl_latask10_condition_1` FOREIGN KEY (`taskList_uid`) REFERENCES `tl_latask10_taskList` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_condition`
--

LOCK TABLES `tl_latask10_condition` WRITE;
/*!40000 ALTER TABLE `tl_latask10_condition` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_condition_tl_item`
--

DROP TABLE IF EXISTS `tl_latask10_condition_tl_item`;
CREATE TABLE `tl_latask10_condition_tl_item` (
  `uid` bigint(20) NOT NULL,
  `condition_uid` bigint(20) NOT NULL,
  PRIMARY KEY  (`uid`,`condition_uid`),
  KEY `FK_tl_latask10_taskList_item_condition_1` (`condition_uid`),
  KEY `FK_tl_latask10_taskList_item_condition_2` (`uid`),
  CONSTRAINT `FK_tl_latask10_taskList_item_condition_2` FOREIGN KEY (`uid`) REFERENCES `tl_latask10_taskList_item` (`uid`),
  CONSTRAINT `FK_tl_latask10_taskList_item_condition_1` FOREIGN KEY (`condition_uid`) REFERENCES `tl_latask10_condition` (`condition_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_condition_tl_item`
--

LOCK TABLES `tl_latask10_condition_tl_item` WRITE;
/*!40000 ALTER TABLE `tl_latask10_condition_tl_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_condition_tl_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_item_attachment`
--

DROP TABLE IF EXISTS `tl_latask10_item_attachment`;
CREATE TABLE `tl_latask10_item_attachment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `file_version_id` bigint(20) default NULL,
  `file_type` varchar(255) default NULL,
  `file_name` varchar(255) default NULL,
  `file_uuid` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `taskList_item_uid` bigint(20) default NULL,
  `create_by` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_tl_latask10_item_attachment_1` (`taskList_item_uid`),
  KEY `FK_tl_latask10_item_attachment_2` (`create_by`),
  CONSTRAINT `FK_tl_latask10_item_attachment_2` FOREIGN KEY (`create_by`) REFERENCES `tl_latask10_user` (`uid`),
  CONSTRAINT `FK_tl_latask10_item_attachment_1` FOREIGN KEY (`taskList_item_uid`) REFERENCES `tl_latask10_taskList_item` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_item_attachment`
--

LOCK TABLES `tl_latask10_item_attachment` WRITE;
/*!40000 ALTER TABLE `tl_latask10_item_attachment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_item_attachment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_item_comment`
--

DROP TABLE IF EXISTS `tl_latask10_item_comment`;
CREATE TABLE `tl_latask10_item_comment` (
  `uid` bigint(20) NOT NULL auto_increment,
  `comment` text,
  `taskList_item_uid` bigint(20) default NULL,
  `create_by` bigint(20) default NULL,
  `create_date` datetime default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_tl_latask10_item_comment_3` (`taskList_item_uid`),
  KEY `FK_tl_latask10_item_comment_2` (`create_by`),
  CONSTRAINT `FK_tl_latask10_item_comment_2` FOREIGN KEY (`create_by`) REFERENCES `tl_latask10_user` (`uid`),
  CONSTRAINT `FK_tl_latask10_item_comment_3` FOREIGN KEY (`taskList_item_uid`) REFERENCES `tl_latask10_taskList_item` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_item_comment`
--

LOCK TABLES `tl_latask10_item_comment` WRITE;
/*!40000 ALTER TABLE `tl_latask10_item_comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_item_comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_item_log`
--

DROP TABLE IF EXISTS `tl_latask10_item_log`;
CREATE TABLE `tl_latask10_item_log` (
  `uid` bigint(20) NOT NULL auto_increment,
  `access_date` datetime default NULL,
  `taskList_item_uid` bigint(20) default NULL,
  `user_uid` bigint(20) default NULL,
  `complete` tinyint(4) default NULL,
  `session_id` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_NEW_174079138_693580A438BF8DFE` (`taskList_item_uid`),
  KEY `FK_NEW_174079138_693580A441F9365D` (`user_uid`),
  CONSTRAINT `FK_NEW_174079138_693580A441F9365D` FOREIGN KEY (`user_uid`) REFERENCES `tl_latask10_user` (`uid`),
  CONSTRAINT `FK_NEW_174079138_693580A438BF8DFE` FOREIGN KEY (`taskList_item_uid`) REFERENCES `tl_latask10_taskList_item` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_item_log`
--

LOCK TABLES `tl_latask10_item_log` WRITE;
/*!40000 ALTER TABLE `tl_latask10_item_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_item_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_session`
--

DROP TABLE IF EXISTS `tl_latask10_session`;
CREATE TABLE `tl_latask10_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `session_end_date` datetime default NULL,
  `session_start_date` datetime default NULL,
  `status` int(11) default NULL,
  `taskList_uid` bigint(20) default NULL,
  `session_id` bigint(20) default NULL,
  `session_name` varchar(250) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_NEW_174079138_24AA78C530E79035` (`taskList_uid`),
  CONSTRAINT `FK_NEW_174079138_24AA78C530E79035` FOREIGN KEY (`taskList_uid`) REFERENCES `tl_latask10_taskList` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_session`
--

LOCK TABLES `tl_latask10_session` WRITE;
/*!40000 ALTER TABLE `tl_latask10_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_taskList`
--

DROP TABLE IF EXISTS `tl_latask10_taskList`;
CREATE TABLE `tl_latask10_taskList` (
  `uid` bigint(20) NOT NULL auto_increment,
  `create_date` datetime default NULL,
  `update_date` datetime default NULL,
  `create_by` bigint(20) default NULL,
  `title` varchar(255) default NULL,
  `run_offline` tinyint(4) default NULL,
  `instructions` text,
  `online_instructions` text,
  `offline_instructions` text,
  `content_in_use` tinyint(4) default NULL,
  `define_later` tinyint(4) default NULL,
  `content_id` bigint(20) default NULL,
  `lock_when_finished` tinyint(4) default NULL,
  `is_sequential_order` tinyint(4) default NULL,
  `minimum_number_tasks` int(11) default NULL,
  `allow_contribute_tasks` tinyint(4) default NULL,
  `is_monitor_verification_required` tinyint(4) default NULL,
  `reflect_instructions` varchar(255) default NULL,
  `reflect_on_activity` smallint(6) default NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `content_id` (`content_id`),
  KEY `FK_NEW_174079138_89093BF758092FB` (`create_by`),
  CONSTRAINT `FK_NEW_174079138_89093BF758092FB` FOREIGN KEY (`create_by`) REFERENCES `tl_latask10_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_taskList`
--

LOCK TABLES `tl_latask10_taskList` WRITE;
/*!40000 ALTER TABLE `tl_latask10_taskList` DISABLE KEYS */;
INSERT INTO `tl_latask10_taskList` VALUES (1,NULL,NULL,NULL,'Task List',0,'Instructions ',NULL,NULL,0,0,11,0,0,0,0,0,NULL,0);
/*!40000 ALTER TABLE `tl_latask10_taskList` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_taskList_item`
--

DROP TABLE IF EXISTS `tl_latask10_taskList_item`;
CREATE TABLE `tl_latask10_taskList_item` (
  `uid` bigint(20) NOT NULL auto_increment,
  `sequence_id` int(11) default NULL,
  `description` text,
  `init_item` varchar(255) default NULL,
  `organization_xml` text,
  `title` varchar(255) default NULL,
  `create_by` bigint(20) default NULL,
  `create_date` datetime default NULL,
  `create_by_author` tinyint(4) default NULL,
  `is_required` tinyint(4) default NULL,
  `is_comments_allowed` tinyint(4) default NULL,
  `is_comments_required` tinyint(4) default NULL,
  `is_files_allowed` tinyint(4) default NULL,
  `is_files_required` tinyint(4) default NULL,
  `is_comments_files_allowed` tinyint(4) default NULL,
  `show_comments_to_all` tinyint(4) default NULL,
  `is_child_task` tinyint(4) default NULL,
  `parent_task_name` varchar(255) default NULL,
  `taskList_uid` bigint(20) default NULL,
  `session_uid` bigint(20) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_NEW_174079138_F52D1F93758092FB` (`create_by`),
  KEY `FK_NEW_174079138_F52D1F9330E79035` (`taskList_uid`),
  KEY `FK_NEW_174079138_F52D1F93EC0D3147` (`session_uid`),
  CONSTRAINT `FK_NEW_174079138_F52D1F93EC0D3147` FOREIGN KEY (`session_uid`) REFERENCES `tl_latask10_session` (`uid`),
  CONSTRAINT `FK_NEW_174079138_F52D1F9330E79035` FOREIGN KEY (`taskList_uid`) REFERENCES `tl_latask10_taskList` (`uid`),
  CONSTRAINT `FK_NEW_174079138_F52D1F93758092FB` FOREIGN KEY (`create_by`) REFERENCES `tl_latask10_user` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_taskList_item`
--

LOCK TABLES `tl_latask10_taskList_item` WRITE;
/*!40000 ALTER TABLE `tl_latask10_taskList_item` DISABLE KEYS */;
INSERT INTO `tl_latask10_taskList_item` VALUES (1,1,NULL,NULL,NULL,'Task number 1',NULL,'2008-07-07 10:48:36',1,0,0,0,0,0,0,1,0,NULL,1,NULL);
/*!40000 ALTER TABLE `tl_latask10_taskList_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_latask10_user`
--

DROP TABLE IF EXISTS `tl_latask10_user`;
CREATE TABLE `tl_latask10_user` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) default NULL,
  `last_name` varchar(255) default NULL,
  `first_name` varchar(255) default NULL,
  `login_name` varchar(255) default NULL,
  `session_finished` smallint(6) default NULL,
  `session_uid` bigint(20) default NULL,
  `taskList_uid` bigint(20) default NULL,
  `is_verified_by_monitor` tinyint(4) default NULL,
  PRIMARY KEY  (`uid`),
  KEY `FK_NEW_174079138_30113BFCEC0D3147` (`session_uid`),
  KEY `FK_NEW_174079138_30113BFC309ED320` (`taskList_uid`),
  CONSTRAINT `FK_NEW_174079138_30113BFC309ED320` FOREIGN KEY (`taskList_uid`) REFERENCES `tl_latask10_taskList` (`uid`),
  CONSTRAINT `FK_NEW_174079138_30113BFCEC0D3147` FOREIGN KEY (`session_uid`) REFERENCES `tl_latask10_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_latask10_user`
--

LOCK TABLES `tl_latask10_user` WRITE;
/*!40000 ALTER TABLE `tl_latask10_user` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_latask10_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lavote11_content`
--

DROP TABLE IF EXISTS `tl_lavote11_content`;
CREATE TABLE `tl_lavote11_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `content_id` bigint(20) NOT NULL,
  `title` text,
  `instructions` text,
  `creation_date` datetime default NULL,
  `update_date` datetime default NULL,
  `maxNominationCount` varchar(20) NOT NULL default '1',
  `allowText` tinyint(1) NOT NULL default '0',
  `reflect` tinyint(1) NOT NULL default '0',
  `created_by` bigint(20) NOT NULL default '0',
  `run_offline` tinyint(1) NOT NULL default '0',
  `define_later` tinyint(1) NOT NULL default '0',
  `offline_instructions` text,
  `online_instructions` text,
  `content_in_use` tinyint(1) NOT NULL default '0',
  `lock_on_finish` tinyint(1) NOT NULL default '1',
  `retries` tinyint(1) NOT NULL default '0',
  `reflectionSubject` text,
  `show_results` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lavote11_content`
--

LOCK TABLES `tl_lavote11_content` WRITE;
/*!40000 ALTER TABLE `tl_lavote11_content` DISABLE KEYS */;
INSERT INTO `tl_lavote11_content` VALUES (1,7,'Voting','Instructions','2008-07-07 10:48:09',NULL,'1',0,0,1,0,0,'','',0,0,0,NULL,1);
/*!40000 ALTER TABLE `tl_lavote11_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lavote11_nomination_content`
--

DROP TABLE IF EXISTS `tl_lavote11_nomination_content`;
CREATE TABLE `tl_lavote11_nomination_content` (
  `uid` bigint(20) NOT NULL auto_increment,
  `nomination` text,
  `display_order` int(5) default NULL,
  `vote_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `vote_content_id` (`vote_content_id`),
  CONSTRAINT `FK_tl_lavote11_nomination_content_1` FOREIGN KEY (`vote_content_id`) REFERENCES `tl_lavote11_content` (`uid`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lavote11_nomination_content`
--

LOCK TABLES `tl_lavote11_nomination_content` WRITE;
/*!40000 ALTER TABLE `tl_lavote11_nomination_content` DISABLE KEYS */;
INSERT INTO `tl_lavote11_nomination_content` VALUES (1,'Sample Nomination 1',1,1),(2,'Sample Nomination 2',2,1);
/*!40000 ALTER TABLE `tl_lavote11_nomination_content` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lavote11_session`
--

DROP TABLE IF EXISTS `tl_lavote11_session`;
CREATE TABLE `tl_lavote11_session` (
  `uid` bigint(20) NOT NULL auto_increment,
  `vote_session_id` bigint(20) NOT NULL,
  `session_start_date` datetime default NULL,
  `session_end_date` datetime default NULL,
  `session_name` varchar(100) default NULL,
  `session_status` varchar(100) default NULL,
  `vote_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`uid`),
  UNIQUE KEY `UQ_tl_lamc11_session_1` (`vote_session_id`),
  KEY `vote_content_id` (`vote_content_id`),
  CONSTRAINT `FK_tl_lavote11_session_1` FOREIGN KEY (`vote_content_id`) REFERENCES `tl_lavote11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lavote11_session`
--

LOCK TABLES `tl_lavote11_session` WRITE;
/*!40000 ALTER TABLE `tl_lavote11_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lavote11_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lavote11_uploadedfile`
--

DROP TABLE IF EXISTS `tl_lavote11_uploadedfile`;
CREATE TABLE `tl_lavote11_uploadedfile` (
  `submissionId` bigint(20) NOT NULL auto_increment,
  `uuid` varchar(255) NOT NULL,
  `isOnline_File` tinyint(1) NOT NULL,
  `filename` varchar(255) NOT NULL,
  `vote_content_id` bigint(20) NOT NULL,
  PRIMARY KEY  (`submissionId`),
  KEY `vote_content_id` (`vote_content_id`),
  CONSTRAINT `FK_tablex_111` FOREIGN KEY (`vote_content_id`) REFERENCES `tl_lavote11_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lavote11_uploadedfile`
--

LOCK TABLES `tl_lavote11_uploadedfile` WRITE;
/*!40000 ALTER TABLE `tl_lavote11_uploadedfile` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lavote11_uploadedfile` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lavote11_usr`
--

DROP TABLE IF EXISTS `tl_lavote11_usr`;
CREATE TABLE `tl_lavote11_usr` (
  `uid` bigint(20) NOT NULL auto_increment,
  `user_id` bigint(20) NOT NULL,
  `vote_session_id` bigint(20) NOT NULL,
  `username` varchar(255) default NULL,
  `fullname` varchar(255) default NULL,
  `responseFinalised` tinyint(1) NOT NULL default '0',
  `finalScreenRequested` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`uid`),
  KEY `vote_session_id` (`vote_session_id`),
  CONSTRAINT `FK_tl_lavote11_usr_1` FOREIGN KEY (`vote_session_id`) REFERENCES `tl_lavote11_session` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lavote11_usr`
--

LOCK TABLES `tl_lavote11_usr` WRITE;
/*!40000 ALTER TABLE `tl_lavote11_usr` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lavote11_usr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tl_lavote11_usr_attempt`
--

DROP TABLE IF EXISTS `tl_lavote11_usr_attempt`;
CREATE TABLE `tl_lavote11_usr_attempt` (
  `uid` bigint(20) NOT NULL auto_increment,
  `que_usr_id` bigint(20) NOT NULL,
  `vote_nomination_content_id` bigint(20) NOT NULL,
  `attempt_time` datetime default NULL,
  `time_zone` varchar(255) default NULL,
  `userEntry` varchar(255) default NULL,
  `singleUserEntry` tinyint(1) NOT NULL default '0',
  `visible` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`uid`),
  KEY `que_usr_id` (`que_usr_id`),
  KEY `vote_nomination_content_id` (`vote_nomination_content_id`),
  CONSTRAINT `FK_tl_lavote11_usr_attempt_2` FOREIGN KEY (`que_usr_id`) REFERENCES `tl_lavote11_usr` (`uid`),
  CONSTRAINT `FK_tl_lavote11_usr_attempt_3` FOREIGN KEY (`vote_nomination_content_id`) REFERENCES `tl_lavote11_nomination_content` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tl_lavote11_usr_attempt`
--

LOCK TABLES `tl_lavote11_usr_attempt` WRITE;
/*!40000 ALTER TABLE `tl_lavote11_usr_attempt` DISABLE KEYS */;
/*!40000 ALTER TABLE `tl_lavote11_usr_attempt` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2008-07-07  2:21:47
