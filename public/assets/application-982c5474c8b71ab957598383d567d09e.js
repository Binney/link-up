$( function() {

  /* Pagination via AJAX */
  $(document).on("click", '.pagination a', function() {
    $('.pagination').html('Loading...')
    $.get(this.href, null, null, "script");
    return false;
  });

  /* Create tabs. */
  $("#tabs").tabs({ heightStyle: "auto" });

  /* AJAX search for users. */
  $(document).on('submit', '#user_search', function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

  /* Hide neweventform on load and allow toggle when you click the toggle button. */
  $(".togglediv").toggle();
  $("#toggleform").click(function() {
    $( ".togglediv" ).slideToggle("slow" );
  });


});
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

;
