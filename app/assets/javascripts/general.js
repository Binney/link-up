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
