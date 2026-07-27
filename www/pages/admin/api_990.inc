<?php

require_once './pages/admin/api_common.inc';
admin_require();

admin_json( array(
  'ok' => true,
  'login' => $user->login,
  'uid' => intval( $user->uid ),
) );
