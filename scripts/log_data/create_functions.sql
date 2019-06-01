/*Create Log*/
create or replace function log_data.create_log(
  p_msg text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   select nextval('log_data.log_seq') into v_id;

   insert into log_data.log (id, msg) values
   (v_id, p_msg);

   return v_id;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;
