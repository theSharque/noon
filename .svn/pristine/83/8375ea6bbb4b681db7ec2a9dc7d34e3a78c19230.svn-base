jQuery(document).ready(function($) {
  var gallery = $('#thumbs').galleriffic({
    delay:                     3000, // in milliseconds
    numThumbs:                 5, // The number of thumbnails to show page
    preloadAhead:              -1, // Set to -1 to preload all images
    enableTopPager:            false,
    enableBottomPager:         false,
    maxPagesToShow:            5,  // The maximum number of pages to display in either the top or bottom pager
    imageContainerSel:         '#slideshow', // The CSS selector for the element within which the main slideshow image should be rendered
    renderSSControls:          true, // Specifies whether the slideshow's Play and Pause links should be rendered
    renderNavControls:         true, // Specifies whether the slideshow's Next and Previous links should be rendered
    enableHistory:             false, // Specifies whether the url's hash and the browser's history cache should update when the current slideshow image changes
    enableKeyboardNavigation:  true, // Specifies whether keyboard navigation is enabled
    autoStart:                 true, // Specifies whether the slideshow should be playing or paused when the page first loads
    syncTransitions:           false, // Specifies whether the out and in transitions occur simultaneously or distinctly
    defaultTransitionDuration: 500  // If using the default transitions, specifies the duration of the transitions
  });
});

(function ($) {
  /* Ajax reloading */
  Drupal.behaviors.AjaxReloading = {
    attach: function(context, settings) {
      $("body").once(function() {
        if( !$("#auction-page").attr("op").disabled ) {
          setInterval(function() {
            $.ajax({
              url: "",
              context: document.body,
              success: function(s,x){
                $(this).html(s);
              }
            });
          }, 150000);
        }
      });
    }
  };
})(jQuery);
