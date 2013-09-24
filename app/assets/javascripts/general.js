$( function() {

  /* Create tabs. */
  $("#tabs").tabs({ heightStyle: "auto" });

  /* AJAX search for users. */
  $(document).on('submit', '#user_search', function () {
    $.get(this.action, $(this).serialize(), null, 'script');
    return false;
  });

});
