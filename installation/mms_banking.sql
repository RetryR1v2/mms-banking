CREATE TABLE `mms_banking` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`charidentifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`bankid` INT(11) NOT NULL DEFAULT '0',
	`balance` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;

CREATE TABLE `mms_bankingvaults` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`identifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`charidentifier` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`vaultid` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`vaultname` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8_general_ci',
	`storage` INT(11) NULL DEFAULT NULL,
	`level` INT(11) NULL DEFAULT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;

CREATE TABLE `mms_bankingbills` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`fromidentifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`fromcharidentifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`fromfirstname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`fromlastname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`toidentifier` VARCHAR(50) NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`tocharidentifier` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`tofirstname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`tolastname` VARCHAR(50) NOT NULL DEFAULT '0' COLLATE 'utf8_general_ci',
	`amount` INT(11) NOT NULL DEFAULT '0',
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8_general_ci'
ENGINE=InnoDB
AUTO_INCREMENT=1
;

