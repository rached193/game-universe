/*Videogame*/
CREATE TABLE master_data.VIDEOGAME (
	ID INTEGER,
	NAME character varying(50) NOT NULL,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE (NAME)
);

/*Platform*/
CREATE TABLE master_data.PLATFORM (
	ID INTEGER,
	NAME character varying(50) NOT NULL,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE (NAME)
);

/*Region*/
CREATE TABLE master_data.REGION (
	ID INTEGER,
	VIDEOGAME INTEGER NOT NULL,
	NAME character varying(50) NOT NULL,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (VIDEOGAME) REFERENCES master_data.VIDEOGAME (ID),
	UNIQUE (VIDEOGAME, NAME)
);

/*GameMode*/
CREATE TABLE master_data.GAME_MODE (
	ID INTEGER,
	VIDEOGAME INTEGER NOT NULL,
	NAME character varying(50) NOT NULL,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (ID),
	FOREIGN KEY (VIDEOGAME) REFERENCES master_data.VIDEOGAME (ID),
	UNIQUE (VIDEOGAME, NAME)
);

/*Videogame-Platform*/
CREATE TABLE master_data.VIDEOGAME_PLATFORM (
	VIDEOGAME INTEGER,
	PLATFORM INTEGER,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (VIDEOGAME, PLATFORM),
	FOREIGN KEY (VIDEOGAME) REFERENCES master_data.VIDEOGAME (ID),
	FOREIGN KEY (PLATFORM) REFERENCES master_data.PLATFORM (ID)
);

/*Format*/
CREATE TABLE master_data.FORMAT (
	ID INTEGER,
	NAME character varying(50) NOT NULL,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE (NAME)
);

/*BO*/
CREATE TABLE master_data.BO (
	ID INTEGER,
	NAME character varying(50) NOT NULL,
	GAMES INTEGER NOT NULL,
	ENABLED BOOLEAN NOT NULL,
	PRIMARY KEY (ID),
	UNIQUE (NAME),
	UNIQUE (GAMES)
);
