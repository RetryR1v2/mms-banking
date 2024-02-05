CREATE TABLE `mms_bankingvaults` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`vaultid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`vaultname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`storage` INT(11) NULL DEFAULT NULL,
	`level` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
;
