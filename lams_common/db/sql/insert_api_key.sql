SET FOREIGN_KEY_CHECKS=0;
SET NAMES utf8mb4 ;

LOCK TABLES `lams_configuration` WRITE;
INSERT INTO `lams_configuration`(`config_key`, `config_value`, `description_key`, `header_name`, `format`, `required`) VALUES ('AzureOpenApiKey', '6660ba5d197e94ff5a10c5b6a157b18da', 'sysadmin.azure.apikey', 'config.header.chat', 'STRING', 0);
INSERT INTO `lams_configuration`(`config_key`, `config_value`, `description_key`, `header_name`, `format`, `required`) VALUES ('AzureAiName', 'bot', 'sysadmin.azure.ai.name', 'config.header.chat', 'STRING', 0);
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS=1;