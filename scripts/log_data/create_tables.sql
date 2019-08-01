/*log*/
create table log_data.log(
  id integer not null,
  log_type character (1),
  log_info text,
  log_time timestamp without time zone,
  primary key(id)
);
