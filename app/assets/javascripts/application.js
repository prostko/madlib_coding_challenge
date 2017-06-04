// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$("document").ready(function() {
  var r =
    '<form action="/home"><input type="submit" value="Create a New Mad Lib" id="new_madlib_button"></form>';

  $(".madlib_container").on("submit", "#fill_in_madlib_solution_form", function(
    e
  ) {
    e.preventDefault();

    var this_form = $("#fill_in_madlib_solution_form");
    var headers = {};
    headers["method"] = $(this_form).attr("method");
    headers["url"] = $(this_form).attr("action");
    headers["data"] = $(this_form).serialize();

    $.ajax(headers).success(function(response) {
      $(".resolved_madlib").html(response);

      if (!$("new_madlib_button")) {
        $(".madlib_container").append(r);
      }
    });
  });

  $(".madlib_container").on("submit", "#new_madlib_form", function(e) {
    e.preventDefault();

    var this_form = $("#new_madlib_form");
    var headers = {};
    headers["method"] = $(this_form).attr("method");
    headers["url"] = $(this_form).attr("action");
    headers["data"] = $(this_form).serialize();

    $.ajax(headers).success(function(response) {
      try {
        var errorsJSON = jQuery.parseJSON(response);
      } catch (e) {}

      if (Array.isArray(errorsJSON)) {
        $(".madlib_container").append(response);
      } else {
        $(".madlib_container").html(response);
        $(".madlib_container").append(r);
      }
    });
  });

  $(".link_div").click(function(e) {
    e.preventDefault();

    var this_link = $(event.target);
    var headers = {};
    headers["method"] = "GET";
    headers["url"] = this_link.attr("href");

    $.ajax(headers).success(function(response) {
      $(".madlib_container").html(response);
    });
  });

  // $(".madlib_container").on("click", "#new_madlib_button", function(e) {});
});
