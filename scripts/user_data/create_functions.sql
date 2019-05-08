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
   (v_id, p_login, p_password, p_name, 'true');

   RETURN v_id;

   EXCEPTION
   WHEN OTHERS THEN
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

/*Edit Account*/
CREATE OR REPLACE FUNCTION user_data.edit_account(
	p_id integer,
	p_name text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE user_data.ACCOUNT
   SET name = p_name
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Account*/
CREATE OR REPLACE FUNCTION user_data.get_account(
  p_id integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'id', a.id,
    'login', a.login,
    'name', a.name,
    'enabled', a.enabled
  ) into v_result
  FROM user_data.account a
  WHERE a.id = p_id;

  RETURN v_result;
END;
$BODY$;

/*Login*/
CREATE OR REPLACE FUNCTION user_data.login(
  p_login text,
  p_password text)
    RETURNS text
    LANGUAGE 'plpgsql'
AS $BODY$
declare
  v_account integer;
  v_enabled boolean;
  v_token text;
  v_count integer;
  v_done boolean = false;
BEGIN
  SELECT ID, ENABLED into v_account, v_enabled
  FROM user_data.ACCOUNT
  WHERE login = p_login
  AND password = p_password;

  IF v_account IS NULL OR NOT v_enabled THEN
    v_token = 'denied';
  ELSE
    WHILE v_done = false LOOP
      SELECT MD5(random()::text) into v_token;

      SELECT count(1) INTO v_count
      FROM user_data.SESSION
      WHERE token = v_token;

      IF v_count = 0 THEN
        INSERT INTO user_data.SESSION (TOKEN, ACCOUNT, ORGANIZATIONS, CADUCITY) VALUES
        (v_token, v_account,
          (SELECT array_agg(o.id)
          FROM user_data.administration a
          JOIN user_data.organization o
          ON a.organization = o.id
          WHERE a.account = v_account
          AND a.enabled
          AND o.enabled), localtimestamp + interval '1 day');
        v_done = true;
      END IF;
    END LOOP;
  END IF;

  RETURN v_token;

  EXCEPTION
    WHEN OTHERS THEN
    RETURN 'error: '||SQLERRM;
END;
$BODY$;

/*Get Token Info*/
CREATE OR REPLACE FUNCTION user_data.get_token_info(
  p_token text)
    RETURNS jsonb
    LANGUAGE 'plpgsql'
AS $BODY$
declare
  v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'result', 'ok',
    'account', s.account,
    'organizations', s.organizations
  ) into v_result
  FROM user_data.SESSION s
  WHERE s.token = p_token
  AND localtimestamp < s.caducity;

  RETURN v_result;

  EXCEPTION
    WHEN OTHERS THEN
    RETURN '{"result": "error"}'::jsonb;
END;
$BODY$;

/*Logout*/
CREATE OR REPLACE FUNCTION user_data.logout(
  p_account integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
AS $BODY$
declare
BEGIN
  DELETE FROM user_data.SESSION
  WHERE account = p_account;

  RETURN 0;

  EXCEPTION
    WHEN OTHERS THEN
    RETURN -1;
END;
$BODY$;

/*Get Accounts*/
CREATE OR REPLACE FUNCTION user_data.get_accounts()
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', a.id,
    'name', a.name
  )) into v_result
  FROM user_data.account a
  WHERE a.enabled;

  RETURN v_result;
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

/*Edit Organization*/
CREATE OR REPLACE FUNCTION user_data.edit_organization(
	p_id integer,
	p_name text,
  p_contact_mail text,
  p_contact_number integer,
  p_logo text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE
AS $BODY$
BEGIN
   UPDATE user_data.ORGANIZATION
   SET name = p_name,
    contact_mail = p_contact_mail,
    contact_number = p_contact_number,
    logo = p_logo
   WHERE ID = p_id;

   RETURN 0;

   EXCEPTION
   WHEN OTHERS THEN
   RETURN -1;
END;
$BODY$;

/*Get Organizations*/
CREATE OR REPLACE FUNCTION user_data.get_organizations(
  p_account integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', o.id,
    'name', o.name
  )) into v_result
  FROM user_data.organization o
  WHERE o.id IN(
	  SELECT a.organization
	  FROM user_data.administration a
	  WHERE a.account = p_account
    AND a.enabled);

   RETURN v_result;
END;
$BODY$;

/*Get Organization*/
CREATE OR REPLACE FUNCTION user_data.get_organization(
  p_id integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_build_object(
    'id', o.id,
    'name', o.name,
	  'contact', jsonb_build_object(
		  'mail', o.contact_mail,
		  'number', o.contact_number),
	  'logo', o.logo,
	  'enabled', o.enabled
  ) into v_result
  FROM user_data.organization o
  WHERE o.id = p_id;

   RETURN v_result;
END;
$BODY$;

/*Create Administration*/
CREATE OR REPLACE FUNCTION user_data.create_administration(
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

/*Get Administrations*/
CREATE OR REPLACE FUNCTION user_data.get_administrations(
  p_organization integer)
    RETURNS jsonb
    LANGUAGE 'plpgsql'

AS $BODY$
declare
	v_result jsonb;
BEGIN
  SELECT jsonb_agg(jsonb_build_object(
    'id', a.account,
		'name', ac.name,
    'enabled', a.enabled
  )) into v_result
  FROM user_data.administration a
  JOIN user_data.account ac ON a.account = ac.id
  WHERE a.organization = p_organization;

   RETURN v_result;
END;
$BODY$;
