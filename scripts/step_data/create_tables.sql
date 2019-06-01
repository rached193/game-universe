/*Competition*/
create table step_data.competition (
  id integer not null,
  description text,
  primary key (id)
);

/*Registration*/
create table step_data.registration (
  id integer not null,
  description text,
  primary key (id)
);

/*Phase*/
create table step_data.phase (
  id integer not null,
  description text,
  primary key (id)
);

/*Competitor*/
create table step_data.competitor (
  id integer not null,
  description text,
  primary key (id)
);

/*Bracket*/
create table step_data.bracket (
  id integer not null,
  description text,
  primary key (id)
);

/*Slot*/
create table step_data.slot (
  id integer not null,
  description text,
  primary key (id)
);

/*Round*/
create table step_data.round (
  id integer not null,
  description text,
  primary key (id)
);

/*Match*/
create table step_data.match (
  id integer not null,
  description text,
  primary key (id)
);

/*Rival*/
create table step_data.rival (
  id integer not null,
  description text,
  primary key (id)
);

/*Game*/
create table step_data.game (
  id integer not null,
  description text,
  primary key (id)
);
