/*Create Account*/
CREATE OR REPLACE FUNCTION user_data.create_account(
	p_login text,
  p_password text,
  p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
BEGIN
   SELECT nextval('user_data.ACCOUNT_SEQ') into v_id;

   INSERT INTO user_data.ACCOUNT (ID, LOGIN, PASSWORD, NAME, ENABLED) VALUES
   (v_id, p_login, p_password, p_name, 'false');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
   PERFORM setval('user_data.ACCOUNT_SEQ', currval('user_data.ACCOUNT_SEQ') - 1);
   RETURN -1;
END;
$BODY$;

/*Enable Account*/
CREATE OR REPLACE FUNCTION user_data.enable_account(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE user_data.ACCOUNT
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Create Organization*/
CREATE OR REPLACE FUNCTION user_data.create_organization(
	p_name text,
  p_contact_mail text,
  p_contact_number integer,
  p_logo text,
  p_account integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
declare
	v_id integer;
  v_result integer;
BEGIN
  SELECT nextval('user_data.ORGANIZATION_SEQ') into v_id;

  INSERT INTO user_data.ORGANIZATION (ID, NAME, CONTACT_MAIL, CONTACT_NUMBER, LOGO, ENABLED) VALUES
  (v_id, p_name, p_contact_mail, p_contact_number, p_logo, 'false');

  v_result = user_data.create_administration(v_id, p_account);
  IF v_result = -1 THEN
    RAISE EXCEPTION 'Error en subproceso';
  END IF;

  v_result = user_data.enable_administration(v_id, p_account, 'true');
  IF v_result = -1 THEN
    RAISE EXCEPTION 'Error en subproceso';
  END IF;

  RETURN v_id;

  EXCEPTION
  WHEN OTHERS THEN
   PERFORM setval('user_data.ORGANIZATION_SEQ', currval('user_data.ORGANIZATION_SEQ') - 1);
   RETURN -1;
END;
$BODY$;

/*Enable Organization*/
CREATE OR REPLACE FUNCTION user_data.enable_organization(
	p_id integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE user_data.ORGANIZATION
   SET ENABLED = p_enabled
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Create Administration*/
CREATE OR REPLACE FUNCTION user_data.create_organization(
	p_organization integer,
  p_account integer)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   INSERT INTO user_data.ADMINISTRATION (ORGANIZATION, ACCOUNT, ENABLED) VALUES
   (p_organization, p_account, 'false');

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Enable Administration*/
CREATE OR REPLACE FUNCTION user_data.enable_administration(
	p_organization integer,
  p_account integer,
	p_enabled boolean)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE user_data.ADMINISTRATION
   SET ENABLED = p_enabled
   WHERE ORGANIZATION = p_organization
   AND ACCOUNT = p_account;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;
