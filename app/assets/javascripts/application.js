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
//= require turbolinks
//= require bootstrap
//= require jquery
//= require jquery_ujs
//= require jquery.turbolinks
//= require jquery.ui.all
//= require jquery_nested_form
//= require_self
//= require_tree .

$( function() {

  /* Pagination via AJAX */
  $(document).on("click", '.pagination a', function() {
    $('.pagination').html('Loading...')
    $.get(this.href, null, null, "script");
    return false;
  });

  /* Datepicker on event_start_time (um, obsolete?) */
  $("#event_start_time").datepicker();

  /* Create tabs. */
  $("#tabs").tabs({ heightStyle: "auto" });

  /* Hide neweventform on load and allow toggle when you click the toggle button. */
  $(".neweventform").toggle();
  $("#toggleform").click(function() {
    $( ".neweventform" ).slideToggle("slow" );
  });

  /* AJAX search for users. */
  $(document).on('submit', '#user_search', function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

});
