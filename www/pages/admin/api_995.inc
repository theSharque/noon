<?php

require_once './pages/admin/api_common.inc';
admin_require();

correct_price();
admin_json( array( 'ok' => true ) );
