/*Competition*/
CREATE TABLE competition_data.competition (
  id integer NOT NULL,
  organization integer NOT NULL,
  name character varying(100) NOT NULL,
  videogame integer NOT NULL,
  platform integer NOT NULL,
  region integer NOT NULL,
  game_mode integer NOT NULL,
  registration_date date NOT NULL,
  competition_date date NOT NULL,
  weak_cap integer,
  hard_cap integer,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (organization, name),
	FOREIGN KEY (organization) REFERENCES user_data.organization (id),
	FOREIGN KEY (videogame) REFERENCES master_data.videogame (id),
	FOREIGN KEY (platform) REFERENCES master_data.platform (id),
	FOREIGN KEY (region) REFERENCES master_data.region (id),
	FOREIGN KEY (game_mode) REFERENCES master_data.game_mode (id),
	FOREIGN KEY (step) REFERENCES step_data.competition (id)
);

/*Registration*/
CREATE TABLE competition_data.registration (
  id integer NOT NULL,
  competition integer NOT NULL,
  name character varying(20) NOT NULL,
  account integer,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (competition, account),
  UNIQUE (competition, name),
  FOREIGN KEY (account) REFERENCES user_data.account (id),
  FOREIGN KEY (competition) REFERENCES competition_data.competition (id),
  FOREIGN KEY (step) REFERENCES step_data.registration (id)
);

/*Phase*/
CREATE TABLE competition_data.phase (
  id integer NOT NULL,
  competition integer NOT NULL,
  phase integer NOT NULL,
  format integer NOT NULL,
  bo integer NOT NULL,
  phase_date date NOT NULL,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (competition, phase),
  FOREIGN KEY (bo) REFERENCES master_data.bo (id),
  FOREIGN KEY (competition) REFERENCES competition_data.competition (id),
  FOREIGN KEY (format) REFERENCES master_data.format (id),
  FOREIGN KEY (step) REFERENCES step_data.phase (id)
);

/*Competitor*/
CREATE TABLE competition_data.competitor (
  id integer NOT NULL,
  phase integer NOT NULL,
  competitor integer NOT NULL,
  registration integer,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (phase, competitor),
  UNIQUE (phase, registration),
  FOREIGN KEY (phase) REFERENCES competition_data.phase (id),
  FOREIGN KEY (registration) REFERENCES competition_data.registration (id),
  FOREIGN KEY (step) REFERENCES step_data.competitor (id)
);

/*Bracket*/
CREATE TABLE competition_data.bracket (
  id integer NOT NULL,
  phase integer NOT NULL,
  bracket integer NOT NULL,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (phase, bracket),
  FOREIGN KEY (phase) REFERENCES competition_data.phase (id),
  FOREIGN KEY (step) REFERENCES step_data.bracket (id)
);

/*Slot*/
CREATE TABLE competition_data.slot (
  id integer NOT NULL,
  bracket integer NOT NULL,
  slot integer NOT NULL,
  competitor integer,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (bracket, competitor),
  UNIQUE (bracket, slot),
  FOREIGN KEY (bracket) REFERENCES competition_data.bracket (id),
  FOREIGN KEY (competitor) REFERENCES competition_data.competitor (id),
  FOREIGN KEY (step) REFERENCES step_data.slot (id)
);

/*Round*/
CREATE TABLE competition_data.round (
  id integer NOT NULL,
  bracket integer NOT NULL,
  round integer NOT NULL,
  round_date date NOT NULL,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (bracket, round),
  FOREIGN KEY (bracket) REFERENCES competition_data.bracket (id),
  FOREIGN KEY (step) REFERENCES step_data.round (id)
);

/*Match*/
CREATE TABLE competition_data.match (
  id integer NOT NULL,
  round integer NOT NULL,
  match integer NOT NULL,
  match_date date NOT NULL,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (round, match),
  FOREIGN KEY (round) REFERENCES competition_data.round (id),
  FOREIGN KEY (step) REFERENCES step_data.match (id)
);

/*Rival*/
CREATE TABLE competition_data.rival (
  id integer NOT NULL,
  match integer NOT NULL,
  rival integer NOT NULL,
  slot integer,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (match, rival),
  UNIQUE (match, slot),
  FOREIGN KEY (match) REFERENCES competition_data.match (id),
  FOREIGN KEY (slot) REFERENCES competition_data.slot (id),
  FOREIGN KEY (step) REFERENCES step_data.rival (id)
);

/*Game*/
CREATE TABLE competition_data.game (
  id integer NOT NULL,
  match integer NOT NULL,
  game integer NOT NULL,
  game_date date NOT NULL,
  winner integer,
  step integer NOT NULL,
  PRIMARY KEY (id),
  UNIQUE (match, game),
  FOREIGN KEY (match) REFERENCES competition_data.match (id),
  FOREIGN KEY (step) REFERENCES step_data.game (id),
  FOREIGN KEY (winner) REFERENCES competition_data.rival (id)
);
