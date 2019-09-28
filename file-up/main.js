function fSelect( x ) {
  x.focus();
  x.select();

}

function st( x ) {
  if( document.selection ) {
    var range = document.body.createTextRange();
    range.moveToElementText( x );
    range.select();
  } else if( window.getSelection ) {
    var range = document.createRange();
    range.selectNode( x );
    window.getSelection().addRange( range );
  }

  return true;
}

function addTr( oThis ) {
  var iNum = 1;
  var iElement = oThis.id.substr( 1 );
  document.getElementById('fileName'+iElement).value = oThis.value;

  aFiles = document.getElementsByName("file");

  for(var i=0; i<aFiles.length; i++) {
    iNum++;
    if( document.getElementById( aFiles[i].id ).value == '' ) {
      return true;
    }
  }

  var fPlace = document.getElementById("filesTD");
  var pDiv = document.getElementById("fileAll");
  var fDiv = pDiv.cloneNode(true);

  fDiv.id = null;
  fDiv.children[0].children[1].name = 'F'+iNum;
  fDiv.children[0].children[1].id = 'F'+iNum;
  fDiv.children[1].id = 'fileName'+iNum;
  fDiv.children[1].value = null;

  fPlace.appendChild( fDiv );
}

function addUrl( oThis ) {
  var iNum = 1;
  var iElement = oThis.id.substr( 1 );

  aFiles = document.getElementsByName("urls");

  for(var i=0; i<aFiles.length; i++) {
    iNum++;
    if( aFiles[i].children[0].value == '' ) {
      return true;
    }
  }

  var fPlace = document.getElementById("urlsTD");
  var pDiv = document.getElementById("urlAll");
  var fDiv = pDiv.cloneNode(true);

  fDiv.id = null;
  fDiv.children[0].id = 'U'+iNum;
  fDiv.children[0].name = 'url'+iNum;
  fDiv.children[0].value = null;

  fPlace.appendChild( fDiv );
}

function frame_go( isFile ) {
  var fDiv = document.getElementById("in_file");
  var uDiv = document.getElementById("in_url");

  if( isFile ) {
    fDiv.style.display = 'table-row'
    uDiv.style.display = 'none'
  } else {
    fDiv.style.display = 'none'
    uDiv.style.display = 'table-row'
  }

  return false;
}

function show_msg() {
  var mDiv = document.getElementById("msg");
  mDiv.style.display = 'block';

  return false;
}

function restorator() {
  if( localStorage ) {
    if( localStorage.getItem( 'file-up-uid' ) && ( typeof( getCookie( 'PHPSESSID' ) ) == 'undefined' || getCookie( 'PHPSESSID' ) != localStorage.getItem( 'file-up-uid' ) ) ) {
      setCookie( 'PHPSESSID', localStorage.getItem( 'file-up-uid' ) );
      document.location.reload(false);
    } else {
      if( typeof( getCookie( 'PHPSESSID' ) ) != 'undefined' ) {
        localStorage.setItem( 'file-up-uid', getCookie( 'PHPSESSID' ) );
      }
    }
  }
}

function getCookie(name) {
  var matches = document.cookie.match( new RegExp( "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)" ) );
  return matches ? decodeURIComponent(matches[1]) : undefined;
}

function setCookie(name, value, options) {
  options = options || {};

  var expires = options.expires;

  if (typeof expires == "number" && expires) {
    var d = new Date();
    d.setTime(d.getTime() + expires*1000);
    expires = options.expires = d;
  }

  if (expires && expires.toUTCString) {
  	options.expires = expires.toUTCString();
  }

  value = encodeURIComponent(value);

  var updatedCookie = name + "=" + value;

  for(var propName in options) {
    updatedCookie += "; " + propName;
    var propValue = options[propName];    
    if (propValue !== true) {
      updatedCookie += "=" + propValue;
     }
  }

  document.cookie = updatedCookie;
}
