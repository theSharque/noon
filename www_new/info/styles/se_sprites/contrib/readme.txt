Rename
se_sprites/imageset/en

to
se_sprites/imageset/your_board_language

=================================================================

To use custom menu:

copy
se_sprites/contrib/custom_menu.html

to
se_sprites/template/custom_menu.html

open
se_sprites/template/overall_header.html

find
					<div style="height: 4px;"></div>
					<!-- ENDIF -->
add after
<!-- INCLUDE custom_menu.html -->

Refresh your templates

===============================================================

To switch profiles from left side to right side:

rename
se_sprites/theme/content.css

to
se_sprites/theme/content-profiles-on-left.css

rename
se_sprites/theme/content-profiles-on-right.css

to
se_sprites/theme/content.css

Refresh your themes.

================================================================
If you use the mChat MOD:

open
se_sprites/template/overall_header.html

find
<!-- IF S_MCHAT_ENABLE -->
<script type="text/javascript" src="{ROOT_PATH}mchat/jquery_core_mini.js"></script>
<script type="text/javascript" src="{ROOT_PATH}mchat/jquery_cookie_mini.js"></script>
<link rel="stylesheet" href="{ROOT_PATH}mchat/mchat_prosilver.css" type="text/css" />
<!-- ENDIF -->

remove
<script type="text/javascript" src="{ROOT_PATH}mchat/jquery_core_mini.js"></script>

================================================================

Add-on

My first and probably the last phpBB modification - draggable_categories_1.0.1.zip.