/*Create Log*/
create or replace function log_data.create_log(
  p_type character,
  p_info text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   select nextval('log_data.log_seq') into v_id;

   insert into log_data.log (id, log_type, log_info, log_time) values
   (v_id, p_type, p_info, now());

   return v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;
