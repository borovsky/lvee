CREATE TABLE `abstract_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `abstract_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `body` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=56 DEFAULT CHARSET=utf8;

CREATE TABLE `abstract_files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file` varchar(255) DEFAULT NULL,
  `abstract_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8;

CREATE TABLE `abstract_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `abstract_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `conference_registration_id` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `body` text,
  `change_summary` varchar(255) DEFAULT NULL,
  `ready_for_review` tinyint(1) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_thesis_versions_on_thesis_id` (`abstract_id`)
) ENGINE=InnoDB AUTO_INCREMENT=239 DEFAULT CHARSET=utf8;

CREATE TABLE `abstracts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `body` text,
  `change_summary` varchar(255) DEFAULT NULL,
  `ready_for_review` tinyint(1) DEFAULT NULL,
  `author_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `conference_id` int(11) DEFAULT NULL,
  `authors` varchar(255) DEFAULT NULL,
  `summary` text,
  `license` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8;

CREATE TABLE `article_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `article_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `category` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `body` mediumtext,
  `locale` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_article_versions_on_article_id` (`article_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1447 DEFAULT CHARSET=utf8;

CREATE TABLE `articles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `body` text,
  `locale` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_articles_on_category_and_name_and_locale` (`category`,`name`,`locale`),
  KEY `index_articles_on_category_and_name` (`category`,`name`)
) ENGINE=InnoDB AUTO_INCREMENT=282 DEFAULT CHARSET=utf8;

CREATE TABLE `badges` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conference_registration_id` int(11) DEFAULT NULL,
  `tags` varchar(255) DEFAULT NULL,
  `top` varchar(255) DEFAULT NULL,
  `bottom` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_badges_on_conference_registration_id` (`conference_registration_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1890 DEFAULT CHARSET=utf8;

CREATE TABLE `conference_registrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `conference_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `proposition` text,
  `status_name` varchar(255) DEFAULT NULL,
  `days` varchar(255) DEFAULT NULL,
  `food` varchar(255) DEFAULT NULL,
  `tshirt` varchar(255) DEFAULT NULL,
  `transport_from` varchar(255) DEFAULT NULL,
  `meeting` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `user_type` varchar(255) DEFAULT 'normal',
  `to_pay` int(11) DEFAULT NULL,
  `transport_to` varchar(255) DEFAULT NULL,
  `residence` varchar(255) DEFAULT NULL,
  `floor` tinyint(1) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_conference_registrations_on_conference_id` (`conference_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1126 DEFAULT CHARSET=utf8;

CREATE TABLE `conferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `registration_opened` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;

CREATE TABLE `editor_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(255) DEFAULT NULL,
  `body` mediumtext,
  `user_name` varchar(255) DEFAULT NULL,
  `object_name` varchar(255) DEFAULT NULL,
  `change_type` varchar(255) DEFAULT NULL,
  `public` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2861 DEFAULT CHARSET=utf8;

CREATE TABLE `image_uploads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) DEFAULT NULL,
  `file` varchar(255) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;

CREATE TABLE `languages` (
  `name` varchar(2) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `published` tinyint(1) DEFAULT NULL,
  `code3` varchar(3) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `maillist_subscriptions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `maillist` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_maillist_subscriptions_on_maillist_and_email` (`maillist`,`email`)
) ENGINE=InnoDB AUTO_INCREMENT=841 DEFAULT CHARSET=utf8;

CREATE TABLE `metainfos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `page` varchar(255) DEFAULT NULL,
  `language` varchar(3) DEFAULT NULL,
  `keywords` text,
  `description` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;

CREATE TABLE `news` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `lead` text,
  `body` text,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `locale` varchar(2) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_news_on_parent_id_and_locale` (`parent_id`,`locale`)
) ENGINE=InnoDB AUTO_INCREMENT=130 DEFAULT CHARSET=utf8;

CREATE TABLE `news_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `lead` text,
  `body` text,
  `user_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `locale` varchar(2) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `published_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_news_versions_on_news_id` (`news_id`)
) ENGINE=InnoDB AUTO_INCREMENT=522 DEFAULT CHARSET=utf8;

CREATE TABLE `not_found_redirects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `path` varchar(255) DEFAULT NULL,
  `target` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `sponsors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `sponsor_type` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;

CREATE TABLE `statuses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `mail` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_statuses_on_name_and_locale` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `occupation` varchar(255) DEFAULT NULL,
  `projects` text,
  `crypted_password` varchar(40) DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(255) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `activation_code` varchar(40) DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `subscribed` tinyint(1) DEFAULT NULL,
  `avator` varchar(255) DEFAULT NULL,
  `subscribed_talks` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1248 DEFAULT CHARSET=utf8;

CREATE TABLE `users_abstracts` (
  `user_id` int(11) DEFAULT NULL,
  `abstract_id` int(11) DEFAULT NULL,
  KEY `index_users_thesises_on_user_id` (`user_id`),
  KEY `index_users_thesises_on_thesis_id` (`abstract_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `wiki_page_versions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_page_id` int(11) DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `body` mediumtext,
  `user_id` int(11) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_wiki_page_versions_on_wiki_page_id` (`wiki_page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1686 DEFAULT CHARSET=utf8;

CREATE TABLE `wiki_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `body` mediumtext,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `version` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('2');

INSERT INTO schema_migrations (version) VALUES ('20090111095310');

INSERT INTO schema_migrations (version) VALUES ('20090118131904');

INSERT INTO schema_migrations (version) VALUES ('20090124201426');

INSERT INTO schema_migrations (version) VALUES ('20090208171641');

INSERT INTO schema_migrations (version) VALUES ('20090215083617');

INSERT INTO schema_migrations (version) VALUES ('20090308133803');

INSERT INTO schema_migrations (version) VALUES ('20090315102546');

INSERT INTO schema_migrations (version) VALUES ('20090317220859');

INSERT INTO schema_migrations (version) VALUES ('20090321075932');

INSERT INTO schema_migrations (version) VALUES ('20090404170210');

INSERT INTO schema_migrations (version) VALUES ('20090411175429');

INSERT INTO schema_migrations (version) VALUES ('20090418164336');

INSERT INTO schema_migrations (version) VALUES ('20090419101002');

INSERT INTO schema_migrations (version) VALUES ('20090426112548');

INSERT INTO schema_migrations (version) VALUES ('20090526123706');

INSERT INTO schema_migrations (version) VALUES ('20090606075217');

INSERT INTO schema_migrations (version) VALUES ('20090612110458');

INSERT INTO schema_migrations (version) VALUES ('20090626070011');

INSERT INTO schema_migrations (version) VALUES ('20090808154841');

INSERT INTO schema_migrations (version) VALUES ('20100402163018');

INSERT INTO schema_migrations (version) VALUES ('20100607125345');

INSERT INTO schema_migrations (version) VALUES ('20110628111256');

INSERT INTO schema_migrations (version) VALUES ('20110803130140');

INSERT INTO schema_migrations (version) VALUES ('20110818111001');

INSERT INTO schema_migrations (version) VALUES ('20110818111636');

INSERT INTO schema_migrations (version) VALUES ('20110912075630');

INSERT INTO schema_migrations (version) VALUES ('20110922142741');

INSERT INTO schema_migrations (version) VALUES ('20110922142829');

INSERT INTO schema_migrations (version) VALUES ('20111017075229');

INSERT INTO schema_migrations (version) VALUES ('20111017080520');

INSERT INTO schema_migrations (version) VALUES ('20111019073938');

INSERT INTO schema_migrations (version) VALUES ('20111024085114');

INSERT INTO schema_migrations (version) VALUES ('20111024104948');

INSERT INTO schema_migrations (version) VALUES ('20111024110829');

INSERT INTO schema_migrations (version) VALUES ('20111115073051');

INSERT INTO schema_migrations (version) VALUES ('3');