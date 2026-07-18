var ca_popup_id = -1;
var ca_popup_counter = 0;
var ca_item;
var ca_item2;
var ca_list;
var ca_list2;
var ca_code;
var ca_timer;
var ca_left;
var ca_exp = new Date(); 
var ca_mark_forum, ca_mark_subforum;
var ca_base_url;
var ca_startup = '';
var ca_ie6 = false;
var ca_ie8 = false;
var ca_ie = false;
var ca_qr = false;
var ca_qr_src = false;

if(document.all && !window.opera && !window.XMLHttpRequest)
{
    ca_ie6 = true;
}

ca_exp.setTime(ca_exp.getTime() + (90*24*60*60*1000));

ca_item = location.href.indexOf("#");
if(ca_item != -1)
{
    ca_base_url = location.href.slice(0, ca_item);
}
else
{
    ca_base_url = location.href;
}

$(document).ready(function() 
{
    if(ca_startup.length)
    {
        eval(ca_startup);
    }
    ca_popup_init();
    ca_forums_init();
    ca_tables_init();
    if($('#topic-title').length)
    {
        ca_check_topic_titles();
    }
    if($('#topics-sort').length)
    {
        ca_check_topic_order();
    }
    ca_links_init();
});
$(window).load(function() { 
    ca_popup_adjust();
    ca_scroll_window();
});

$(window).bind('load,resize', function()
{
    if(ca_ie8) check_posting_area();
});

// cookies
function ca_cookie_set(name, value) 
{
	var argv = ca_cookie_set.arguments;
	var argc = ca_cookie_set.arguments.length;
	var expires = (argc > 2) ? argv[2] : ca_exp;
	var path = (argc > 3) ? argv[3] : null;
	var domain = (argc > 4) ? argv[4] : null;
	var secure = (argc > 5) ? argv[5] : false;
	document.cookie = name + "=" + escape(value) +
		((expires == null) ? "" : ("; expires=" + expires.toGMTString())) +
		((path == null) ? "" : ("; path=" + path)) +
		((domain == null) ? "" : ("; domain=" + domain)) +
		((secure == true) ? "; secure" : "");
}

function ca_cookie_getval(offset) 
{
	var endstr = document.cookie.indexOf(";",offset);
	if (endstr == -1)
	{
		endstr = document.cookie.length;
	}
	return unescape(document.cookie.substring(offset, endstr));
}

function ca_cookie_get(name) 
{
	var arg = name + "=";
	var alen = arg.length;
	var clen = document.cookie.length;
	var i = 0;
	while (i < clen) 
	{
		var j = i + alen;
		if (document.cookie.substring(i, j) == arg)
			return ca_cookie_getval(j);
		i = document.cookie.indexOf(" ", i) + 1;
		if (i == 0)
			break;
	} 
	return null;
}


// initialize popups
function ca_popup_init()
{
    var id;
    // init popups
    $('a.popup-link').each(function(i)
    {
        id = this.id.replace(/popup-link-/, '');
        ca_item = $('#popup-' + id);
        if(this.id == ('popup-link-' + id) && ca_item.length)
        {
            // add events
            ca_code = "$(this).mouseover(function(){ ca_popup_show('" + id + "'); });";
            ca_code += "$(this).mouseout(function(){ ca_popup_hide('" + id + "'); });";
            eval(ca_code);
            $('#popup-' + id + ' a').each(function(i)
            {
                eval(ca_code);
            });
        }
    });
    // init minimize/maximize profiles
    $('div.post').each(function(i)
    {
        ca_item = $('div.post-maximize', this);
        if(ca_item.length > 0)
        {
            ca_item.html('<a href="javascript:void(0);" onclick="ca_post_maximize_all(); return false;"><span>&gt;&gt;</span></a>');
            ca_item.attr('id', 'post-max-' + i);
            $('div.profile-top', this).prepend('<div class="post-minimize" id="post-min-' + i + '"><a href="javascript:void(0);" onclick="ca_post_minimize_all(); return false;"><span>&lt;&lt;</span></a></div>');
            $('div.post-profile-block', this).attr('id', 'post-profile-' + i);
            $('div.postbody', this).attr('id', 'post-body-' + i);
            $('span.post-author-inline', this).attr('id', 'post-author-' + i);
        }
    });
    // hide profiles
    if(ca_cookie_get('hideprofiles') == 1 || (document.documentElement && document.documentElement.offsetWidth < 500))
    {
        ca_post_minimize_all();
    }
}

// adjust popups
function ca_popup_adjust()
{
    $('a.popup-link').each(function(i)
    {
        id = this.id.replace(/popup-link-/, '');
        ca_item = $('#popup-' + id);
        if(this.id == ('popup-link-' + id) && ca_item.length)
        {
            // adjust left
            ca_left = $(this).offset().left;
            if(ca_left > 0)
            {
                ca_left -= ca_item.offset().left;
                ca_item.css('margin-left', ca_left + 'px');
            }
        }
    });
}

// show popup event
function ca_popup_show(id)
{
    // check previous popup
    if(ca_popup_id != id)
    {
        ca_popup_do_hide(ca_popup_id);
        ca_popup_counter = 0;
        ca_popup_id = id;
    }
    // show popup
    ca_popup_counter ++;
    if(ca_popup_counter < 2)
    {
        ca_popup_do_show(id);
    }
}

// hide popup event
function ca_popup_hide(id)
{
    if(ca_popup_id == id)
    {
        ca_popup_counter --;
        if(ca_popup_counter < 1)
        {
            ca_popup_counter = 0;
            ca_popup_start_hide(id);
        }
    }
}

// show menu
function ca_popup_do_show(id)
{
    $('#popup-' + id + ' ul').show('fast'); // css('display', 'block');
}

// hide menu
function ca_popup_do_hide(id)
{
    if(id == -1)
    {
        return;
    }
    $('#popup-' + id + ' ul').hide('fast'); // css('display', 'none');
}

// start timer
function ca_popup_start_hide(id)
{
    if(ca_timer)
    {
        clearTimeout(ca_timer);
    }
    ca_timer = setTimeout("ca_popup_end_hide('" + id + "')", 500);
}

// end timer
function ca_popup_end_hide(id)
{
    clearTimeout(ca_timer);
    if(ca_popup_counter > 0)
    {
        return;
    }
    if(ca_popup_id != id)
    {
        return;
    }
    ca_popup_do_hide(id);
}

// parse forums list
function ca_parse_forums()
{
    var is_new;
    // find all categories
    $('div.forabg').each(function(i) 
    {
        if($('li.row-new', this).length > 0)
        {
            $(this).addClass('block-new');
        }
    });
    // find all forums
    if(ca_mark_forums && ca_mark_forums.indexOf("&amp;mark=forums") > 0);
    {
        $('li.row-new').dblclick(function()
        {
            ca_mark_read(this.id);
        });
    }
}

// marked as read
function ca_marked_forum(id) 
{
    // marked forum as read. find it and change icon
    ca_item = $('#forumrow-' + id + ' dl.icon');
    if(ca_item.length)
    {
        ca_item.css('background-image', ca_item.css('background-image').replace(/forum_unread/, 'forum_read'));
        $('#forumrow-' + id).removeClass('row-new');
        $('#forumrow-' + id).unbind('dblclick');
    }
}

// mark forum as read
function ca_mark_read(id)
{
    id = id.replace(/forumrow-/, '');
    var link = ca_mark_forums;
    link = link.replace(/&amp;mark=forums/, '&amp;mark=topics&amp;f=' + id);
    link = link.replace(/\/index\./, '/viewforum.');
    link = link.replace(/&amp;/g, '&');
    // using simple ajax request to mark forums
    ca_code = '$.ajax({ type: \'GET\', url: link, cache: false, success: function(html) { ca_marked_forum(\'' + id + '\'); } });';
    eval(ca_code);
    // mark sub-forums, if there are any
    link = link.replace(/&mark=topics/, '&mark=forums' + id);
    ca_code = '$.ajax({ type: \'GET\', url: link, cache: false });';
    eval(ca_code);
}

// select code
function ca_select_code(a)
{
	// Get ID of code block
	var e = a.parentNode.parentNode.parentNode.getElementsByTagName('CODE')[0];

	// Not IE
	if (window.getSelection)
	{
		var s = window.getSelection();
		// Safari
		if (s.setBaseAndExtent)
		{
			s.setBaseAndExtent(e, 0, e, e.innerText.length - 1);
		}
		// Firefox and Opera
		else
		{
			var r = document.createRange();
			r.selectNodeContents(e);
			s.removeAllRanges();
			s.addRange(r);
		}
	}
	// Some older browsers
	else if (document.getSelection)
	{
		var s = document.getSelection();
		var r = document.createRange();
		r.selectNodeContents(e);
		s.removeAllRanges();
		s.addRange(r);
	}
	// IE
	else if (document.selection)
	{
		var r = document.body.createTextRange();
		r.moveToElementText(e);
		r.select();
	}
}


// expand code
function ca_expand_code(a)
{
	// Get ID of code block
	var e = a.parentNode.parentNode.parentNode.getElementsByTagName('CODE')[0];
	if(e)
	{
	    if(e.style.overflow == 'visible')
	    {
	        e.style.maxHeight = '200px';
	        e.style.overflow = 'auto';
	    }
	    else
	    {
	        e.style.maxHeight = 'none';
	        e.style.overflow = 'visible';
	    }
	}
}


// expand forum
function ca_expand_forum(id, slide)
{
	// Find parent block
	$('#forabg-' + id + ' ul.forums').each(function(i)
	{
	    var old_visible = $(this).is(':visible');
	    if(ca_ie || ca_ie6)
	    {
	        $(this).css('display', (old_visible) ? 'none' : '');
	    }
	    else if(slide)
	    {
	        $(this).toggle('fast');
	    }
	    else
	    {
	        $(this).toggle();
	    }
        ca_cookie_set('expand' + id, (old_visible) ? 1 : 2);
	});
}

// expand forums
function ca_forums_init()
{
    var id;
    $('dl[id]').each(function()
    {
        if(this.id.slice(0, 7) == 'expand-')
        {
            $(this).prepend('<a href="javascript:void(0);" onclick="ca_expand_forum(' + this.id.slice(7) + ', true); return false;" class="forum-expand" id="forumblock' + this.id.slice(7) + '"></a>');
        }
    });
    $('div.forabg').each(function(i)
    {
        if(this.id && this.id.indexOf('forabg-') == 0)
        {
            id = this.id.replace(/forabg-/, '');
            if(ca_cookie_get('expand' + id) == 1)
            {
                ca_expand_forum(id, false);
            }
            ca_code = '$(\'li.header\', this).dblclick(function() { ca_expand_forum(' + id + ', true); });';
            eval(ca_code);
        }
    });
}

// minimize/maximize post
function ca_post_minimize(id)
{
    $('#post-profile-' + id).css('display', 'none');
    $('#post-body-' + id).addClass('post-hidden');
    $('#post-max-' + id).css('display', 'block');
    $('#post-min-' + id).css('display', 'none');
    $('#post-author-' + id).css('display', '');
}

function ca_post_maximize(id)
{
    $('#post-profile-' + id).css('display', '');
    $('#post-body-' + id).removeClass('post-hidden');
    $('#post-max-' + id).css('display', 'none');
    $('#post-min-' + id).css('display', 'block');
    $('#post-author-' + id).css('display', 'none');
}

function ca_post_minimize_all()
{
    $('div.post-maximize').each(function(i)
    {
        id = this.id.replace(/post-max-/, '');
        ca_post_minimize(id);
    });
    ca_cookie_set('hideprofiles', 1);
}

function ca_post_maximize_all()
{
    $('div.post-maximize').each(function(i)
    {
        id = this.id.replace(/post-max-/, '');
        ca_post_maximize(id);
    });
    ca_cookie_set('hideprofiles', 0);
}

// resize images
function ca_do_resize_images(container, limit)
{
    if(!container.length)
    {
        container = $(document.body);
    }
    container.find('img').each(function(i) {
        if(!$(this).hasClass('no-resize') && this.width > limit)
        {
            $(this).css({
                'cursor'    : (document.all) ? 'hand' : 'pointer',
                'width'     : (limit - 50) + 'px'
            });
            if($(this).parents('a').length == 0)
            {
                $(this).click(function() {
                    window.open(this.src, 'image', 'width=700,height=500,resizable=1,scrollbars=1');
                });
            }
        }
    });
}

// check topic titles
function ca_check_topic_titles()
{
    var topic_reply = 'Re: ' + $('#topic-title').html();
	$('div.post').each(function(i)
	{
	    ca_item = $('a.post-subject', this);
	    if(i > 0 && ca_item.length && ca_item.html() == topic_reply)
	    {
	        // hide topic title, unless its a first topic
	        ca_item.css('display', 'none');
	        // move topic post time
	        ca_item = $('p.author', this);
	        if(ca_item.length == 1)
	        {
	            ca_item2 = $('p.rules', this);
	            if(ca_item2.length == 1)
	            {
	                ca_item2.prepend('<p class="author">' + ca_item.html() + '</p>');
	            }
	            else
	            {
	                ca_item2 = $('div.content', this);
	                if(ca_item2.length == 1)
	                {
	                    ca_item2.prepend('<p class="author">' + ca_item.html() + '</p>');
                    }
	            }
	            ca_item.css('display', 'none');
	        }
	    }
	});
}

// sort topics
function ca_check_topic_order()
{
    ca_item = $('#topics-sort select#sk');
    if(ca_item.length && $('#topics-sort select#sd').length && $('#topics-sort input.button2').length)
    {
        // check sort order
        var desc = false;
        ca_item2 = $('#topics-sort select#sd');
        if(ca_item2.length > 0)
        {
            desc = (ca_item2.get(0).selectedIndex == 0) ? false : true;
        }
        // check all options
        ca_item2 = ca_item.get(0);
        for(var i=0; i<ca_item2.options.length; i++)
        {
            // match known sort items
            switch(ca_item2.options[i].value)
            {
                case 't':
                    // post time - last post row
                    ca_add_topic_order(i, 'div.forumbg li.header dd.lastpost', ca_item2.selectedIndex, desc);
                    break;
                case 'v':
                    // views
                    ca_add_topic_order(i, 'div.forumbg li.header dd.views', ca_item2.selectedIndex, desc);
                    break;
                case 'r':
                    // replies
                    ca_add_topic_order(i, 'div.forumbg li.header dd.posts', ca_item2.selectedIndex, desc);
                    break;
                case 's':
                    // topic title
                    ca_add_topic_order(i, 'div.forumbg ul.topiclist li.header dt', ca_item2.selectedIndex, desc);
                    break;
            }
        }
    }
}

function ca_add_topic_order(sort_index, sort_class, sort_selected, sort_desc)
{
    ca_code = false;
    $(sort_class).each(function(i)
    {
        if($('a', this).length == 0)
        {
            // no links. add one
            if(ca_code == false)
            {
                ca_code = '<a href="javascript:void(0);" onclick="ca_topic_sort(\'' + sort_index + '\', ';
                ca_code += (sort_selected != sort_index) ? '-1' : ((sort_desc) ? '0' : '1');
                ca_code += ');">';
            }
            if($('span', this).length == 1)
            {
                $('span', this).html(ca_code + $(this).html() + '</a>');
            }
            else
            {
                $(this).html(ca_code + $(this).html() + '</a>');
            }
        }
    });
}

function ca_topic_sort(sort_index, sort_order)
{
    $('#topics-sort select#sk').get(0).selectedIndex = sort_index;
    if(sort_order != -1)
    {
        $('#topics-sort select#sd').get(0).selectedIndex = sort_order;
    }
    // change submit button
    ca_code = '<input type="hidden" name="sort" value="' + $('#topics-sort input.button2').get(0).value + '" />';
    $('#topics-sort input.button2').remove();
    $('#topics-sort').append(ca_code);
    $('#topics-sort').get(0).submit();
}

function ca_scroll(item, fast)
{
    if(item.href.slice(0, ca_base_url.length + 1) == (ca_base_url + '#'))
    {
        var $target = $(item.hash);
        $target = $target.length && $target || $('[name=' + item.hash.slice(1) +']');
        if($target.length) 
        {
            var targetOffset = $target.offset().top;
            $('html,body').animate({scrollTop: targetOffset}, (fast) ? 300 : 500);
            return false;
        }
    }
    return true;
}

function ca_links_init()
{
    // Initialize named links
    $('a[href*=#]').click(function()
    {
        return ca_scroll(this, false);
    });
}

function ca_scroll_window()
{
    ca_item = location.href.indexOf("#");
    if(ca_item != -1)
    {
        ca_scroll(location, true);
    }
}

function check_posting_area()
{
    var box = $('#message-box');
    if(!box.length) return false;
    var textarea = $('textarea#message');
    if(!textarea.length) return false;
    textarea.css('width', 'auto');
    // check textarea width
    var diff = 20,
        width = box.width(),
        cols = textarea.attr('cols');
    if((textarea.width() + diff) >= width)
    {
        // reduce width
        var min = 200;
        var count = 0;
        while(textarea.width() > (width - diff))
        {
            count ++;
            if(count > 20) // avoid infinite loop
            {
                return false;
            }
            cols -= ((textarea.width() - width) > 100) ? 10 : (((textarea.width() - width) > 30) ? 2 : 1);
            if(cols < 10 || textarea.width() < min) return;
            textarea.attr('cols', cols);
        }
        return true;
    }
    // increase width
    var count = 0;
    while(textarea.width() < (width - diff))
    {
        count ++;
        if(count > 20) // avoid infinite loop
        {
            return false;
        }
        cols += ((width - textarea.width()) > 100) ? 10 : (((width - textarea.width()) > 30) ? 2 : 1);
        textarea.attr('cols', cols);
    }
    return true;
}

function ca_init_qr(url)
{
    ca_qr_src = url;
    ca_qr = new Image();
    ca_qr.onload = function() { ca_loaded_qr(false); }
    ca_qr.src = url;
}

// initialize quick reply button
function ca_loaded_qr(reload)
{
    if(!ca_qr.complete || !ca_qr.width || !ca_qr.height)
    {
        // image wasn't loaded yet
        if(!reload)
        {
            setTimeout("ca_loaded_qr(true)", 250);
        }
        return;
    }
    // image is ready
    $('#viewtopic-buttons').append('<div class="reply-icon" id="ca-qr" style="width: ' + Math.round(ca_qr.width) + 'px"><a href="javascript:void(0);" onclick="hide_qr(); return false;" title="!"><span style="background-image: url(\'' + ca_qr_src + '\');"></span></a></div>');
    $('#qr_showeditor_div').hide();
    $('#ca-qr a').attr('title', $('#qr_showeditor_div input').val());
}