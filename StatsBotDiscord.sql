CREATE TABLE `player` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`discordId` bigint(64) UNSIGNED NOT NULL,
`primary_rank` int(11) UNSIGNED NOT NULL DEFAULT 1,
`shop_points` bigint(64) UNSIGNED NOT NULL DEFAULT 0,
`banned` bit(1) NOT NULL DEFAULT b'0',
`register_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `user_discordId` (`discordId` ASC) USING HASH
);
CREATE TABLE `guild` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`discordId` bigint(64) UNSIGNED NOT NULL,
`banned` bit(1) NOT NULL DEFAULT b'0',
`register_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `server_discordId` (`discordId` ASC) USING HASH
);
CREATE TABLE `channel` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`discordId` bigint(50) UNSIGNED NOT NULL,
`guild_id` int(64) UNSIGNED NOT NULL,
`disabled` bit(1) NOT NULL DEFAULT b'0',
`register_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `channel_discordId` (`discordId` ASC) USING HASH
);
CREATE TABLE `achievement` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`achievement_name` varchar(11) NOT NULL,
`hidden` bit(1) NOT NULL,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `achievement_achievement_name` (`achievement_name` ASC) USING BTREE
);
CREATE TABLE `player_setting` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`player_id` int(11) UNSIGNED NOT NULL,
`setting_id` int(11) UNSIGNED NOT NULL,
`setting` varchar(255) NOT NULL,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `player_setting_player_id_setting_id` (`player_id` ASC, `setting_id` ASC) USING HASH
);
CREATE TABLE `rank` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`rank_name` varchar(50) NOT NULL,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `rank_rank_name` (`rank_name` ASC) USING BTREE
);
CREATE TABLE `player_rank` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`player_id` int(11) UNSIGNED NOT NULL,
`rank_id` int(11) UNSIGNED NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `setting` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`setting_name` varchar(50) NOT NULL,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `setting_setting_name` (`setting_name` ASC) USING BTREE
);
CREATE TABLE `player_permission` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`player_id` int(11) UNSIGNED NOT NULL,
`permission_id` int(11) UNSIGNED NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `permission` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`permission_node` varchar(50) NOT NULL,
`default_permission` bit(1) NOT NULL,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `permission_permission_node` (`permission_node` ASC) USING BTREE
);
CREATE TABLE `player_achievement` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`player_id` int(11) UNSIGNED NOT NULL,
`achievement_id` int(11) UNSIGNED NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `rank_permission` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`rank_id` int(11) UNSIGNED NOT NULL,
`permission_id` int(11) UNSIGNED NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `guild_command_alias` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`guild_id` int(11) UNSIGNED NOT NULL,
`alias` varchar(10) NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `guild_setting` (
`id` int UNSIGNED NOT NULL AUTO_INCREMENT,
`guild_id` int(11) UNSIGNED NOT NULL,
`setting_id` int(11) UNSIGNED NOT NULL,
`setting` varchar(255) NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `setting_log` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`setting_id` int(11) UNSIGNED NOT NULL,
`guild_id` int(11) UNSIGNED NOT NULL,
`player_id` int(11) UNSIGNED NOT NULL,
`new_setting` varchar(255) NULL,
`date` datetime NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`) 
);
CREATE TABLE `achievement_log` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`achievement_id` int(11) UNSIGNED NOT NULL,
`player_id` int(11) UNSIGNED NOT NULL,
`date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
PRIMARY KEY (`id`) 
);
CREATE TABLE `player_stat` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`player_id` int(11) UNSIGNED NOT NULL,
`stat_id` int(11) UNSIGNED NOT NULL,
`value` bigint(64) UNSIGNED NOT NULL,
PRIMARY KEY (`id`) 
);
CREATE TABLE `stat` (
`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
`stat_name` varchar(50) NOT NULL,
PRIMARY KEY (`id`) ,
UNIQUE INDEX `stat_stat_stat_name` (`stat_name` ASC) USING HASH
);

ALTER TABLE `player_setting` ADD CONSTRAINT `player_setting_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_setting` ADD CONSTRAINT `player_setting_setting_id` FOREIGN KEY (`setting_id`) REFERENCES `setting` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_permission` ADD CONSTRAINT `player_permissions_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_permission` ADD CONSTRAINT `player_permissions_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_rank` ADD CONSTRAINT `player_rank_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_rank` ADD CONSTRAINT `player_rank_rank_id` FOREIGN KEY (`rank_id`) REFERENCES `rank` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `channel` ADD CONSTRAINT `channel_guild_id` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_achievement` ADD CONSTRAINT `player_achievement_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player_achievement` ADD CONSTRAINT `player_achievement_achievement_id` FOREIGN KEY (`achievement_id`) REFERENCES `achievement` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `player` ADD CONSTRAINT `player_primary_rank` FOREIGN KEY (`primary_rank`) REFERENCES `rank` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `rank_permission` ADD CONSTRAINT `rank_permission_rank_id` FOREIGN KEY (`rank_id`) REFERENCES `rank` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `rank_permission` ADD CONSTRAINT `rank_permission_permission_id` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `guild_command_alias` ADD CONSTRAINT `guild_command_alias_guild_id` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `guild_setting` ADD CONSTRAINT `guild_setting_guild_id` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `guild_setting` ADD CONSTRAINT `guild_setting_setting_id` FOREIGN KEY (`setting_id`) REFERENCES `setting` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `setting_log` ADD CONSTRAINT `setting_log_setting_id` FOREIGN KEY (`setting_id`) REFERENCES `setting` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `setting_log` ADD CONSTRAINT `setting_log_guild_id` FOREIGN KEY (`guild_id`) REFERENCES `guild` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `setting_log` ADD CONSTRAINT `setting_log_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `achievement_log` ADD CONSTRAINT `achievement_log_achievement_id` FOREIGN KEY (`achievement_id`) REFERENCES `achievement` (`id`) ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE `achievement_log` ADD CONSTRAINT `achievement_log_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
ALTER TABLE `player_stat` ADD CONSTRAINT `player_stat_player_id` FOREIGN KEY (`player_id`) REFERENCES `player` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;
ALTER TABLE `player_stat` ADD CONSTRAINT `player_stat_stat_id` FOREIGN KEY (`stat_id`) REFERENCES `stat` (`id`) ON DELETE NO ACTION ON UPDATE CASCADE;

