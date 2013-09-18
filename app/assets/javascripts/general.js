$(function() {
  alert("You clicked something!");
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
