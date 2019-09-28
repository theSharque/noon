<?php exit; ?>
1293206005
SELECT s.style_id, c.theme_id, c.theme_data, c.theme_path, c.theme_name, c.theme_mtime, i.*, t.template_path FROM f_styles s, f_styles_template t, f_styles_theme c, f_styles_imageset i WHERE s.style_id = 4 AND t.template_id = s.template_id AND c.theme_id = s.theme_id AND i.imageset_id = s.imageset_id
86141
a:1:{i:0;a:11:{s:8:"style_id";s:1:"4";s:8:"theme_id";s:1:"4";s:10:"theme_data";s:85752:"/*  phpBB 3.0 Style Sheet
    --------------------------------------------------------------
	Style name:		proSilver
	Based on style:	proSilver (this is the default phpBB 3 style)
	Original author:	subBlue ( http://www.subBlue.com/ )
	Modified by:		
	
	Copyright 2006 phpBB Group ( http://www.phpbb.com/ )
    --------------------------------------------------------------
*/

/* General proSilver Markup Styles
---------------------------------------- */

* {
	/* Reset browsers default margin, padding and font sizes */
	margin: 0;
	padding: 0;
}

html {
	font-size: 100%;
	/* Always show a scrollbar for short pages - stops the jump when the scrollbar appears. non-IE browsers */
	height: 101%;
}

body {
	/* Text-Sizing with ems: http://www.clagnut.com/blog/348/ */
	font-family: Verdana, Helvetica, Arial, sans-serif;
	color: #828282;
	background-color: #FFFFFF;
	/*font-size: 62.5%;			 This sets the default font size to be equivalent to 10px */
	font-size: 10px;
	margin: 0;
	padding: 15px 0;
}

h1 {
	/* Forum name */
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	margin-top: -120px;
	margin-left: 25%;
	font-weight: bold;
	font-size: 3em;
}

h2 {
	/* Forum header titles */
	font-family: "Trebuchet MS", Arial, Helvetica, sans-serif;
	font-weight: normal;
	color: #3f3f3f;
	font-size: 2em;
	margin: 0.8em 0 0.2em 0;
}

h2.solo {
	margin-bottom: 1em;
}

h3 {
	/* Sub-headers (also used as post headers, but defined later) */
	font-family: Arial, Helvetica, sans-serif;
	font-weight: bold;
	text-transform: none;
	border-bottom: none;
	margin-bottom: 3px;
	padding-bottom: 2px;
	font-size: 1.5em;
	color: #989898;
	margin-top: 20px;
}

h4 {
	/* Forum and topic list titles */
	font-family: "Trebuchet MS", Verdana, Helvetica, Arial, Sans-serif;
	font-size: 1.3em;
}

p {
	line-height: 1.3em;
	font-size: 1.1em;
	margin-bottom: 1.5em;
}

img {
	border-width: 0;
}

hr {
	/* Also see tweaks.css */
	border: 0 none #FFFFFF;
	border-top: 1px solid #CCCCCC;
	height: 1px;
	margin: 5px 0;
	display: block;
	clear: both;
}

hr.dashed {
	border-top: 1px dashed #CCCCCC;
	margin: 10px 0;
}

hr.divider {
	display: none;
}

p.right {
	text-align: right;
}

/* Border
---------------------------------------- */
.border-left { 
    background: url("{T_THEME_PATH}/images/border_left.gif") #FDFDFE repeat-y 0 0;
}

.border-right {
    background: url("{T_THEME_PATH}/images/border_right.gif") repeat-y 100% 0;
}

.border-top { 
    background: url("{T_THEME_PATH}/images/border_top.gif") repeat-x 0 0; 
}

.border-top-left {
    background: url("{T_THEME_PATH}/images/border_top_left.gif") no-repeat 0 0;
}

.border-top-right {
    background: url("{T_THEME_PATH}/images/border_top_right.gif") no-repeat 100% 0;
}

.border-bottom { 
    background: url("{T_THEME_PATH}/images/border_bottom2.gif") repeat-x 0 100%;
}

.border-left, .border-right, .border-top, .border-top-left, .border-top-right, .border-bottom { width: 100%;}

.border-bottom span {
    background: url("{T_THEME_PATH}/images/border_bottom.gif") no-repeat 0 0;
    display: block;
    height: 18px; 
}

.border-bottom span span { 
    background-position: 100% -18px;
}

.inside { 
    padding: 20px 20px 0 20px;
}

/* Main blocks
---------------------------------------- */
#wrap {
	padding: 0 15px;
	min-width: 950px;
	max-width: 1200px;
	margin: 0 auto;
}

#simple-wrap {
    background-color: #fff;
	padding: 6px 10px;
}

#page-body {
	margin: 4px 0;
	clear: both;
}

#page-footer {
	clear: both;
}

#page-footer h3 {
	margin-top: 20px;
}

p.logo {
	color: #ccc;
	font-weight: bold;
	font-size: 1.8em;	
	margin: 1% 5% 0 35%;
}

a#logo {
	display: block;
	height: 160px;
	position: relative;
}

a#logo:hover {
	margin: 0;
	padding: 0;
	text-decoration: none;
}

/* Search box
--------------------------------------------- */
#search-box {
	color: #FFFFFF;
	margin-top: 4px;
	float: right;
	text-align: right;
	white-space: nowrap; /* For Opera */
}

#search-box #keywords {
	width: 105px;
	background-color: transparent;
}

#search-box input {
	border: 0 solid transparent;
}

/* .button1 style defined later, just a few tweaks for the search button version */
#search-box input.button1 {
	padding: 1px 5px;
}

#search-box li {
	text-align: right;
	margin-top: 4px;
}

#search-box img {
	vertical-align: middle;
	margin-right: 3px;
}

/* Site description and logo */
#site-description {
}

/* Round cornered boxes and backgrounds
---------------------------------------- */
.headerbar {
}

.navbar {
	background-color: #ebebeb;
	padding: 0 10px;
}

.forabg {
	background: #b1b1b1 none repeat-x 0 0;
	margin-bottom: 4px;
	padding: 0 5px;
	clear: both;
}

.forumbg {
	background: #ebebeb none repeat-x 0 0;
	margin-bottom: 4px;
	padding: 0 5px;
	clear: both;
}

.panel {
	margin-bottom: 4px;
	padding: 0 10px;
	background-color: #f3f3f3;
	color: #3f3f3f;
}

.post {
	padding: 0 10px;
	margin-bottom: 4px;
	background-repeat: no-repeat;
	background-position: 100% 0;
}

.post:target .content {
	color: #000000;
}

.post:target h3 a {
	color: #000000;
}

.bg1	{ background-color: #F4F4F4; }
.bg2	{ background-color: #F2F2F1;  }
.bg3	{ background-color: #ECECEC; }

.rowbg {
	margin: 5px 5px 2px 5px;
}

.ucprowbg {
	background-color: #e2e2e2;
}

.fieldsbg {
	/*border: 1px #DBDEE2 solid;*/
	background-color: #eaeaea;
}

span.corners-top, span.corners-bottom, span.corners-top span, span.corners-bottom span {
	font-size: 1px;
	line-height: 1px;
	display: block;
	height: 5px;
	background-repeat: no-repeat;
}

.post span.corners-top, .post span.corners-bottom, .panel span.corners-top, .panel span.corners-bottom, .navbar span.corners-top, .navbar span.corners-bottom {margin: 0 -10px;}

span.corners-top {
	background-image: none;
	background-position: 0 0;
	margin: 0 -5px;
}

span.corners-top span {
	background-image: none;
	background-position: 100% 0;
}

span.corners-bottom {
	background-image: none;
	background-position: 0 100%;
	margin: 0 -5px;
	clear: both;
}

span.corners-bottom span {
	background-image: none;
	background-position: 100% 100%;
}

.headbg span.corners-bottom {
	margin-bottom: -1px;
}

.rules span.corners-top {
	margin: 0 -10px 5px -10px;
}

.rules span.corners-bottom {
	margin: 5px -10px 0 -10px;
}

div.rules a, div.rules strong {
	display: block;
	padding: 6px 5px 8px 35px;
}

div.rules a {float: left;}

/* Horizontal lists
----------------------------------------*/
ul.linklist {
	display: block;
	margin: 0;
}

ul.linklist li {
	display: block;
	list-style-type: none;
	float: left;
	width: auto;
	margin-right: 5px;
	font-size: 1.1em;
	line-height: 2.2em;
}

ul.linklist li.rightside, p.rightside {
	float: right;
	margin-right: 0;
	margin-left: 5px;
	text-align: right;
}

ul.navlinks {
	padding-bottom: 1px;
	margin-bottom: 1px;
	border-bottom: 1px solid #FFFFFF;
/*	font-weight: bold; */
}

ul.leftside {
	float: left;
	margin-left: 0;
	margin-right: 5px;
	text-align: left;
}

ul.rightside {
	float: right;
	margin-left: 5px;
	margin-right: -5px;
	text-align: right;
}

/* Table styles
----------------------------------------*/
table.table1 {
	/* See tweaks.css */
}

#ucp-main table.table1 {
	padding: 2px;
}

table.table1 thead th {
	font-weight: normal;
	text-transform: uppercase;
	color: #FFFFFF;
	line-height: 1.3em;
	font-size: 1em;
	padding: 0 0 4px 3px;
}

table.table1 thead th span {
	padding-left: 7px;
}

table.table1 tbody tr {
	border: 1px solid #cfcfcf;
}

table.table1 tbody tr:hover, table.table1 tbody tr.hover {
	background-color: #f6f6f6;
	color: #000;
}

table.table1 td {
	color: #6a6a6a;
	font-size: 1.1em;
}

table.table1 tbody td {
	padding: 5px;
	border-top: 1px solid #FAFAFA;
}

table.table1 tbody th {
	padding: 5px;
	border-bottom: 1px solid #000000;
	text-align: left;
	color: #333333;
	background-color: #FFFFFF;
}

/* Specific column styles */
table.table1 .name		{ text-align: left; }
table.table1 .posts		{ text-align: center !important; width: 7%; }
table.table1 .joined	{ text-align: left; width: 15%; }
table.table1 .active	{ text-align: left; width: 15%; }
table.table1 .mark		{ text-align: center; width: 7%; }
table.table1 .info		{ text-align: left; width: 30%; }
table.table1 .info div	{ width: 100%; white-space: normal; overflow: hidden; }
table.table1 .autocol	{ line-height: 2em; white-space: nowrap; }
table.table1 thead .autocol { padding-left: 1em; }

table.table1 span.rank-img {
	float: right;
	width: auto;
}

table.info td {
	padding: 3px;
}

table.info tbody th {
	padding: 3px;
	text-align: right;
	vertical-align: top;
	color: #000000;
	font-weight: normal;
}

.forumbg table.table1 {
	margin: 0 -2px -1px -1px;
}

/* Misc layout styles
---------------------------------------- */
/* column[1-2] styles are containers for two column layouts 
   Also see tweaks.css */
.column1 {
	float: left;
	clear: left;
	width: 49%;
}

.column2 {
	float: right;
	clear: right;
	width: 49%;
}

/* General classes for placing floating blocks */
.left-box {
	float: left;
	width: auto;
	text-align: left;
}

.section-memberlist .left-box {
	margin-top: 50px;
	float: left;
	width: auto;
	text-align: left;
}

.right-box {
	float: right;
	width: auto;
	text-align: right;
}

dl.details {
	/*font-family: "Lucida Grande", Verdana, Helvetica, Arial, sans-serif;*/
	font-size: 1.1em;
}

dl.details dt {
	float: left;
	clear: left;
	width: 30%;
	text-align: right;
	color: #000000;
	display: block;
}

dl.details dd {
	margin-left: 0;
	padding-left: 5px;
	margin-bottom: 5px;
	color: #828282;
	float: left;
	width: 65%;
}

/* Pagination
---------------------------------------- */
.pagination {
	height: 1%; /* IE tweak (holly hack) */
	width: auto;
	text-align: right;
	margin-top: 5px;
	float: right;
}

.pagination span.page-sep {
	display: none;
}

li.pagination {
	margin-top: 0;
}

.pagination strong, .pagination b {
	font-weight: normal;
}

.pagination span strong {
	padding: 0 2px;
	margin: 0 2px;
	font-weight: normal;
	color: #FFFFFF;
	background-color: #bfbfbf;
	border: 1px solid #bfbfbf;
	font-size: 0.9em;
}

.pagination span a, .pagination span a:link, .pagination span a:visited, .pagination span a:active {
	font-weight: normal;
	text-decoration: none;
	color: #747474;
	margin: 0 2px;
	padding: 0 2px;
	background-color: #eeeeee;
	border: 1px solid #bababa;
	font-size: 0.9em;
	line-height: 1.5em;
}

.pagination span a:hover {
	border-color: #d2d2d2;
	background-color: #d2d2d2;
	color: #FFF;
	text-decoration: none;
}

.pagination img {
	vertical-align: middle;
}

/* Pagination in viewforum for multipage topics */
.row .pagination {
	display: block;
	float: right;
	width: auto;
	margin-top: 0;
	padding: 1px 0 1px 15px;
	font-size: 0.9em;
	background: none 0 50% no-repeat;
}

.row .pagination span a, li.pagination span a {
	background-color: #FFFFFF;
}

.row .pagination span a:hover, li.pagination span a:hover {
	background-color: #d2d2d2;
}

/* Miscellaneous styles
---------------------------------------- */
#forum-permissions {
	float: right;
	width: auto;
	padding-left: 5px;
	margin-left: 5px;
	margin-top: 10px;
	text-align: right;
}

.copyright {
	padding: 5px;
	text-align: center;
	color: #555555;
	clear: both;
}

.small {
	font-size: 0.9em !important;
}

.titlespace {
	margin-bottom: 15px;
}

.headerspace {
	margin-top: 0;
}

.error {
	color: #bcbcbc;
	font-weight: bold;
	font-size: 1em;
}

.reported {
	background-color: #f7f7f7;
}

li.reported:hover {
	background-color: #ececec;
}

div.rules {
	background-color: #ececec;
	color: #bcbcbc;
	padding: 0 10px;
	margin: 10px 0;
	font-size: 1.1em;
}

div.rules ul, div.rules ol {
	margin-left: 30px;
}

p.rules {
	background-color: #ececec;
	background-image: none;
	padding: 5px;
	margin-top: 10px;
}

p.rules img {
	vertical-align: middle;
	padding-top: 5px;
}

p.rules a {
	vertical-align: middle;
	clear: both;
}

#top {
	position: absolute;
	top: -20px;
}

.clear {
	display: block;
	clear: both;
	font-size: 1px;
	line-height: 1px;
	background: transparent;
}
/* proSilver Link Styles
---------------------------------------- */

/* Links adjustment to correctly display an order of rtl/ltr mixed content */
a {
	direction: ltr;
	unicode-bidi: embed;
}

a:link	{ color: #053F98; text-decoration: none; }
a:visited	{ color: #105289; text-decoration: none; }
a:hover	{ color: #0353CC; text-decoration: underline; }
a:active	{ color: #D31141; text-decoration: none; }

/* Coloured usernames */
.username-coloured {
	font-weight: bold;
	display: inline !important;
	padding: 0 !important;
}

/* Links on gradient backgrounds */
#search-box a:link, .navbg a:link {
	color: #FFFFFF;
}

#search-box a:visited, .navbg a:visited {
	color: #FFFFFF;
}

.forumbg .header a:visited, .forabg .header a:visited, th a:visited, .forumbg .header a:link, .forabg .header a:link, th a:link, .forumbg .header a:visited, .forabg .header a:visited, th a:visited {
	color: #ddd;
}

#search-box a:hover, .navbg a:hover {
	color: #A8D8FF;
}

.forumbg .header a:hover, .forabg .header a:hover, th a:hover, .forumbg .header a:active, .forabg .header a:active, th a:active {
	color: #f1f1f1;
	text-decoration: none;
}

#search-box a:active, .navbg a:active {
	color: #C8E6FF;
}

/* Links for forum/topic lists */
a.forumtitle {
	font-family: "Trebuchet MS", Helvetica, Arial, Sans-serif;
	font-size: 1.2em;
	font-weight: bold;
	color: #053F98;
	text-decoration: none;
}

/* a.forumtitle:visited { color: #898989; } */

a.forumtitle:hover {
	color: #0353CC;
	text-decoration: underline;
}

a.forumtitle:active {
	color: #D31141;
}

a.topictitle {
	font-family: "Trebuchet MS", Helvetica, Arial, Sans-serif;
	font-size: 1.2em;
	font-weight: bold;
	color: #053F98;
	text-decoration: none;
}

/* a.topictitle:visited { color: #d2d2d2; } */

a.topictitle:hover {
	color: #0353CC;
	text-decoration: underline;
}

a.topictitle:active {
	color: #D31141;
}

/* Post body links */
.postlink {
	text-decoration: none;
	color: #368AD2;
	border-bottom: 1px solid #0353CC;
	padding-bottom: 0;
}

.postlink:visited {
	color: #5D8FBD;
	border-bottom-style: dotted;
	border-bottom-color: #666666;
}

.postlink:active {
	color: #368AD2;
}

.postlink:hover {
	background-color: #f6f6f6;
	text-decoration: none;
	color: #D0E4F6;
}

.signature a, .signature a:visited, .signature a:active, .signature a:hover {
	border: none;
	text-decoration: underline;
	background-color: transparent;
}

/* Profile links */
.postprofile a:link, .postprofile a:active, .postprofile a:visited, .postprofile dt.author a {
	font-weight: bold;
	color: #053F98;
	text-decoration: none;
}

.postprofile a:hover, .postprofile dt.author a:hover {
	text-decoration: underline;
	color: #0353CC;
}


/* Profile searchresults */	
.search .postprofile a {
	color: #053F98;
	text-decoration: none; 
	font-weight: normal;
}

.search .postprofile a:hover {
	color: #0353CC;
	text-decoration: underline; 
}

/* Back to top of page */
.back2top {
	clear: both;
	height: 11px;
	text-align: right;
}

a.top {
	background: none no-repeat top left;
	text-decoration: none;
	width: {IMG_ICON_BACK_TOP_WIDTH}px;
	height: {IMG_ICON_BACK_TOP_HEIGHT}px;
	display: block;
	float: right;
	overflow: hidden;
	letter-spacing: 1000px;
	text-indent: 11px;
}

a.top2 {
	background: none no-repeat 0 50%;
	text-decoration: none;
	padding-left: 15px;
}

/* Arrow links  */
a.up		{ background: none no-repeat left center; }
a.down		{ background: none no-repeat right center; }
a.left		{ background: none no-repeat 3px 60%; }
a.right		{ background: none no-repeat 95% 60%; }

a.up, a.up:link, a.up:active, a.up:visited {
	padding-left: 10px;
	text-decoration: none;
	border-bottom-width: 0;
}

a.up:hover {
	background-position: left top;
	background-color: transparent;
}

a.down, a.down:link, a.down:active, a.down:visited {
	padding-right: 10px;
}

a.down:hover {
	background-position: right bottom;
	text-decoration: none;
}

a.left, a.left:active, a.left:visited {
	padding-left: 12px;
}

a.left:hover {
	color: #d2d2d2;
	text-decoration: none;
	background-position: 0 60%;
}

a.right, a.right:active, a.right:visited {
	padding-right: 12px;
}

a.right:hover {
	color: #d2d2d2;
	text-decoration: none;
	background-position: 100% 60%;
}

/* invisible skip link, used for accessibility  */
.skiplink {
	position: absolute;
	left: -999px;
	width: 990px;
}

/* Feed icon in forumlist_body.html */
a.feed-icon-forum {
	float: right;
	margin: 3px;
}
/* proSilver Content Styles
---------------------------------------- */

ul.topiclist {
	display: block;
	list-style-type: none;
	margin: 0;
}

ul.forums {
	background: #f9f9f9 none repeat-x 0 0;
}

ul.topiclist li {
	display: block;
	list-style-type: none;
	color: #777777;
	margin: 0;
}

ul.topiclist dl {
	position: relative;
}

ul.topiclist li.row dl {
	padding: 2px 0;
}

ul.topiclist dt {
	display: block;
	float: left;
	width: 50%;
	font-size: 1.1em;
	padding-left: 5px;
	padding-right: 5px;
}

ul.topiclist dd {
	display: block;
	float: left;
	border-left: 1px solid #f9f9f9;
	padding: 4px 0;
}

ul.topiclist dfn {
	/* Labels for post/view counts */
	position: absolute;
	left: -999px;
	width: 990px;
}

ul.topiclist li.row dt a.subforum {
	background-image: none;
	background-position: 0 50%;
	background-repeat: no-repeat;
	position: relative;
	white-space: nowrap;
	padding: 0 0 0 12px;
}

.forum-image {
	float: left;
	padding-top: 5px;
	margin-right: 5px;
}

li.row {
	border-top: 1px solid #FFFFFF;
	border-bottom: 1px solid #8f8f8f;
}

li.row strong {
	font-weight: normal;
	color: #000000;
}

/*
li.row:hover {
	background-color: #f6f6f6;
}
*/

li.row:hover dd {
	border-left-color: #CCCCCC;
}

li.header dt, li.header dd {
	line-height: 1em;
	border-left-width: 0;
	margin: 2px 0 4px 0;
	color: #ddd;
	padding-top: 1px;
	padding-bottom: 3px;
	font-size: 1.1em;
	font-family: Arial, Helvetica, sans-serif;
}

li.header dt {
	text-align: center;
	font-weight: bold;
	text-transform: uppercase;
}

li.header dd {
	margin-left: 1px;
	font-weight: bold;
}

li.header dl.icon {
	min-height: 0;
}

li.header dl.icon dt {
	/* Tweak for headers alignment when folder icon used */
	padding-left: 0;
	padding-right: 50px;
}

/* Forum list column styles */
dl.icon {
	min-height: 35px;
	background-position: 10px 50%;		/* Position of folder icon */
	background-repeat: no-repeat;
}

dl.icon dt {
	padding-left: 45px;					/* Space for folder icon */
	background-repeat: no-repeat;
	background-position: 5px 95%;		/* Position of topic icon */
}

dd.posts, dd.topics, dd.views {
	width: 8%;
	text-align: center;
	line-height: 2.2em;
	font-size: 1.2em;
}

/* List in forum description */
dl.icon dt ol,
dl.icon dt ul {
	list-style-position: inside;
	margin-left: 1em;
}

dl.icon dt li {
	display: list-item;
	list-style-type: inherit;
}

dd.lastpost {
	width: 25%;
	font-size: 1.1em;
}

dd.redirect {
	font-size: 1.1em;
	line-height: 2.5em;
}

dd.moderation {
	font-size: 1.1em;
}

dd.lastpost span, ul.topiclist dd.searchby span, ul.topiclist dd.info span, ul.topiclist dd.time span, dd.redirect span, dd.moderation span {
	display: block;
	padding-left: 5px;
}

dd.time {
	width: auto;
	line-height: 200%;
	font-size: 1.1em;
}

dd.extra {
	width: 12%;
	line-height: 200%;
	text-align: center;
	font-size: 1.1em;
}

dd.mark {
	float: right !important;
	width: 9%;
	text-align: center;
	line-height: 200%;
	font-size: 1.2em;
}

dd.info {
	width: 30%;
}

dd.option {
	width: 15%;
	line-height: 200%;
	text-align: center;
	font-size: 1.1em;
}

dd.searchby {
	width: 47%;
	font-size: 1.1em;
	line-height: 1em;
}

ul.topiclist dd.searchextra {
	margin-left: 5px;
	padding: 0.2em 0;
	font-size: 1.1em;
	color: #333333;
	border-left: none;
	clear: both;
	width: 98%;
	overflow: hidden;
}

/* Container for post/reply buttons and pagination */
.topic-actions {
	margin-bottom: 3px;
	font-size: 1.1em;
	height: 28px;
	min-height: 28px;
}
div[class].topic-actions {
	height: auto;
}

/* Post body styles
----------------------------------------*/
.postbody {
	padding: 0;
	line-height: 1.48em;
	color: #333333;
	width: 76%;
	float: right;
}

.postbody .content {margin-top: 12px;}

#postform  .postbody, #viewprofile .postbody  {float: none; width: 99%;}

.postbody .ignore {
	font-size: 1.1em;
}

.postbody h3.first {
	/* The first post on the page uses this */
	font-size: 1.5em;
}

.postbody h3 {
	/* Postbody requires a different h3 format - so change it here */
	font-size: 1.5em;
	padding: 0;
	margin: 0 0 0.2em 0 !important;
	text-transform: none;
	border: none;
	font-family: "Trebuchet MS", Verdana, Helvetica, Arial, sans-serif;
	line-height: 125%;
}

.search .postbody h3, #preview .postbody h3, .section-posting .postbody h3 {margin: 0.6em 0 1.3em 0 !important;}
#topicreview .postbody h3 {margin: 0.6em 0 0.3em 0 !important;}

.postbody h3 img {
	/* Also see tweaks.css */
	vertical-align: bottom;
}

.postbody .content {
	font-size: 1.3em;
}

.search .postbody {
	width: 76%;
}

/* Topic review panel
----------------------------------------*/
#review {
	margin-top: 2em;
}

#topicreview {
	padding-right: 5px;
	overflow: auto;
	height: 300px;
}

#topicreview .postbody {
	width: auto;
	float: none;
	margin: 0;
	height: auto;
}

#topicreview .post {
	height: auto;
}

#topicreview h2 {
	border-bottom-width: 0;
}

.post-ignore .postbody {
	display: none;
}

/* MCP Post details
----------------------------------------*/
#post_details {
   /* This will only work in IE7+, plus the others */
   overflow: auto;
   max-height: 300px;
}

#expand {
   clear: both;
}

/* Content container styles
----------------------------------------*/
.content {
	min-height: 3em;
	overflow: hidden;
	line-height: 1.4em;
	font-family: "Lucida Grande", "Trebuchet MS", Verdana, Helvetica, Arial, sans-serif;
	font-size: 1em;
	color: #333333;
	padding-bottom: 1px;
}

.panel h2, .content h2 {
	font-weight: normal;
	color: #ddd;
	border-bottom: none;
	font-size: 1.6em;
	margin: 0.7em 0 1.5em 0;
}

.panel#message h2 {margin: 0.5em 0 1.5em 0;}

.panel h3 {
	margin: 0.8em 0 1.2em 0;
}

.panel p {
	font-size: 1.2em;
	margin-bottom: 1em;
	line-height: 1.4em;
}

.content p {
	font-family: "Lucida Grande", "Trebuchet MS", Verdana, Helvetica, Arial, sans-serif;
	font-size: 1.2em;
	margin-bottom: 1em;
	line-height: 1.4em;
}

dl.faq {
	font-family: "Lucida Grande", Verdana, Helvetica, Arial, sans-serif;
	font-size: 1.1em;
	margin-top: 0.2em;
	margin-bottom: 1em;
	line-height: 1.4em;
}

dl.faq dt {
	font-weight: bold;
	color: #333333;
}

.content dl.faq {
	font-size: 1.2em;
	margin-bottom: 0.5em;
}

.content li {
	list-style-type: inherit;
}

.content ul, .content ol {
	margin-bottom: 1em;
	margin-left: 3em;
}

.posthilit {
	background-color: #f3f3f3;
	color: #BCBCBC;
	padding: 0 2px 1px 2px;
}

.announce, .unreadpost {
	/* Highlight the announcements & unread posts box */
	border-left-color: #BCBCBC;
	border-right-color: #BCBCBC;
}

/* Post author */
p.author {
	margin: 0 15em 0.6em 0;
	padding: 0 0 5px 0;
	font-family: Verdana, Helvetica, Arial, sans-serif;
	font-size: 1em;
	line-height: 1.2em;
}

/* Post signature */
.signature {
	margin-top: 1.5em;
	padding-top: 0.2em;
	font-size: 1.1em;
	border-top: 1px solid #CCCCCC;
	clear: left;
	line-height: 140%;
	overflow: hidden;
	width: 100%;
}

dd .signature {
	margin: 0;
	padding: 0;
	clear: none;
	border: none;
}

.signature li {
	list-style-type: inherit;
}

.signature ul, .signature ol {
	margin-bottom: 1em;
	margin-left: 3em;
}

/* Post noticies */
.notice {
	font-family: "Lucida Grande", Verdana, Helvetica, Arial, sans-serif;
	width: auto;
	margin-top: 1.5em;
	margin-bottom: 1px;
	padding: 0.4em;
	font-size: 1em;
	border: 2px solid #CCCCCC;
	clear: left;
	line-height: 130%;
}

/* Jump to post link for now */
ul.searchresults {
	list-style: none;
	text-align: right;
	clear: both;
}

/* BB Code styles
----------------------------------------*/
/* Quote block */
blockquote {
	background: #ebebeb none 6px 8px no-repeat;
	border: 1px solid #dbdbdb;
	font-size: 0.95em;
	margin: 0.5em 1px 1px 25px;
	overflow: hidden;
	padding: 5px;
}

blockquote blockquote {
	/* Nested quotes */
	background-color: #bababa;
	font-size: 1em;
	margin: 0.5em 1px 0 15px;	
}

blockquote blockquote blockquote {
	/* Nested quotes */
	background-color: #e4e4e4;
}

blockquote cite {
	/* Username/source of quoter */
	font-style: normal;
	font-weight: bold;
	margin-left: 20px;
	display: block;
	font-size: 0.9em;
}

blockquote cite cite {
	font-size: 1em;
}

blockquote.uncited {
	padding-top: 25px;
}

/* Code block */
dl.codebox {
	margin-bottom: 1px;
	padding: 5px;
	background-color: #FFFFFF;
	border: 1px solid #d8d8d8;
	font-size: 1em;
}

dl.codebox dt {
	text-transform: uppercase;
	border-bottom: 1px solid #CCCCCC;
	margin-bottom: 3px;
	font-size: 0.8em;
	font-weight: bold;
	display: block;
}

blockquote dl.codebox {
	margin-left: 0;
}

dl.codebox code {
	/* Also see tweaks.css */
	overflow: auto;
	display: block;
	height: auto;
	max-height: 200px;
	white-space: normal;
	padding-top: 5px;
	font: 0.9em Monaco, "Andale Mono","Courier New", Courier, mono;
	line-height: 1.3em;
	color: #8b8b8b;
	margin: 2px 0;
}

.syntaxbg		{ color: #FFFFFF; }
.syntaxcomment	{ color: #000000; }
.syntaxdefault	{ color: #bcbcbc; }
.syntaxhtml		{ color: #000000; }
.syntaxkeyword	{ color: #585858; }
.syntaxstring	{ color: #a7a7a7; }

/* Attachments
----------------------------------------*/
.attachbox {
	float: left;
	width: auto; 
	margin: 5px 5px 5px 0;
	padding: 6px;
	background-color: #FFFFFF;
	border: 1px dashed #d8d8d8;
	clear: left;
}

.pm-message .attachbox {
	background-color: #f3f3f3;
}

.attachbox dt {
	font-family: Arial, Helvetica, sans-serif;
	text-transform: uppercase;
}

.attachbox dd {
	margin-top: 4px;
	padding-top: 4px;
	clear: left;
	border-top: 1px solid #d8d8d8;
}

.attachbox dd dd {
	border: none;
}

.attachbox p {
	line-height: 110%;
	color: #666666;
	font-weight: normal;
	clear: left;
}

.attachbox p.stats
{
	line-height: 110%;
	color: #666666;
	font-weight: normal;
	clear: left;
}

.attach-image {
	margin: 3px 0;
	width: 100%;
	max-height: 350px;
	overflow: auto;
}

.attach-image img {
	border: 1px solid #999999;
/*	cursor: move; */
	cursor: default;
}

/* Inline image thumbnails */
div.inline-attachment dl.thumbnail, div.inline-attachment dl.file {
	display: block;
	margin-bottom: 4px;
}

div.inline-attachment p {
	font-size: 100%;
}

dl.file {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	display: block;
}

dl.file dt {
	text-transform: none;
	margin: 0;
	padding: 0;
	font-weight: bold;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}

dl.file dd {
	color: #666666;
	margin: 0;
	padding: 0;	
}

dl.thumbnail img {
	padding: 3px;
	border: 1px solid #666666;
	background-color: #FFF;
}

dl.thumbnail dd {
	color: #666666;
	font-style: italic;
	font-family: Verdana, Arial, Helvetica, sans-serif;
}

.attachbox dl.thumbnail dd {
	font-size: 100%;
}

dl.thumbnail dt a:hover {
	background-color: #EEEEEE;
}

dl.thumbnail dt a:hover img {
	border: 1px solid #d2d2d2;
}

/* Post poll styles
----------------------------------------*/
fieldset.polls {
	font-family: "Trebuchet MS", Verdana, Helvetica, Arial, sans-serif;
}

fieldset.polls dl {
	margin-top: 5px;
	border-top: 1px dotted #e2e2e2;
	padding: 5px 0 0 0;
	line-height: 120%;
	color: #666666;
}

fieldset.polls dl.voted {
	font-weight: bold;
	color: #000000;
}

fieldset.polls dt {
	text-align: left;
	float: left;
	display: block;
	width: 30%;
	border-right: none;
	padding: 0;
	margin: 0;
	font-size: 1.1em;
}

fieldset.polls dd {
	float: left;
	width: 10%;
	border-left: none;
	padding: 0 5px;
	margin-left: 0;
	font-size: 1.1em;
}

fieldset.polls dd.resultbar {
	width: 50%;
}

fieldset.polls dd input {
	margin: 2px 0;
}

fieldset.polls dd div {
	text-align: right;
	font-family: Arial, Helvetica, sans-serif;
	color: #FFFFFF;
	font-weight: bold;
	padding: 0 2px;
	overflow: visible;
	min-width: 2%;
}

.pollbar1 {
	background-color: #aaaaaa;
	border-bottom: 1px solid #747474;
	border-right: 1px solid #747474;
}

.pollbar2 {
	background-color: #bebebe;
	border-bottom: 1px solid #8c8c8c;
	border-right: 1px solid #8c8c8c;
}

.pollbar3 {
	background-color: #D1D1D1;
	border-bottom: 1px solid #aaaaaa;
	border-right: 1px solid #aaaaaa;
}

.pollbar4 {
	background-color: #e4e4e4;
	border-bottom: 1px solid #bebebe;
	border-right: 1px solid #bebebe;
}

.pollbar5 {
	background-color: #f8f8f8;
	border-bottom: 1px solid #D1D1D1;
	border-right: 1px solid #D1D1D1;
}

/* Poster profile block
----------------------------------------*/
.postprofile {
	/* Also see tweaks.css */
	margin: 50px 0 10px 0;
	min-height: 80px;
	color: #666666;
	border-right: 1px solid #eaeaea;
	width: 22%;
	float: left;
	display: inline;
}

#cp-main dl.postprofile {margin: 2px 0 10px 0;}

.pm .postprofile {
	border-right: 1px solid #DDDDDD;
}

.postprofile dd, .postprofile dt {
	line-height: 1.2em;
	margin-right: 8px;
}

.postprofile strong {
	font-weight: normal;
	color: #000000;
}

.avatar {
	border: none;
	margin-bottom: 3px;
}

/* Poster profile used by search*/
.search .postprofile {
	width: 22%;
}

/* pm list in compose message if mass pm is enabled */
dl.pmlist dt {
	width: 60% !important;
}

dl.pmlist dt textarea {
	width: 95%;
}

dl.pmlist dd {
	margin-left: 61% !important;
	margin-bottom: 2px;
}
/* proSilver Button Styles
---------------------------------------- */

/* Rollover buttons
   Based on: http://wellstyled.com/css-nopreload-rollovers.html
----------------------------------------*/
.buttons {
	float: left;
	width: auto;
	height: auto;
}

.buttons div {
	float: left;
	height: 25px;
	margin: 0 5px 0 0;
	border-left: 2px solid #B1B1B1;
}

.buttons div.reply-icon:hover, .buttons div.post-icon:hover, .buttons div.locked-icon:hover, .buttons div.pmreply-icon:hover, .buttons div.newpm-icon:hover, .buttons div.forwardpm-icon:hover {background-position: 100% 100%;}
#cp-main  .panel .newpm-icon a, #cp-main  .panel .pmreply-icon a, #cp-main  .panel .forwardpm-icon a {padding-top: 4px; color: #ccc; font-size: 1.1em;}
#cp-main  .panel .newpm-icon a:hover, #cp-main  .panel .pmreply-icon a:hover, #cp-main  .panel .forwardpm-icon a:hover, .buttons a:hover {color: #ddd;}

.buttons div a {
	display: block;
	position: relative;
	overflow: hidden;
	padding: 3px 35px 3px 5px;
}

.buttons a:link, .buttons a:visited, .buttons a:active {color: #ccc; font: 700 1.1em "Trebuchet MS"; text-decoration: none;}
.buttons a:hover {color: #ddd;}
.buttons div a:hover span	{background-position: 0 100%;}

/* Sub-header (navigation bar)
--------------------------------------------- */
a.print, a.sendemail, a.fontsize {
	display: block;
	overflow: hidden;
	text-indent: -5000px;
	text-align: left;
	background-repeat: no-repeat;
}

a.print {
	background-image: none;
	width: 22px;
}

a.sendemail {
	background-image: none;
	width: 22px;
}

a.fontsize {
	background-image: none;
	width: 22px;
}

a.fontsize:hover {
	background-position: 0 -20px;
	text-decoration: none;
}

/* Icon images
---------------------------------------- */
.sitehome, .icon-faq, .icon-members, .icon-home, .icon-ucp, .icon-register, .icon-logout,
.icon-bookmark, .icon-bump, .icon-subscribe, .icon-unsubscribe, .icon-pages, .icon-search {
	background-position: 0 50%;
	background-repeat: no-repeat;
	background-image: none;
	padding: 1px 0 0 17px;
}

/* Poster profile icons
----------------------------------------*/
ul.profile-icons {
	padding-top: 10px;
	list-style: none;
}

.postbody ul.profile-icons {margin-top: 8px;}
#topicreview ul.profile-icons, .section-ucp ul.profile-icons, .section-mcp ul.profile-icons {margin-top: 0;}

ul.profile-icons li {
	float: left;
	margin: 0 6px 3px 0;
	background-position: 0 100%;
}

ul.profile-icons li a {
	display: block;
	width: 100%;
	height: 100%;
	background-position: 0 0;
}

ul.profile-icons li.edit-icon a, ul.profile-icons li.quote-icon a {
	width: auto;
	height: 20px;
}

.edit-icon a span, .quote-icon a span {display: block; padding: 3px 5px 3px 23px; font: 700 1em Verdana; text-decoration: none; color: #ccc;}
.edit-icon a:hover span, .quote-icon a:hover span {color: #ddd;}
.delete-icon a span, .report-icon a span, .info-icon a span, .warn-icon a span, .pm-icon a span, .email-icon a span, .aim-icon a span, .yahoo-icon a span, .web-icon a span, .msnm-icon a span, .icq-icon a span, .jabber-icon a span {display:none;}
ul.profile-icons li a:hover {background: none;}

/* Positioning of moderator icons */
.postbody ul.profile-icons {
	float: right;
	width: auto;
	padding: 0;
}

.postbody ul.profile-icons li {
	margin: 0 3px;
}

/* Profile & navigation icons */
.email-icon, .email-icon a		{ background: none top left no-repeat; }
.aim-icon, .aim-icon a			{ background: none top left no-repeat; }
.yahoo-icon, .yahoo-icon a		{ background: none top left no-repeat; }
.web-icon, .web-icon a			{ background: none top left no-repeat; }
.msnm-icon, .msnm-icon a			{ background: none top left no-repeat; }
.icq-icon, .icq-icon a			{ background: none top left no-repeat; }
.jabber-icon, .jabber-icon a		{ background: none top left no-repeat; }
.pm-icon, .pm-icon a				{ background: none top left no-repeat; }
.quote-icon, .quote-icon a 		{background: url("{T_THEME_PATH}/images/bg_edit_quote.gif") 0 0 no-repeat;}
.quote-icon, .quote-icon a:hover {background-position: 0 100%;}

/* Moderator icons */
.report-icon, .report-icon a		{ background: none top left no-repeat; }
.warn-icon, .warn-icon a			{ background: none top left no-repeat; }
.edit-icon, .edit-icon a			{background: url("{T_THEME_PATH}/images/bg_edit_quote.gif") 0 0 no-repeat;}
.edit-icon, .edit-icon a:hover	{background-position: 0 100%;}
.delete-icon, .delete-icon a		{ background: none top left no-repeat; }
.info-icon, .info-icon a			{ background: none top left no-repeat; }

/* Set profile icon dimensions */
ul.profile-icons li.email-icon	{ width: {IMG_ICON_CONTACT_EMAIL_WIDTH}px; height: {IMG_ICON_CONTACT_EMAIL_HEIGHT}px; }
ul.profile-icons li.aim-icon	{ width: {IMG_ICON_CONTACT_AIM_WIDTH}px; height: {IMG_ICON_CONTACT_AIM_HEIGHT}px; }
ul.profile-icons li.yahoo-icon	{ width: {IMG_ICON_CONTACT_YAHOO_WIDTH}px; height: {IMG_ICON_CONTACT_YAHOO_HEIGHT}px; }
ul.profile-icons li.web-icon	{ width: {IMG_ICON_CONTACT_WWW_WIDTH}px; height: {IMG_ICON_CONTACT_WWW_HEIGHT}px; }
ul.profile-icons li.msnm-icon	{ width: {IMG_ICON_CONTACT_MSNM_WIDTH}px; height: {IMG_ICON_CONTACT_MSNM_HEIGHT}px; }
ul.profile-icons li.icq-icon	{ width: {IMG_ICON_CONTACT_ICQ_WIDTH}px; height: {IMG_ICON_CONTACT_ICQ_HEIGHT}px; }
ul.profile-icons li.jabber-icon	{ width: {IMG_ICON_CONTACT_JABBER_WIDTH}px; height: {IMG_ICON_CONTACT_JABBER_HEIGHT}px; }
ul.profile-icons li.pm-icon		{ width: 28px; height: 20px; }
ul.profile-icons li.report-icon	{ width: {IMG_ICON_POST_REPORT_WIDTH}px; height: {IMG_ICON_POST_REPORT_HEIGHT}px; }
ul.profile-icons li.delete-icon	{ width: {IMG_ICON_POST_DELETE_WIDTH}px; height: {IMG_ICON_POST_DELETE_HEIGHT}px; }
ul.profile-icons li.info-icon	{ width: {IMG_ICON_POST_INFO_WIDTH}px; height: {IMG_ICON_POST_INFO_HEIGHT}px; }
ul.profile-icons li.warn-icon	{ width: {IMG_ICON_USER_WARN_WIDTH}px; height: {IMG_ICON_USER_WARN_HEIGHT}px; }

/* Fix profile icon default margins */
ul.profile-icons li.edit-icon	{margin: 0 0 0 3px; border-right: 1px solid #999;}
ul.profile-icons li.quote-icon	{margin: 0; border-right: 1px solid #999;}
#topicreview ul.profile-icons li.quote-icon {margin-left: 10px;}
ul.profile-icons li.info-icon, ul.profile-icons li.report-icon	{ margin: 0 3px 0 0; }
/* proSilver Control Panel Styles
---------------------------------------- */


/* Main CP box
----------------------------------------*/
#cp-menu {
	float:left;
	width: 19%;
	margin-top: 1em;
	margin-bottom: 5px;
}

#cp-main {
	float: left;
	width: 81%;
	margin-top: 26px;
}

#cp-main .content {
	padding: 0;
}

#cp-main h3, #cp-main hr, #cp-menu hr {
	border-color: #bfbfbf;
}

#cp-main .panel p {
	font-size: 1.1em;
}

#cp-main .panel ol {
	margin-left: 2em;
	font-size: 1.1em;
}

#cp-main .panel li.row {
	border-bottom: 1px solid #cbcbcb;
	border-top: 1px solid #F9F9F9;
}

ul.cplist {
	margin-bottom: 5px;
	border-top: 1px solid #cbcbcb;
}

#cp-main .panel li.header dd, #cp-main .panel li.header dt {
	color: #000000;
	margin-bottom: 2px;
}

#cp-main table.table1 {
	margin-bottom: 1em;
}

#cp-main table.table1 thead th {
	color: #333333;
	font-weight: bold;
	border-bottom: 1px solid #333333;
	padding: 5px;
}

#cp-main table.table1 tbody th {
	font-style: italic;
	background-color: transparent !important;
	border-bottom: none;
}

#cp-main .pagination {
	float: right;
	width: auto;
	padding-top: 1px;
}

#cp-main .postbody p {
	font-size: 1.1em;
}

#cp-main .pm-message {
	border: 1px solid #e2e2e2;
	margin: 10px 0;
	background-color: #FFFFFF;
	width: auto;
	float: none;
}

.pm-message h2 {
	padding-bottom: 5px;
}

#cp-main .postbody h3, #cp-main .box2 h3 {
	margin-top: 0;
}

#cp-main .buttons {
	margin-left: 0;
}

#cp-main ul.linklist {
	margin: 0;
}

/* MCP Specific tweaks */
.mcp-main .postbody {
	width: 100%;
}

/* CP tabbed menu
----------------------------------------*/
#tabs {
	line-height: normal;
	margin: 20px 0 -28px 9px;
	min-width: 570px;
}

.section-posting #tabs {
	margin: 7px 0 -28px 9px;
}

#tabs ul {
	margin:0;
	padding: 0;
	list-style: none;
}

#tabs li {
	display: inline;
	margin: 0;
	padding: 0;
	font-size: 1em;
	font-weight: bold;
}

#tabs a {
	float: left;
	margin: 0 1px 0 0;
	padding: 0 0 0 5px;
	text-decoration: none;
	position: relative;
	cursor: pointer;
}

#tabs a span {
	float: left;
	display: block;
	padding: 6px 10px 6px 5px;
	color: #828282;
	white-space: nowrap;
}

#tabs .activetab a span {
	padding-bottom: 6px;
}

/* Mini tabbed menu used in MCP
----------------------------------------*/
#minitabs {
	line-height: normal;
	margin: -20px 7px 0 0;
}

#minitabs ul {
	margin:0;
	padding: 0;
	list-style: none;
}

#minitabs li {
	display: block;
	float: right;
	padding: 0 10px 4px 10px;
	font-size: 1em;
	font-weight: bold;
	background-color: #f2f2f2;
	margin-left: 2px;
}

#minitabs a {
}

#minitabs a:hover {
	text-decoration: none;
}

#minitabs li.activetab {
	background-color: #F9F9F9;
}

#minitabs li.activetab a, #minitabs li.activetab a:hover {
	color: #333333;
}

/* UCP navigation menu
----------------------------------------*/
/* Container for sub-navigation list */
#navigation {
	width: 100%;
	padding-top: 65px;
}

#navigation ul {
	list-style:none;
}

/* Default list state */
#navigation li {
	margin: 1px 0;
	padding: 0;
	font-weight: bold;
	display: inline;
}

/* Link styles for the sub-section links */
#navigation a {
	display: block;
	padding: 5px;
	margin: 1px 0;
	text-decoration: none;
	font-weight: bold;
	color: #333;
	background: #cfcfcf none repeat-y 100% 0;
}

#navigation a:hover {
	text-decoration: none;
	background-color: #c6c6c6;
	color: #bcbcbc;
	background-image: none;
}

#navigation #active-subsection a {
	display: block;
	color: #d3d3d3;
	background-color: #F9F9F9;
	background-image: none;
}

#navigation #active-subsection a:hover {
	color: #d3d3d3;
}

/* Preferences pane layout
----------------------------------------*/
#cp-main h2 {
	border-bottom: none;
	padding: 0;
	margin-left: 10px;
	margin-bottom: 0.5em;
	color: #333333;
}

#cp-main .panel {
	background-color: #F9F9F9;
}

#cp-main .pm {
	background-color: #FFFFFF;
}

#cp-main span.corners-top, #cp-menu span.corners-top {
	background-image: none;
}

#cp-main span.corners-top span, #cp-menu span.corners-top span {
	background-image: none;
}

#cp-main span.corners-bottom, #cp-menu span.corners-bottom {
	background-image: none;
}

#cp-main span.corners-bottom span, #cp-menu span.corners-bottom span {
	background-image: none;
}

/* Topicreview */
#cp-main .panel #topicreview span.corners-top, #cp-menu .panel #topicreview span.corners-top {
	background-image: none;
}

#cp-main .panel #topicreview span.corners-top span, #cp-menu .panel #topicreview span.corners-top span {
	background-image: none;
}

#cp-main .panel #topicreview span.corners-bottom, #cp-menu .panel #topicreview span.corners-bottom {
	background-image: none;
}

#cp-main .panel #topicreview span.corners-bottom span, #cp-menu .panel #topicreview span.corners-bottom span {
	background-image: none;
}

/* Friends list */
.cp-mini {
	background-color: #f9f9f9;
	padding: 0 5px;
	margin: 10px 15px 10px 5px;
}

.cp-mini span.corners-top, .cp-mini span.corners-bottom {
	margin: 0 -5px;
}

dl.mini dt {
	font-weight: bold;
	color: #676767;
}

dl.mini dd {
	padding-top: 4px;
}

.friend-online {
	font-weight: bold;
}

.friend-offline {
	font-style: italic;
}

/* PM Styles
----------------------------------------*/
#pm-menu {
	line-height: 2.5em;
}

/* PM panel adjustments */
.pm-panel-header {
	margin: 0; 
	padding-bottom: 10px; 
}

.reply-all {
	display: block; 
	padding-top: 4px; 
	clear: both;
	float: left;
}

.pm-panel-message {
	padding-top: 10px;
}

.pm-return-to {
	padding-top: 23px;
}

#cp-main .pm-message-nav {
	margin: 0; 
	padding: 2px 10px 5px 10px; 
}

/* PM Message history */
.current {
	color: #999999;
}

/* Defined rules list for PM options */
ol.def-rules {
	padding-left: 0;
}

ol.def-rules li {
	line-height: 180%;
	padding: 1px;
}

/* PM marking colours */
.pmlist li.bg1 {
	border: solid 3px transparent;
	border-width: 0 3px;
}

.pmlist li.bg2 {
	border: solid 3px transparent;
	border-width: 0 3px;
}

.pmlist li.pm_message_reported_colour, .pm_message_reported_colour {
	border-left-color: #bcbcbc;
	border-right-color: #bcbcbc;
}

.pmlist li.pm_marked_colour, .pm_marked_colour {
	border: solid 3px #ffffff;
	border-width: 0 3px;
}

.pmlist li.pm_replied_colour, .pm_replied_colour {
	border: solid 3px #c2c2c2;
	border-width: 0 3px;	
}

.pmlist li.pm_friend_colour, .pm_friend_colour {
	border: solid 3px #bdbdbd;
	border-width: 0 3px;
}

.pmlist li.pm_foe_colour, .pm_foe_colour {
	border: solid 3px #000000;
	border-width: 0 3px;
}

.pm-legend {
	border-left-width: 10px;
	border-left-style: solid;
	border-right-width: 0;
	margin-bottom: 3px;
	padding-left: 3px;
	color: #f1f1f1;
}

/* Avatar gallery */
#gallery label {
	position: relative;
	float: left;
	margin: 10px;
	padding: 5px;
	width: auto;
	background: #FFFFFF;
	border: 1px solid #CCC;
	text-align: center;
}

#gallery label:hover {
	background-color: #EEE;
}
/* proSilver Form Styles
---------------------------------------- */

/* General form styles
----------------------------------------*/
fieldset {
	border-width: 0;
	font-family: Verdana, Helvetica, Arial, sans-serif;
	font-size: 1.1em;
}

input {
	font-weight: normal;
	cursor: pointer;
	vertical-align: middle;
	padding: 0 3px;
	font-size: 1em;
	font-family: Verdana, Helvetica, Arial, sans-serif;
}

select {
	font-family: Verdana, Helvetica, Arial, sans-serif;
	font-weight: normal;
	cursor: pointer;
	vertical-align: middle;
	border: 1px solid #666666;
	padding: 0 1px;
	background-color: #FAFAFA;
}

option {
	padding-right: 1em;
}

option.disabled-option {
	color: graytext;
}

textarea {
	font-family: "Lucida Grande", Verdana, Helvetica, Arial, sans-serif;
	width: 60%;
	padding: 2px;
	font-size: 1em;
	line-height: 1.4em;
}

label {
	cursor: default;
	padding-right: 5px;
	color: #676767;
}

label input {
	vertical-align: middle;
}

label img {
	vertical-align: middle;
}

/* Definition list layout for forms
---------------------------------------- */
fieldset dl {
	padding: 4px 0;
}

fieldset dt {
	float: left;	
	width: 40%;
	text-align: left;
	display: block;
}

fieldset dd {
	margin-left: 41%;
	vertical-align: top;
	margin-bottom: 3px;
}

/* Specific layout 1 */
fieldset.fields1 dt {
	width: 15em;
	border-right-width: 0;
}

fieldset.fields1 dd {
	margin-left: 15em;
	border-left-width: 0;
}

fieldset.fields1 {
	background-color: transparent;
}

fieldset.fields1 div {
	margin-bottom: 3px;
}

/* Set it back to 0px for the reCaptcha divs: PHPBB3-9587 */
fieldset.fields1 #recaptcha_widget_div div {
   margin-bottom: 0;
}

/* Specific layout 2 */
fieldset.fields2 dt {
	width: 15em;
	border-right-width: 0;
}

fieldset.fields2 dd {
	margin-left: 16em;
	border-left-width: 0;
}

/* Form elements */
dt label {
	font-weight: bold;
	text-align: left;
}

dd label {
	white-space: nowrap;
	color: #333;
}

dd input, dd textarea {
	margin-right: 3px;
}

dd select {
	width: auto;
}

dd textarea {
	width: 85%;
}

/* Hover effects */
fieldset dl:hover dt label {
	color: #425067;
}

fieldset.fields2 dl:hover dt label {
	color: inherit;
}

#timezone {
	width: 95%;
}

* html #timezone {
	width: 50%;
}

/* Quick-login on index page */
fieldset.quick-login {
	margin-top: 5px;
	margin-bottom: 5px;
}

fieldset.quick-login input {
	width: auto;
}

fieldset.quick-login input.inputbox {
	width: 15%;
	vertical-align: middle;
	margin-right: 5px;
	background-color: #f3f3f3;
}

fieldset.quick-login label {
	white-space: nowrap;
	padding-right: 2px;
}

/* Display options on viewtopic/viewforum pages  */
fieldset.display-options {
	text-align: center;
	margin: 3px 0 5px 0;
}

fieldset.display-options label {
	white-space: nowrap;
	padding-right: 2px;
}

fieldset.display-options a {
	margin-top: 3px;
}

/* Display actions for ucp and mcp pages */
fieldset.display-actions {
	text-align: right;
	line-height: 2em;
	white-space: nowrap;
	padding-right: 1em;
}

fieldset.display-actions label {
	white-space: nowrap;
	padding-right: 2px;
}

fieldset.sort-options {
	line-height: 2em;
}

/* MCP forum selection*/
fieldset.forum-selection {
	margin: 5px 0 3px 0;
	float: right;
}

fieldset.forum-selection2 {
	margin: 13px 0 3px 0;
	float: right;
}

/* Jumpbox */
fieldset.jumpbox {
	text-align: right;
	margin-top: 15px;
	height: 2.5em;
}

fieldset.quickmod {
	width: 50%;
	float: right;
	text-align: right;
	height: 2.5em;
}

/* Submit button fieldset */
fieldset.submit-buttons {
	text-align: center;
	vertical-align: middle;
	margin: 5px 0;
}

fieldset.submit-buttons input {
	vertical-align: middle;
	padding-top: 3px;
	padding-bottom: 3px;
}

/* Posting page styles
----------------------------------------*/

/* Buttons used in the editor */
#format-buttons {
	margin: 15px 0 2px 0;
}

#format-buttons input, #format-buttons select {
	vertical-align: middle;
}

/* Main message box */
#message-box {
	width: 80%;
}

#message-box textarea {
	font-family: "Trebuchet MS", Verdana, Helvetica, Arial, sans-serif;
	width: 100%;
	font-size: 1.2em;
	color: #333333;
}

/* Emoticons panel */
#smiley-box {
	width: 18%;
	float: right;
}

#smiley-box img {
	margin: 3px;
}

/* Input field styles
---------------------------------------- */
.inputbox {
	background-color: #FFFFFF;
	border: 1px solid #c0c0c0;
	color: #333333;
	padding: 2px;
	cursor: text;
}

.inputbox:hover {
	border: 1px solid #eaeaea;
}

.inputbox:focus {
	border: 1px solid #eaeaea;
	color: #4b4b4b;
}

input.inputbox	{ width: 85%; }
input.medium	{ width: 50%; }
input.narrow	{ width: 25%; }
input.tiny		{ width: 125px; }

textarea.inputbox {
	width: 85%;
}

.autowidth {
	width: auto !important;
}

/* Form button styles
---------------------------------------- */
input.button1, input.button2 {
	font-size: 1em;
}

a.button1, input.button1, input.button3, a.button2, input.button2 {
	width: auto !important;
	overflow: visible;
	padding-top: 1px;
	padding-bottom: 1px;
	font-family: "Lucida Grande", Verdana, Helvetica, Arial, sans-serif;
	color: #000;
	background: #FAFAFA none repeat-x top left;
}

a.button1, input.button1 {
	font-weight: bold;
	border: 1px solid #405883;
}

input.button3 {
	padding: 0;
	margin: 0;
	line-height: 5px;
	height: 12px;
	background-image: none;
	font-variant: small-caps;
}

/* Alternative button */
a.button2, input.button2, input.button3 {
	border: 1px solid #405883;
}

/* <a> button in the style of the form buttons */
a.button1, a.button1:link, a.button1:visited, a.button1:active, a.button2, a.button2:link, a.button2:visited, a.button2:active {
	text-decoration: none;
	color: #000000;
	padding: 2px 8px;
	line-height: 250%;
	vertical-align: text-bottom;
	background-position: 0 1px;
}

/* Hover states */
a.button1:hover, input.button1:hover, a.button2:hover, input.button2:hover, input.button3:hover {
	border: 1px solid #BCBCBC;
	background-position: 0 100%;
	color: #BCBCBC;
}

input.disabled {
	font-weight: normal;
	color: #666666;
}

/* Topic and forum Search */
.search-box {
	margin-top: 3px;
	margin-left: 5px;
	float: left;
}

.search-box input {
}

input.search {
	background-image: none;
	background-repeat: no-repeat;
	background-position: left 1px;
	padding-left: 17px;
}

#search-box  input.search {
	padding-left: 20px;
	padding-right: 10px;
}

.full { width: 95%; }
.medium { width: 50%;}
.narrow { width: 25%;}
.tiny { width: 10%;}
/* proSilver Style Sheet Tweaks

These style definitions are mainly IE specific 
tweaks required due to its poor CSS support.
-------------------------------------------------*/

* html table, * html select, * html input { font-size: 100%; }
* html hr { margin: 0; }
* html span.corners-top, * html span.corners-bottom { background-image: url("{T_THEME_PATH}/images/corners_left.gif"); }
* html span.corners-top span, * html span.corners-bottom span { background-image: url("{T_THEME_PATH}/images/corners_right.gif"); }
* html div.headerbar span.corners-top { background-image: url("{T_THEME_PATH}/images/corners_left3.gif"); }
* html div.headerbar span.corners-top span { background-image: url("{T_THEME_PATH}/images/corners_right3.gif"); }
* html #cp-main span.corners-top, * html  #cp-menu span.corners-top {background-image: url("{T_THEME_PATH}/images/corners_left2.gif");}
* html #cp-main span.corners-top span, * html  #cp-menu span.corners-top span {background-image: url("{T_THEME_PATH}/images/corners_right2.gif");}
* html #cp-main span.corners-bottom, * html  #cp-menu span.corners-bottom {background-image: url("{T_THEME_PATH}/images/corners_left2.gif");}
* html #cp-main span.corners-bottom span, * html  #cp-menu span.corners-bottom span {background-image: url("{T_THEME_PATH}/images/corners_right2.gif");}

* html #wrap, * html .headerbar{ direction: ltr; } /* Fix for breakup of the borders when using IE and RTL */
* html .inside { float: right; } /* Bottom-right corner fix when using IE6 and RTL */
* html .rtl #site-description  {overflow:  hidden;}
* html .rtl h1 {margin-left: 30%; text-align: right;}
* html .rtl p.logo {margin: 1% 5% 0 25%;}
* html .postbody ul.profile-icons li a {display: inline-block;}

table.table1 {
	width: 99%;		/* IE < 6 browsers */
	/* Tantek hack */
	voice-family: "\"}\"";
	voice-family: inherit;
	width: 100%;
}
html>body table.table1 { width: 100%; }	/* Reset 100% for opera */

* html ul.topiclist li { position: relative; }
* html .postbody h3 img { vertical-align: middle; }

/* Form styles */
html>body dd label input { vertical-align: text-bottom; }	/* Align checkboxes/radio buttons nicely */

* html input.button1, * html input.button2 {
	padding-bottom: 0;
	margin-bottom: 1px;
}

/* Misc layout styles */
* html .column1, * html .column2 { width: 45%; }

/* Nice method for clearing floated blocks without having to insert any extra markup (like spacer above)
   From http://www.positioniseverything.net/easyclearing.html 
#tabs:after, #minitabs:after, .post:after, .navbar:after, fieldset dl:after, ul.topiclist dl:after, ul.linklist:after, dl.polls:after {
	content: "."; 
	display: block; 
	height: 0; 
	clear: both; 
	visibility: hidden;
}*/

.clearfix, #tabs, #minitabs, fieldset dl, ul.topiclist dl, dl.polls {
	height: 1%;
	overflow: hidden;
}

/* viewtopic fix */
* html .post {
	height: 25%;
	overflow: hidden;
}

/* navbar fix */
* html .clearfix, * html .navbar, ul.linklist {
	height: 4%;
	overflow: hidden;
}

/* Simple fix so forum and topic lists always have a min-height set, even in IE6
	From http://www.dustindiaz.com/min-height-fast-hack */
* html li.header dt {background: none;}	
	
dl.icon {
	min-height: 35px;
	height: auto !important;
	height: 35px;
}

* html li.row dl.icon dt {
	height: 35px;
	overflow: visible;
}

/* Correctly clear floating for details on profile view */
*:first-child+html dl.details dd {
	margin-left: 30%;
	float: none;
}

* html dl.details dd {
	margin-left: 30%;
	float: none;
}

* html .forumbg table.table1 {
	margin: 0 -2px 0px -1px;
}
/*  	
--------------------------------------------------------------
Colours and backgrounds for common.css
-------------------------------------------------------------- */

html, body {
	color: #405883;
	background-color: #1A2F59;
}

h1 {
	color: #ccc;
}

h2 {
	color: #405883;
}

h3  {
	border-bottom-color: #ccc;
	color: #ddd;
}

.panel .content h3 a:link, .panel .content h3 a:visited {color: #ddd;}
.panel .content h3 a:hover, .panel .content h3 a:active {color: #eaeaea; text-decoration: none;}
.section-portal .panel.bg3 h3 a:link, .section-portal .panel.bg3 h3 a:visited, .section-portal .linklist , .section-portal .linklist a {color: #ddd;}
.section-portal .panel.bg3 h3 a:hover, .section-portal .panel.bg3 h3 a:active {color: #eaeaea; text-decoration: none;}

h3 a:hover {text-decoration: none;}

hr {
	border-color: #FFFFFF;
	border-top-color: #ddd;
}

hr.dashed {
	border-top-color: #f1f1f1;
}

/* Search box
--------------------------------------------- */

#search-box { 
	background: url("{T_THEME_PATH}/images/bg_search.gif") 100% 0 no-repeat;
	color: #FFFFFF;
}

.rtl #search-box {background: url("{T_THEME_PATH}/images/bg_search.gif") 0 0 no-repeat;}

#search-box #keywords {
	background-color: transparent;
}

#search-box input {
	border-color: transparent;
}

/* Round cornered boxes and backgrounds
---------------------------------------- */
.headerbar {
/* Also see overall_header.html -> div id="site-description" */
	background: #211A21 url("{T_IMAGESET_PATH}/site_logo.jpg") 50% 0 no-repeat;
}

.navbar {
	background-color: #DCDEE2;
}

.forabg, .forumbg {
	background-color: #172952;
	background-image: url("{T_THEME_PATH}/images/bg_list.gif");
}

/*
.forumbg {
	background-color: #7C8891;
	background-image: url("{T_THEME_PATH}/images/bg_header.gif");
}
*/

.panel {
	background: #CED9E3 url("{T_THEME_PATH}/images/bg_panel.gif") 0 0 repeat-x;
	color: #28313F;
}

.panel.bg1, .post.bg1 {
	background: #C9D7E4 url("{T_THEME_PATH}/images/bg_panel.gif") 0 0 repeat-x;
}

.panel.bg2, .post.bg2 {
	background: #C2D0DC url("{T_THEME_PATH}/images/bg_panel.gif") 0 0 repeat-x;
}

.section-portal .forabg .panel.bg1 {background: #C9D7E4;}

.post:target .content {
	color: #000000;
}

.post:target h3 a {
	color: #000000;
}

.bg1	{ background-color: #C9D7E4; }
.bg2	{ background-color: #C2D0DC; }
.bg3	{ background-color: #cadceb; }


.ucprowbg {
	background-color: #DCDEE2;
}

.fieldsbg {
	background-color: #E7E8EA;
}

span.corners-top {
	background-image: url("{T_THEME_PATH}/images/corners_left.png");
}

span.corners-top span {
	background-image: url("{T_THEME_PATH}/images/corners_right.png");
}

span.corners-bottom {
	background-image: url("{T_THEME_PATH}/images/corners_left.png");
}

span.corners-bottom span {
	background-image: url("{T_THEME_PATH}/images/corners_right.png");
}

div.headerbar span.corners-top {
    background-image: url("{T_THEME_PATH}/images/corners_left3.png");
}

div.headerbar span.corners-top span {
    background-image: url("{T_THEME_PATH}/images/corners_right3.png");
}

/* Horizontal lists
----------------------------------------*/

ul.navlinks {
	border-bottom-color: #FFFFFF;
}

/* Table styles
----------------------------------------*/
table.table1 thead th {
	color: #ddd;
}

table.table1 tbody tr {
	border-color: #BFC1CF;
}

table.table1 tbody tr, table.table1 tbody tr {
	background: #D2E0EB url("{T_THEME_PATH}/images/gradient.gif") 0 100% repeat-x;
}

table.table1 tbody tr:hover, table.table1 tbody tr.hover {
	background: #EEF5F9 url("{T_THEME_PATH}/images/gradient.gif") 0 0 repeat-x;
	color: #000;
}

table.table1 td {
	color: #536482;
}

table.table1 tbody td {
	border-top-color: #FAFAFA;
}

table.table1 tbody th {
	border-bottom-color: #000000;
	color: #333333;
	background-color: #FFFFFF;
}

table.info tbody th {
	color: #000000;
}

/* Misc layout styles
---------------------------------------- */
dl.details dt {
	color: #000000;
}

dl.details dd {
	color: #536482;
}

.sep {
	color: #1198D9;
}

/* Pagination
---------------------------------------- */

.pagination span strong {
	color: #FFFFFF;
	background-color: #105289;
	border-color: #105289;
}

.pagination span a, .pagination span a:link, .pagination span a:visited, .pagination span a:active {
	color: #5C758C;
	background-color: #ECEDEE;
	border-color: #B4BAC0;
}

.pagination span a:hover {
	border-color: #0353CC;
	background-color: #0353CC;
	color: #FFF;
}

/* Pagination in viewforum for multipage topics */
.row .pagination {
	background-image: url("{T_THEME_PATH}/images/icon_pages.gif");
}

.row .pagination span a, li.pagination span a {
	background-color: #FFFFFF;
}

.row .pagination span a:hover, li.pagination span a:hover {
	background-color: #0353CC;
}

/* Miscellaneous styles
---------------------------------------- */

.copyright {
	color: #999;
}

.copyright a {
    color: #bbb !important;
}

#simple-wrap .copyright {
	color: #777;
}

#simple-wrap .copyright a {
	color: #333 !important;
}

.error {
	color: #CA0233;
}

.reported {
	background-color: #F7ECEF !important;
}

li.reported:hover {
	background: none #F7ECEF !important;
}

.sticky, .announce {
	/* you can add a background for stickies and announcements*/
}

div.rules {
	background: #192C51 url("{T_THEME_PATH}/images/menu_bg.gif") 0 0 repeat-x;
	color: #ddd;
}

div.rules a, div.rules strong {background: url("{T_THEME_PATH}/images/bg_rules.gif") 0 50% no-repeat;}
div.rules a:link, div.rules a:visited {color: #ddd; font-size: 1.1em;}
div.rules a:active, div.rules a:hover {color: #f9f9f9;}

p.rules {
	background-color: #ECD5D8;
	background-image: none;
}

/*  	
--------------------------------------------------------------
Colours and backgrounds for links.css
-------------------------------------------------------------- */

a:link	{ color: #053F98; }
a:visited	{ color: #576E92; }
a:hover	{ color: #0353CC; }
a:active	{ color: #aa0000; }

/* Links on gradient backgrounds */
#search-box a:link, .navbg a:link {
	color: #FFFFFF;
}

#search-box a:visited, .navbg a:visited {
	color: #FFFFFF;
}

.forumbg .header a:visited, .forabg .header a:visited, th a:visited, .forumbg .header a:link, .forabg .header a:link, th a:link, .forumbg .header a:visited, .forabg .header a:visited, th a:visited {
	color: #ddd;
}

#search-box a:hover, .navbg a:hover {
	color: #A8D8FF;
}

.forumbg .header a:hover, .forabg .header a:hover, th a:hover, .forumbg .header a:active, .forabg .header a:active, th a:active {
	color: #f1f1f1;
	text-decoration: none;
}

#search-box a:active, .navbg a:active {
	color: #C8E6FF;
}

/* Links for forum/topic lists */
a.forumtitle {
	color: #053F98;
}

/* a.forumtitle:visited { color: #105289; } */

a.forumtitle:hover {
	color: #0353CC;
}

a.forumtitle:active {
	color: #aa0000;
}

a.topictitle {
	color: #053F98;
}

/* a.topictitle:visited { color: #368AD2; } */

a.topictitle:hover {
	color: #0353CC;
}

a.topictitle:active {
	color: #aa0000;
}

/* Post body links */
.postlink {
	color: #368AD2;
	border-bottom-color: #0353CC;
}

.postlink:visited {
	color: #5D8FBD;
	border-bottom-color: #666666;
}

.postlink:active {
	color: #368AD2;
}

.postlink:hover {
	background-color: #D0E4F6;
	color: #0D4473;
}

.signature a, .signature a:visited, .signature a:active, .signature a:hover {
	background-color: transparent;
}

/* Profile links */
.postprofile a:link, .postprofile a:active, .postprofile a:visited, .postprofile dt.author a {
	color: #053F98;
}

.postprofile a:hover, .postprofile dt.author a:hover {
	color: #0353CC;
}

/* Profile searchresults */	
.search .postprofile a {
	color: #053F98;
}

.search .postprofile a:hover {
	color: #0353CC;
}

/* Back to top of page */
a.top {
	background-image: url("{IMG_ICON_BACK_TOP_SRC}");
}

a.top2 {
	background-image: url("{IMG_ICON_BACK_TOP_SRC}");
}

/* Arrow links  */
a.up		{ background-image: url("{T_THEME_PATH}/images/arrow_up.gif") }
a.down		{ background-image: url("{T_THEME_PATH}/images/arrow_down.gif") }
a.left		{ background-image: url("{T_THEME_PATH}/images/arrow_left.gif") }
a.right		{ background-image: url("{T_THEME_PATH}/images/arrow_right.gif") }

a.up:hover {
	background-color: transparent;
}

a.left:hover {
	color: #368AD2;
}

a.right:hover {
	color: #368AD2;
}


/*  	
--------------------------------------------------------------
Colours and backgrounds for content.css
-------------------------------------------------------------- */

/*
ul.forums {
	background-color: #E8ECEE;
	background-image: url("{T_THEME_PATH}/images/gradient.gif"); 
}
*/

ul.topiclist li {
	color: #4C5D77;
}

ul.topiclist dd {
	border-left-color: #f9f9f9;
}

.rtl ul.topiclist dd {
	border-right-color: #fff;
	border-left-color: transparent;
}

ul.topiclist li.row dt a.subforum.read {
	background-image: url("{IMG_SUBFORUM_READ_SRC}");
}

ul.topiclist li.row dt a.subforum.unread {
	background-image: url("{IMG_SUBFORUM_UNREAD_SRC}");
}

li.row {
	border-top-color:  #BCCFDE;
	border-bottom-color: #fff;
	background: #D2E0EB url("{T_THEME_PATH}/images/gradient.gif") 0 100% repeat-x;
}

/*
li.row:hover {
	background: #E7F0F6;
}
*/

li.row strong {
	color: #000000;
}

li.row:hover dd {
	border-left-color: #BFD0DD;
}

.rtl li.row:hover dd {
	border-right-color: #BFD0DD;
	border-left-color: transparent;
}

li.header dt, li.header dd {
	color: #ddd;
}

/* Forum list column styles */
ul.topiclist dd.searchextra {
	color: #333333;
}

/* Post body styles
----------------------------------------*/
.postbody {
	color: #333333;
}

/* Content container styles
----------------------------------------*/
.content {
	color: #333333;
}

.content h2, .panel h2 {
	color: #ddd;
	border-bottom-color:  #eee;
}

.section-portal .content h2 {color: #405883;}

dl.faq dt {
	color: #405883;
}

.posthilit {
	background: #B5C8D7 url("{T_THEME_PATH}/images/bg_header.gif") repeat-x;
	border-bottom: 1px solid #eee;
	color: #eee;
}

h3 .posthilit {padding-right: 4px;}

/* Post signature */
.signature {
	border-top-color: #eee;
}

/* Post noticies */
.notice {
	border-left-color:  #f9f9f9;
	border-top-color:  #f9f9f9;
	border-right-color:  #6F8291;
	border-bottom-color:  #6F8291;
}

.bg1 .notice {background: #C9D7E4;}
.bg2 .notice {background: #C2D0DC;}

/* BB Code styles
----------------------------------------*/
/* Quote block */
blockquote {
	background-color: #e1ebf2;
	background-image: url("{T_THEME_PATH}/images/quote.gif");
	border-color:#A2BBD0;
}

.rtl blockquote {
	background-image: url("{T_THEME_PATH}/images/quote_rtl.gif");
}

blockquote blockquote {
	/* Nested quotes */
	background-color:#ECF3F7;
}

blockquote blockquote blockquote {
	/* Nested quotes */
	background-color: #e1ebf2;
}

/* Code block */
dl.codebox {
	background: #FDFDFE url("{T_THEME_PATH}/images/border_top.gif") 0 -1px repeat-x;
	border-color: #95A7B6;
}

dl.codebox dt {
	border-bottom-color:  #aaa;
}

dl.codebox code {
	color: #405883;
}

.syntaxbg		{ color: #FFFFFF; }
.syntaxcomment	{ color: #FF8000; }
.syntaxdefault	{ color: #0000BB; }
.syntaxhtml		{ color: #000000; }
.syntaxkeyword	{ color: #007700; }
.syntaxstring	{ color: #DD0000; }

/* Attachments
----------------------------------------*/
.attachbox {
	background: #eee url("{T_THEME_PATH}/images/bg_input.gif") 0 -1px repeat-x;
	border-color:  #9DAAC0;
}

.attachbox dt {
	font-weight: bold;
	color: #405883;
}

.pm-message .attachbox {
	background-color: #F2F3F3;
}

.attachbox dd {
	border-top-color: #C9D2D8;
}

.attachbox p {
	color: #666666;
}

.attachbox p.stats {
	color: #666666;
}

.attach-image img {
	border-color: #999999;
}

/* Inline image thumbnails */

dl.file dd {
	color: #333;
}

dl.thumbnail img {
	border-color: #666666;
	background-color: #FFFFFF;
}

dl.thumbnail dd {
	color: #666666;
}

dl.thumbnail dt a:hover {
	background-color: #EEEEEE;
}

dl.thumbnail dt a:hover img {
	border-color: #368AD2;
}

/* Post poll styles
----------------------------------------*/

fieldset.polls dl {
	border-top-color: #f1f1f1;
	color: #596376;
}

fieldset.polls dl.voted {
	color: #234;
}

fieldset.polls dd div {
	color: #f1f1f1;
}

.rtl .pollbar1, .rtl .pollbar2, .rtl .pollbar3, .rtl .pollbar4, .rtl .pollbar5 {
	border-right-color: transparent;
}

.pollbar1 {
	background-color: #1F365F;
	border-bottom-color: #83929F;
	border-right-color: #83929F;
}

.rtl .pollbar1 {
	border-left-color: #83929F;
}

.pollbar2 {
	background-color: #344E7B;
	border-bottom-color: #83929F;
	border-right-color: #83929F;
}

.rtl .pollbar2 {
	border-left-color: #83929F;
}

.pollbar3 {
	background-color: #436090;
	border-bottom-color: #798794;
	border-right-color: #798794;
}

.rtl .pollbar3 {
	border-left-color: #798794;
}

.pollbar4 {
	background-color: #5777AB;
	border-bottom-color: #9BA8B3;
	border-right-color: #9BA8B3;
}

.rtl .pollbar4 {
	border-left-color: #9BA8B3;
}

.pollbar5 {
	background-color: #6F8DBD;
	border-bottom-color: #75808A;
	border-right-color: #75808A;
}

.rtl .pollbar5 {
	border-left-color: #75808A;
}

/* Poster profile block
----------------------------------------*/
.postprofile {
	color: #333;
}

.rtl .postprofile {
	border-right-color: #eee;
	border-left-color: transparent;
}

.pm .postprofile {
	border-left-color: #DDDDDD;
}

.rtl .pm .postprofile {
	border-right-color: #DDDDDD;
	border-left-color: transparent;
}

.postprofile strong {
	color: #000000;
}

.post.online .postprofile, #viewprofile .online .details, #cp-main .online .postprofile  {
	background: url("{T_IMAGESET_PATH}/icon_user_online.gif") 100% 0 no-repeat;
}

.rtl .post.online .postprofile, .rtl #viewprofile .online .details, .rtl #cp-main .online .postprofile  {
	background: url("{T_IMAGESET_PATH}/icon_user_online.gif") 0 0 no-repeat;
}

/*  	
--------------------------------------------------------------
Colours and backgrounds for buttons.css
-------------------------------------------------------------- */

/* Big button images */
.buttons div.reply-icon, .buttons div.post-icon, .buttons div.locked-icon, .buttons div.pmreply-icon, .buttons div.newpm-icon, .buttons div.forwardpm-icon {background: url("{T_THEME_PATH}/images/bg_buttons.jpg") 100% 0 no-repeat;}
.buttons div.reply-icon a, .buttons div.pmreply-icon a {background: url("{T_THEME_PATH}/images/bg-big-button.gif") 100% 0 no-repeat;}
.buttons div.post-icon a, .buttons div.newpm-icon a {background: url("{T_THEME_PATH}/images/bg-big-button.gif") 100% -50px no-repeat;}
.buttons div.locked-icon	a {background: url("{T_THEME_PATH}/images/bg-big-button.gif") 100% -100px no-repeat;}
.buttons div.forwardpm-icon a {background: url("{T_THEME_PATH}/images/bg-big-button.gif") 100% -150px no-repeat;}

.buttons div.reply-icon a:hover, .buttons div.pmreply-icon a:hover {background-position: 100% -25px;}
.buttons div.post-icon a:hover, .buttons div.newpm-icon a:hover {background-position: 100% -75px;}
.buttons div.locked-icon	a:hover {background-position: 100% -125px;}
.buttons div.forwardpm-icon a:hover {background-position: 100% -175px;}




a.print {
	background-image: url("{T_THEME_PATH}/images/icon_print.gif");
}

a.sendemail {
	background-image: url("{T_THEME_PATH}/images/icon_sendemail.gif");
}

a.fontsize {
	background-image: url("{T_THEME_PATH}/images/icon_fontsize.gif");
}

/* Icon images
---------------------------------------- */
.sitehome						{ background-image: url("{T_THEME_PATH}/images/icon_home.gif"); }
.icon-faq						{ background-image: url("{T_THEME_PATH}/images/icon_faq.gif"); }
.icon-members					{ background-image: url("{T_THEME_PATH}/images/icon_members.gif"); }
.icon-home						{ background-image: url("{T_THEME_PATH}/images/icon_home.gif"); }
.icon-ucp						{ background-image: url("{T_THEME_PATH}/images/icon_ucp.gif"); }
.icon-register					{ background-image: url("{T_THEME_PATH}/images/icon_register.gif"); }
.icon-logout					{ background-image: url("{T_THEME_PATH}/images/icon_logout.gif"); }
.icon-bookmark					{ background-image: url("{T_THEME_PATH}/images/icon_bookmark.gif"); }
.icon-bump						{ background-image: url("{T_THEME_PATH}/images/icon_bump.gif"); }
.icon-subscribe					{ background-image: url("{T_THEME_PATH}/images/icon_subscribe.gif"); }
.icon-unsubscribe				{ background-image: url("{T_THEME_PATH}/images/icon_unsubscribe.gif"); }
.icon-pages						{ background-image: url("{T_THEME_PATH}/images/icon_pages.gif"); }
.icon-search					{ background-image: url("{T_THEME_PATH}/images/icon_search.gif"); }

/* Profile & navigation icons */
.email-icon, .email-icon a		{ background-image: url("{IMG_ICON_CONTACT_EMAIL_SRC}"); }
.aim-icon, .aim-icon a			{ background-image: url("{IMG_ICON_CONTACT_AIM_SRC}"); }
.yahoo-icon, .yahoo-icon a		{ background-image: url("{IMG_ICON_CONTACT_YAHOO_SRC}"); }
.web-icon, .web-icon a			{ background-image: url("{IMG_ICON_CONTACT_WWW_SRC}"); }
.msnm-icon, .msnm-icon a			{ background-image: url("{IMG_ICON_CONTACT_MSNM_SRC}"); }
.icq-icon, .icq-icon a			{ background-image: url("{IMG_ICON_CONTACT_ICQ_SRC}"); }
.jabber-icon, .jabber-icon a		{ background-image: url("{IMG_ICON_CONTACT_JABBER_SRC}"); }
.pm-icon, .pm-icon a				{ background-image: url("{T_IMAGESET_PATH}/icon_contact_pm.gif"); }

/* Moderator icons */
.report-icon, .report-icon a		{ background-image: url("{IMG_ICON_POST_REPORT_SRC}"); }
.delete-icon, .delete-icon a		{ background-image: url("{IMG_ICON_POST_DELETE_SRC}"); }
.info-icon, .info-icon a			{ background-image: url("{IMG_ICON_POST_INFO_SRC}"); }
.warn-icon, .warn-icon a			{ background-image: url("{IMG_ICON_USER_WARN_SRC}"); } /* Need updated warn icon */

/*  	
--------------------------------------------------------------
Colours and backgrounds for cp.css
-------------------------------------------------------------- */

/* Main CP box
----------------------------------------*/
#cp-main h3, #cp-main hr, #cp-menu hr {
	border-color: #A4B3BF;
}

#cp-main .panel li.row {
	border-bottom-color: #B5C1CB;
	border-top-color: #F9F9F9;
}

ul.cplist {
	border-top-color: #B5C1CB;
}

#cp-main .panel li.header dd, #cp-main .panel li.header dt {
	color: #405883;
}

#cp-main table.table1 thead th {
	color: #405883;
	border-bottom-color: #405883;
}

#cp-main .pm-message {
	border-color: #DBDEE2;
	background-color: #FFFFFF;
}

/* CP tabbed menu
----------------------------------------*/
#tabs a {
	background: url("{T_THEME_PATH}/images/bg_button.jpg") -20px 35px;
	border-right: 1px solid #999;
	border-left: 1px solid #333;
	border-bottom: 1px solid #777;
}

.section-posting #tabs a {
	background: url("{T_THEME_PATH}/images/bg_button2.jpg") -20px 35px;
	border-right: 1px solid #ccc;
	border-left: 1px solid #666;
	border-bottom: 1px solid #999;
}

#tabs a span {
	color: #ccc;
}

#tabs a:hover span {
	color: #f1f1f1;
}

#tabs .activetab a {
	border-bottom-color: #777;
}

.section-posting #tabs .activetab a {
	border-bottom-color: #aaa;
}

#tabs .activetab a span {
	margin-left: -5px; padding-left: 10px;
	background: url("{T_THEME_PATH}/images/bg_button.jpg") 0 0;
	color: #e5e5e5;
}

.section-posting #tabs .activetab a span {
	background: url("{T_THEME_PATH}/images/bg_button2.jpg") 0 0;
}

#tabs .activetab a:hover span {
	background: none;
	color: #fff;
}

/* Mini tabbed menu used in MCP
----------------------------------------*/
#minitabs li {
	background-color: #f1f1f1;
}

#minitabs li:hover {
	background: #F9F9F9;
}

#minitabs li.activetab {
	background-color: #F9F9F9;
}

#minitabs li.activetab a, #minitabs li.activetab a:hover {
	color: #0353CC;
}

/* UCP navigation menu
----------------------------------------*/

/* Link styles for the sub-section links */
#navigation a {
	color: #f1f1f1;
	background-color: #50648D;
	background-image: url("{T_THEME_PATH}/images/bg_menu.gif");
}

.rtl #navigation a {
	background-image: url("{T_THEME_PATH}/images/bg_menu_rtl.gif");
	background-position: 0 100%;
}

#navigation a:hover {
	background-image: none;
	background-color: #A5B0C5;
	color: #fff;
}

#navigation #active-subsection a {
	color: #405883;
	background-color: #F9F9F9;
	background-image: none;
}

#navigation #active-subsection a:hover {
	color: #0353CC;
}

/* Preferences pane layout
----------------------------------------*/
#cp-main h2, #cp-main h3#review, #cp-main h3#review span a, #cp-main .top2 {
	color: #bbb;
}

#cp-main .panel {
	background-color: #F9F9F9;
}

#cp-main .pm {
	background-color: #FFFFFF;
}

#cp-main span.corners-top, #cp-menu span.corners-top {
	background-image: url("{T_THEME_PATH}/images/corners_left2.png");
}

#cp-main span.corners-top span, #cp-menu span.corners-top span {
	background-image: url("{T_THEME_PATH}/images/corners_right2.png");
}

#cp-main span.corners-bottom, #cp-menu span.corners-bottom {
	background-image: url("{T_THEME_PATH}/images/corners_left2.png");
}

#cp-main span.corners-bottom span, #cp-menu span.corners-bottom span {
	background-image: url("{T_THEME_PATH}/images/corners_right2.png");
}

/* Topicreview */
#cp-main .panel #topicreview span.corners-top, #cp-menu .panel #topicreview span.corners-top {
	background-image: url("{T_THEME_PATH}/images/corners_left.gif");
}

#cp-main .panel #topicreview span.corners-top span, #cp-menu .panel #topicreview span.corners-top span {
	background-image: url("{T_THEME_PATH}/images/corners_right.gif");
}

#cp-main .panel #topicreview span.corners-bottom, #cp-menu .panel #topicreview span.corners-bottom {
	background-image: url("{T_THEME_PATH}/images/corners_left.gif");
}

#cp-main .panel #topicreview span.corners-bottom span, #cp-menu .panel #topicreview span.corners-bottom span {
	background-image: url("{T_THEME_PATH}/images/corners_right.gif");
}

/* Friends list */
.cp-mini {
	background: #50648D url("{T_THEME_PATH}/images/bg_menu.gif") 50px 0 repeat-y;
}

dl.mini dt {
	color: #fff;
}

/* PM Styles
----------------------------------------*/
/* PM Message history */
.current {
	color: #000000 !important;
}

/* PM panel adjustments */
.pm-panel-header,
#cp-main .pm-message-nav {
	border-bottom-color: #A4B3BF;
}

/* PM marking colours */
.pmlist li.pm_message_reported_colour, .pm_message_reported_colour {
	border-left-color: #BC2A4D;
	border-right-color: #BC2A4D;
}

.pmlist li.pm_marked_colour, .pm_marked_colour {
	border-color: #FF6600;
}

.pmlist li.pm_replied_colour, .pm_replied_colour {
	border-color: #A9B8C2;
}

.pmlist li.pm_friend_colour, .pm_friend_colour {
	border-color: #5D8FBD;
}

.pmlist li.pm_foe_colour, .pm_foe_colour {
	border-color: #000000;
}

/* Avatar gallery */
#gallery label {
	background-color: #fff;
	border-color: #AABECA;
}

#gallery label:hover {
	background-color: #ECF3F7;
}

/*  	
--------------------------------------------------------------
Colours and backgrounds for forms.css
-------------------------------------------------------------- */

/* General form styles
----------------------------------------*/
select {
	border-color: #425067;
	background: #f1f1f1;
	color: #405883;
}

label {
	color: #425067;
}

option.disabled-option {
	color: graytext;
}

/* Definition list layout for forms
---------------------------------------- */
dd label {
	color: #425067;
}

/* Hover effects */
fieldset dl:hover dt label {
	color: #425067;
}

fieldset.fields2 dl:hover dt label {
	color: inherit;
}

/* Quick-login on index page */
fieldset.quick-login input.inputbox {
	background: #FDFDFD url("{T_THEME_PATH}/images/bg_input.gif") repeat-x;
}

/* Posting page styles
----------------------------------------*/

#message-box textarea, dt textarea.inputbox, dd textarea.inputbox, textarea#warning {
	background: #f1f1f1 url("{T_THEME_PATH}/images/bg_textarea.gif"); 
	color: #405883;
}

/* Input field styles
---------------------------------------- */
.inputbox {
	background: #eee url("{T_THEME_PATH}/images/bg_input.gif") 0 -1px repeat-x; 
	border-color: #B4BAC0;
	color: #405883;
}

.inputbox:hover {
	border-color: #11A3EA;
}

.inputbox:focus {
	border-color: #11A3EA;
	color: #0F4987;
}

/* Form button styles
---------------------------------------- */

a.button1, input.button1, input.button3, a.button2, input.button2 {
	color: #ccc;
}

a.button1, input.button1 {
	border-color: #777;
}

input.button3 {
	background-image: none;
}

/* Alternative button */
a.button2, input.button2, input.button3 {
	border-color: #777;
}

/* <a> button in the style of the form buttons */
a.button1, a.button1:link, a.button1:visited, a.button1:active, a.button2, a.button2:link, a.button2:visited, a.button2:active {
	color: #ccc;
}

/* Hover states */
a.button1:hover, input.button1:hover, a.button2:hover, input.button2:hover, input.button3:hover {
	border-color: #022665;
	color: #ddd;
}

input.search {
	background-color: #eee;
	background-image: url("{T_THEME_PATH}/images/icon_textbox_search.gif");
}

#search-box  input.search {
	background-image: none;
}

input.disabled {
	color: #666666;
}
:focus {outline: 0;}
h1, .panel h2, .content h2 , .panel h3, p.logo, li.header dt, li.header dd, .menu_top li a, .menu_bottom li a, .menu_top li span, .menu_bottom li span, .kwicks a, .quick-login h3, ul.stat h3, .table1 th, .section-faq .content h2, .postbody h3 , #login_forum .panel p, .section-portal h3, #options-panel dt label, .section-posting #attach-panel dt label, #poll-panel dt label, a.button1, input.button1, input.button3, a.button2, input.button2, #tabs a, #navigation span, .table1 th, .buttons, .edit-icon a span, .quote-icon a span {text-shadow: #000 0.1em -0.1em 0.1em;}
.forumtitle, .topictitle, #topicreview .postbody h3, #cp-main .panel h3, #cp-main #preview h3, dt label, dl.faq dt, .polls dl dt, #cp-main .table1 th, #cp-main .panel li.header dd, #cp-main .panel li.header dt, #navigation #active-subsection a span, .post .rules, .section-portal .content h2  {text-shadow: #fff 0.1em -0.1em 0.1em;}
li.header dt {background: url("{T_THEME_PATH}/images/shadow.png") 50% 0 no-repeat;}
a.button1, input.button1, input.button3, a.button2, input.button2 {background: #416194 url("{T_THEME_PATH}/images/bg_button.jpg");}

div.menu-top {background: url("{T_THEME_PATH}/images/menu_bg.gif") 0 0 repeat-x;}
div.menu-bottom {background: url("{T_THEME_PATH}/images/menu_bg.gif") 0 100% repeat-x;}
.menu_top, .menu_bottom {height: 2.5em; list-style: none; margin: 0;padding: 0;}
.menu_top li.rightside, .menu_bottom li.rightside {float: right; margin-right: 2px;}
.menu_top li, .menu_bottom li  {float: left; display: inline; margin: 0; padding: 0; text-align: center;}
.menu_top  {padding-right: 5px; background: url("{T_THEME_PATH}/images/menu_top_right.gif") no-repeat 100% 0; border-bottom: 1px solid #bbb;} 
.menu_top.bg_fix  {background: url("{T_THEME_PATH}/images/menu_top_right_header.gif") 100% 0 no-repeat;} 
.menu_bottom {padding-right: 5px; background: url("{T_THEME_PATH}/images/menu_bottom_right.gif") no-repeat 100% 100%; border-top: 1px solid #bbb;}
.menu_top li.menu_top_left, .menu_bottom li.menu_bottom_left {width: 5px; height: 2.5em; float: left;}
.menu_top li.menu_top_left {background: url("{T_THEME_PATH}/images/menu_top_left.gif") no-repeat 0 0;}
.menu_top li.menu_top_left_header {background: url("{T_THEME_PATH}/images/menu_top_left_header.gif") no-repeat 0 0;}
.menu_bottom li.menu_bottom_left {background: url("{T_THEME_PATH}/images/menu_bottom_left.gif") no-repeat 0 100%;}
.menu_top li a, .menu_bottom li a {padding: 0.5em; display: block; font: 700 1.1em tahoma; border-right: 1px solid #ccc;}
.menu_top li a:link, .menu_top li a:visited, .menu_bottom li a:link, .menu_bottom li a:visited {color: #ccc; text-decoration: none;}
.menu_top li a:hover, .menu_bottom li a:hover {color: #ddd;}
.menu_top li span, .menu_bottom li span {display: block; padding: 0.6em; font: 500 1em verdana; color: #ddd; text-decoration: none; border-right: 1px solid #ccc;}
.menu_top a, .menu_bottom a {background: url("{T_THEME_PATH}/images/bg.gif") -20px 35px;}
.menu_bottom li a.sendemail {background: url("{T_THEME_PATH}/images/icon_sendemail.gif");}
.menu_bottom li a.fontsize {cursor: pointer; background: url("{T_THEME_PATH}/images/icon_fontsize.gif");}
.menu_bottom li a.print {background: url("{T_THEME_PATH}/images/icon_print.gif");}

ul.stat {list-style: none;}
ul.stat li h3 {margin-top: 10px; color: #ccc; border-bottom: 1px solid #aaa;}
ul.stat h3 a:link, ul.stat h3 a:visited {margin-top: 10px; color: #ccc; text-decoration: none;}
ul.stat h3 a:active, ul.stat h3 a:hover {color: #ddd; text-decoration: none;}
li.stat, li.who-is, li.birthdays, li.permissions, li.quick-login {margin-left: 5px; padding-left: 50px; color: #ddd; background: none 0 50% no-repeat;}
li.stat {background-image: url("{T_THEME_PATH}/images/stat.gif");}
li.who-is { background-image: url("{T_THEME_PATH}/images/who-is.gif");}
li.birthdays {background-image: url("{T_THEME_PATH}/images/birthdays.gif");}
li.permissions {background-image: url("{T_THEME_PATH}/images/permissions.gif");}
li.quick-login {background-image: url("{T_THEME_PATH}/images/quick-login.gif");}

#topicreview .postbody h3 a:link, #topicreview .postbody h3 a:visited {color: #405883;}
#topicreview .postbody h3 a:hover, #topicreview .postbody h3 a:active, #cp-main .panel h3#review span a:hover {color: #0353CC;}
#topicreview .post.bg1 {background: #C9D7E4;}
#topicreview .post.bg2 {background: #C2D0DC;}
#report .panel p {margin-top: 50px;}
#preview p, .panel#message p, .panel .content p  {margin-top: 20px;}
#register .panel h4 {margin: 10px 0 20px 0; font-size: 1.5em; color: #ddd;}
#simple-wrap .panel, #search_memberlist .panel {background: #D7E4EB;}
#cp-main h3, h3#review, #mcp h3#review, .panel .fields1 h2 {padding-bottom: 4px; border-bottom: 1px solid #ccc; color: #405883;}
#cp-main #topicreview .post h3, #cp-main #preview h3, #topicreview  h3 {padding-bottom: 4px; border-bottom: 1px solid #f1f1f1;}
#cp-main p.author, .section-posting p.author, #mcp h3#review span a, #cp-main .post-ignore {color: #405883;}
#confirm .panel dl.panel, .postbody h3 span:hover {background: transparent;}
#cp-main .display-options a:link, #cp-main .display-options a:visited, #cp-main  .display-actions a:link, #cp-main  .display-actions a:visited {color: #bbb;}
#cp-main .display-options a:active, #cp-main .display-options a:hover, #cp-main  .display-actions a:active, #cp-main  .display-actions a:hover {color: #ccc;}
#cp-main, #cp-main label, .postbody .author, #cp-main h2 a:hover, #cp-main h2 a:active, #cp-main h3#review span a:hover {color: #ccc;}
#cp-main .panel label, #cp-main  .panel a, #cp-main .postbody a {color: #405883;}
#options-panel dd, #options-panel label, .section-posting #attach-panel, .section-posting #attach-panel label, #poll-panel, #poll-panel label {color: #ddd;}
#options-panel, #attach-panel, #poll-panel {background: #5A7E9B url("{T_THEME_PATH}/images/bg_header.gif") 0 100% repeat-x;}
#options-panel .fields1, #attach-panel p, #poll-panel p {margin-top: 28px;}
#viewfolder .pm-message-nav {background: #192C51 url("{T_THEME_PATH}/images/menu_bg.gif") repeat-x;}
, .section-viewtopic #login_forum p {font-size: 1.5em; color: #ccc; margin-top: 10px;}
.section-posting .panel.bg3 {background: #cadceb;}
.section-memberlist #post .fields2, #faqlinks .column1, #faqlinks .column2 {margin-top: 45px;}
.section-memberlist #post p.error {color: #f1f1f1; margin: 4px 0 -38px 0;}
.section-ucp  #cp-main .panel, .section-mcp #cp-main .panel {background: #f9f9f9;}
.section-ucp .panel.bg3, .section-mcp .panel.bg3 {background: #284879;}
.section-ucp #options-panel .fields1, .section-ucp #attach-panel p {margin-top: 0;}
.section-ucp #cp-main .panel h2, .section-mcp #cp-main .panel h2 {margin: 0.8em 0 0.2em 0; color: #405883; border-bottom: 1px solid #fff;}
.postbody h3 a:link, .postbody h3 a:visited, .search .postbody h3 a:link, .search .postbody h3 a:visited, #cp-main h2 a:link, #cp-main h2 a:visited, li.quick-login label {color: #ddd;}
.postbody h3 a:hover, .postbody h3 a:active, .search .postbody h3 a:hover, .search .postbody h3 a:active {color: #eaeaea;}

.kwicks {list-style: none; position: relative; width: 875px; margin: 0 auto; padding: 0; background-image: url("{T_THEME_PATH}/images/no_flicker.jpg");}
.kwicks li {overflow: hidden; float: left; width: 125px; height: 35px; background: url("{T_THEME_PATH}/images/custom_menu.jpg") no-repeat;}
.kwicks a {display: block; height: 35px; padding-top: 9px; text-align: center; font: 700 13px verdana; text-decoration: none;}

.kwicks a:link {color: #ccc;}
.kwicks a:visited {color: #ccc;}
.kwicks a:hover {padding-left: 40px; color: #ddd; text-align: left; text-decoration: none;}
.kwicks a:active {color: #f1f1f1;}

#kwick1 a {background: url("{T_THEME_PATH}/images/custom_menu_end.jpg")  0 0 no-repeat;}
#kwick1 {background-position: 0 0;}
#kwick1 a:hover {background-position: 0 -70px;}
#kwick2 {background-position: -200px 0;}
#kwick2:hover {background-position: -200px -35px;}
#kwick3 {background-position: -400px 0;}
#kwick3:hover {background-position: -400px -35px;}
#kwick4 {background-position: -600px 0;}
#kwick4:hover {background-position: -600px -35px;}
#kwick5 {background-position: -800px 0;}
#kwick5:hover {background-position: -800px -35px;}
#kwick6 {background-position: -1000px 0;}
#kwick6 a:hover{	background-position: -1000px -35px;}
#kwick7 {background-position: -1200px 0;}
#kwick7 a:hover{	background-position: 100% -105px;}
#kwick7 a {background: url("{T_THEME_PATH}/images/custom_menu_end.jpg") 100% -35px no-repeat;}

#kwick1.active, #kwick1:hover {background-position: 0 -35px;}
#kwick2.active, #kwick2:hover {background-position: -200px -35px;}
#kwick3.active, #kwick3:hover {background-position: -400px -35px;}
#kwick4.active, #kwick4:hover {background-position: -600px -35px;}
#kwick5.active, #kwick5:hover {background-position: -800px -35px;}
#kwick6.active, #kwick6:hover {background-position: -1000px -35px;}
#kwick7.active, #kwick7:hover {background-position: -1200px -35px;}
";s:10:"theme_path";s:10:"se_sprites";s:10:"theme_name";s:10:"se_sprites";s:11:"theme_mtime";s:10:"1284680578";s:11:"imageset_id";s:1:"4";s:13:"imageset_name";s:10:"se_sprites";s:18:"imageset_copyright";s:10:"&copy; pit";s:13:"imageset_path";s:10:"se_sprites";s:13:"template_path";s:10:"se_sprites";}}