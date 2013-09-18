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
//= require jquery
//= require jquery.turbolinks
//= require jquery.ui.all
//= require jquery_ujs
//= require bootstrap
//= require jquery_nested_form
//= require_tree .

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

/*$(document).on('nested:fieldAdded', function(ev){
  // this field was just inserted into your form
  var field = ev.field; 
  // it's a jQuery object already! Now you can find date input
  var dateField = field.find('.start_time');
  // and activate datepicker on it
  dateField.datepicker();
})*/
