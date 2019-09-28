// Style specific javascript
var ca_top = false;
var ca_top_scrolled = false;
var ca_top_diff = 2;
var ca_top_offset = (ca_main_width == '100%') ? 10 : 0;

$(document).ready(function() 
{
    if(ca_ie)
    {
        $('body').addClass('ca-ie').addClass((ca_ie6) ? 'ca-ie6' : 'ca-ie7');
    }
});
$(window).load(function() { 
    ca_setup_scroll();
    ca_resize_images();
    ca_fix_forum_images();
});

// make tables clickable
function ca_tables_init()
{
    var found = false;
    $('div').each(function(i) 
    {
        if(this.className == 'block-caption')
        {
            found = i;
            this.setAttribute('id','ca-block-' + i);
        }
        if(this.className == 'block-content')
        {
            if(found !== false)
            {
                this.setAttribute('id','ca-block-' + found + '-item');
                $('#ca-block-' + found).dblclick(function() 
                {
                    (ca_ie6) ? (($('#' + this.id + '-item').css('display') == 'none') ? $('#' + this.id + '-item').css('display', '') : $('#' + this.id + '-item').css('display', 'none') ) : $('#' + this.id + '-item').slideToggle('fast');
                    return false;
                });
            }
            found = false;
        }
    });
}

// resize images
function ca_resize_images()
{
    var i, limit, diff;
    diff = 200;
    limit = false;
    // override limit if style uses fixed width
    if(ca_main_width && ca_main_width.indexOf('%') == -1)
    {
        ca_main_width.replace(/px/, '');
        if(ca_main_width > 0)
        {
            ca_do_resize_images($('#page-body'), ca_main_width - diff);
            return;
        }
    }
    // content container width
    if($('#page-body').width())
    {
        limit = $('#page-body').width();
    }
    // browser window width
    if(document.documentElement && document.documentElement.offsetWidth)
    {
        limit = (limit == false || limit > document.documentElement.offsetWidth) ? document.documentElement.offsetWidth : limit;
    }
    else if(window.innerWidth)
    {
        limit = (limit == false || limit > window.innerWidth) ? window.innerWidth : limit;
    }
    if(document.body.clientWidth)
    {
        limit = (limit == false || limit > document.body.clientWidth) ? document.body.clientWidth : limit;
    }
    // adjust limit
    limit = (limit == false) ? 600 : (limit - diff);
    limit = (limit < 500) ? 500 : limit;
    ca_do_resize_images($('#page-body div.block-content'), limit);
}

// setup scrolling navbar
function ca_setup_scroll()
{
    if(ca_ie6)
    {
        return;
    }
    // adjust header
    ca_item = $('#search-box');
    ca_item2 = 0;
    if(ca_item.length)
    {
        ca_item2 += ca_item.width();
    }
    ca_item = $('#topnav');
    if(ca_item.length)
    {
        ca_item2 += ca_item.width();
    }
    if(ca_item2 > 0)
    {
        // setup min-width
        ca_item2 += 50;
        if(ca_item2 < 400) ca_item2 = 400;
        $('#global').css('min-width', ca_item2 + 'px');
    }
    // setup scrolling navbar
    var header = $('#page-header');
    var navbar = $('#navbar-top');
    if(!header.length || !navbar.length || !header.offset().top || !header.height() || !document.body.clientWidth)
    {
        return;
    }
    ca_top = navbar.offset().top;
    header.css(
    {
        'height'    : header.height() + 'px',
        'padding'   : '0',
        'position'  : 'relative'
    });
    navbar.css(
    {
        'width'     : header.width() + 'px',
        'margin'    : '0',
        'position'  : 'absolute',
        'z-index'   : '1'
    });
    var num_hidden = $('#navbar-top li.navbar-hidden').length;        
    if(($('#navbar-top li').length - num_hidden) < 3)
    {
        if($('#navbar-top-top').length)
        {
            $('#navbar-top-top').addClass('navbar-hidden');
            num_hidden++;
        }
    }
    if(num_hidden > 0)
    {
        header.addClass('navbar-has-hidden');
    }
    $(window).scroll(function() { ca_scroll_top(); });
    $(window).resize(function() { ca_scroll_top(); });
    if(navigator.appName !== 'Microsoft Internet Explorer')
    {
/*      if($('#global').length > 0 && typeof($('#global').get(0).onmousemove) != 'undefined')
        {
            $('#global').get(0).onmousemove = ca_scroll_timer;
        } */
        ca_scroll_top();
    }
}

/*
var ca_timer_scroll = 0;
function ca_scroll_timer()
{
    ca_timer_scroll ++;
    ca_top = 0;
    var header = $('#page-header');
    var navbar = $('#navbar-top');
    if(typeof(window.pageYOffset) == 'number')
    {
        ca_top = window.pageYOffset;
    }
    else if(document.body && document.body.scrollTop)
    {
        ca_top = document.body.scrollTop;
    }
    else if(document.documentElement && document.documentElement.scrollTop)
    {
        ca_top = document.documentElement.scrollTop;
    }
    $('#content-start').html('timer: ' + ca_timer_scroll + ', top: ' + ca_top);
} */

function ca_scroll_top()
{
//    ca_scroll_timer();
    var header = $('#page-header');
    var navbar = $('#navbar-top');
    ca_top = 0;
    if(typeof(window.pageYOffset) == 'number')
    {
        ca_top = window.pageYOffset;
    }
    else if(document.body && document.body.scrollTop)
    {
        ca_top = document.body.scrollTop;
    }
    else if(document.documentElement && document.documentElement.scrollTop)
    {
        ca_top = document.documentElement.scrollTop;
    }
    ca_top -= ca_top_diff;
    if(ca_top > header.offset().top && $(document.body).width() > 400)
    {
        if(ca_top_scrolled == false)
        {
            ca_top_scrolled = true;
            if(!window.opera)
            {
                header.css('z-index', '1'); // IE7 workaround
            }
            navbar.css(
            {
                'position'      : 'fixed',
                'top'           : '0',
                'margin-top'    : (0 - ca_top_diff) + 'px',
                'margin-left'   : (0 - ca_top_offset) + 'px',
                'z-index'       : '2'
            });
            navbar.addClass('navbar-top-fixed');
        }
        navbar.css('width', (header.width() + (ca_top_offset * 2)) + 'px');
    }
    else
    {
        if(ca_top_scrolled)
        {
            ca_top_scrolled = false;
            navbar.css(
            {
                'position'      : 'absolute',
                'top'           : '',
                'margin-top'    : '0',
                'margin-left'   : '0',
                'z-index'       : '2'
            });
            navbar.removeClass('navbar-top-fixed');
        }
        navbar.css('width', header.width() + 'px');
    }
}

// adjust tables
ca_code = 'ca_init_headers(); ';
ca_startup = ca_code + ca_startup;
function ca_init_headers()
{
    // fix table headers
    $('div.block-caption-header').each(function(i)
    {
        $(this).html('<div class="block-caption-right"></div><table border="0" cellspacing="0" cellpadding="0" width="100%" class="block-caption-table"><tr><td width="45%">&nbsp;</td><td class="block-caption-mid"><div class="block-caption-mid"><div class="block-caption-content">' + $(this).html() + '</div></div></td><td width="45%">&nbsp;</td></tr></table>').removeClass('block-caption-header');
//        $(this).html('<table border="0" cellspacing="0" cellpadding="0"><tr><td><div class="block-caption-content">' + $(this).html() + '</div></td></tr></table>').removeClass('block-caption-header');
    });
    // remove borders from last rows
    $('div.forabg, div.forumbg').each(function(i)
    {
        $('li.row:last', this).each(function(j)
        {
            $(this).addClass('row-last');
        });
    });
}

// adjust forum images
function ca_fix_forum_images()
{
    $('span.forum-image').each(function()
    {
        ca_item = $(this).parent().find('.forum-image-div').css({'float': 'none', 'margin-left': (Math.round($(this).width()) + 6) + 'px'});
    });
}

