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
	  'enabled', o.enabled,
	  'administrations', user_data.get_administrations(p_id)
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
