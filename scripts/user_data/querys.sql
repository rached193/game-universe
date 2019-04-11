/*Account*/
SELECT user_data.create_account(p_login, p_password, p_name) as data;

SELECT user_data.enable_account(p_id, p_enabled) as data;

SELECT user_data.edit_account(p_id, p_name) as data;

SELECT user_data.get_account(p_id) as data;

SELECT user_data.get_accounts() as data;

/*Organization*/

SELECT user_data.create_organization(p_name, p_contact_mail, p_contact_number, p_logo, p_account) as data;

SELECT user_data.enable_organization(p_id, p_enabled) as data;

SELECT user_data.edit_organization(p_id, p_name, p_contact_mail, p_contact_number, p_logo) as data;

SELECT user_data.get_organizations(p_account) as data;

SELECT user_data.get_organization(p_id) as data;

/*Administration*/

SELECT user_data.create_administration(p_organization, p_account) as data;

SELECT user_data.enable_administration(p_organization, p_account, p_enabled) as data;

SELECT user_data.get_administrations(p_organization) as data;
