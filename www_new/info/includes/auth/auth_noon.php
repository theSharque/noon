<?php
/**
* Noon auth plug-in for phpBB3
*
* Authentication plug-ins is largely upgrade by Alex Sharque.
*
* This is for authentication via the integrated user table
*
* @package login
* @version $Id$
* @copyright (c) 2005 phpBB Group
* @license http://opensource.org/licenses/gpl-license.php GNU Public License
*
*/

/**
* @ignore
*/
if (!defined('IN_PHPBB'))
{
	exit;
} else {
  include "/home/nooncom/public_html/include/db.inc";
}

/**
* Login function
*/
function login_noon(&$username, &$password)
{
	global $db, $config;

	// do not allow empty password
	if (!$password)
	{
		return array(
			'status'	=> LOGIN_ERROR_PASSWORD,
			'error_msg'	=> 'NO_PASSWORD_SUPPLIED',
			'user_row'	=> array('user_id' => ANONYMOUS),
		);
	}

	if (!$username)
	{
		return array(
			'status'	=> LOGIN_ERROR_USERNAME,
			'error_msg'	=> 'LOGIN_ERROR_USERNAME',
			'user_row'	=> array('user_id' => ANONYMOUS),
		);
	}

	$login = mb_convert_encoding( $username, 'Windows-1251', 'UTF-8' );
	$pass = md5( $password );
	db_safe( $login );
	db_safe( $pass );
	$check = db_fetch_row( "SELECT id, email FROM users WHERE status=1 AND login='$login' AND password='$pass'" );

        // User inactive...
        if( isset( $check['id'] ) && is_numeric( $check['id'] ) ) {
		$sql = 'SELECT user_id FROM ' . USERS_TABLE . "	WHERE username_clean = '" . $db->sql_escape(utf8_clean_string($username)) . "'";
		$result = $db->sql_query($sql);
		$uid = $db->sql_fetchrow($result);
		$db->sql_freeresult($result);

		if( !$uid ) {
			if (!function_exists('user_add')) {
				global $phpbb_root_path, $phpEx;
				include($phpbb_root_path . 'includes/functions_user.' . $phpEx);
			}

			// create the user if he does not exist yet
			user_add(array( 'username' => $username,
					'group_id' => 2,
					'user_type' => USER_NORMAL,
					'user_email' => $check['email'] )
			);

			$sql = 'SELECT user_id FROM ' . USERS_TABLE . "	WHERE username_clean = '" . $db->sql_escape(utf8_clean_string($username)) . "'";
			$result = $db->sql_query($sql);
			$uid = $db->sql_fetchrow($result);
			$db->sql_freeresult($result);
                }

		// Successful login... set user_login_attempts to zero...
		return array(
			'status'		=> LOGIN_SUCCESS,
			'error_msg'		=> false,
			'user_row'		=> array(
				'user_id' => $uid['user_id'],
				'username' => $username,
				'user_password' => $pass,
				'user_email' => $check['email'],
				'user_type' => USER_NORMAL
			)
		);
	} else {
		return array(
			'status'		=> LOGIN_ERROR_ACTIVE,
			'error_msg'		=> 'ACTIVE_ERROR',
			'user_row'		=> array('user_id' => ANONYMOUS),
		);
	}

}
?>