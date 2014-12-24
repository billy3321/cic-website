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
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require jquery-ui/datepicker
//= require chosen-jquery
//= require jquery.timepicker.js
//= require ckeditor/init
//= require_tree .

var ready = function(){
  // datepicker
  $( ".datepicker" ).datepicker({dateFormat: 'yy-mm-dd'});
  // timepicker
  $( ".timepicker" ).timepicker({timeFormat: "H:i:s", scrollDefault: '00:00:00', step: 0.25});
  // enable chosen js
  $('.chosen-select').chosen({
    search_contains: true,
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '200px',
  });
  $(".chosen-select").trigger('chosen:updated');
  $(".recent-search-form-select").change(function() {
    var selected_value = this.value;
    $.each(this.children, function(){
      var form_class = '.' + this.value + '-search';
      if (selected_value == this.value){
        $(form_class).show();
      }else{
        $(form_class).hide();
      }
    });
  });
  $("#accordion").accordion();

  $('.all_record_button').click(function(){
    $('.has_record').show();
    $('.no_record').show();
    $('.all_record_button').addClass('current');
    $('.has_record_button').removeClass('current');
    $('.no_record_button').removeClass('current');
  });
  $('.has_record_button').click(function(){
    $('.has_record').show();
    $('.no_record').hide();
    $('.all_record_button').removeClass('current');
    $('.has_record_button').addClass('current');
    $('.no_record_button').removeClass('current');
  });
  $('.no_record_button').click(function(){
    $('.no_record').show();
    $('.has_record').hide();
    $('.all_record_button').removeClass('current');
    $('.no_record_button').addClass('current');
    $('.has_record_button').removeClass('current');
  });
  $('.all_party_button').click(function(){
    $('.kmt').show();
    $('.dpp').show();
    $('.pfp').show();
    $('.nsu').show();
    $('.tsu').show();
    $('.null').show();
    $('.all_party_button').addClass('current');
    $('.kmt_party_button').removeClass('current');
    $('.dpp_party_button').removeClass('current');
    $('.pfp_party_button').removeClass('current');
    $('.nsu_party_button').removeClass('current');
    $('.tsu_party_button').removeClass('current');
    $('.null_party_button').removeClass('current');
  });
  $('.kmt_party_button').click(function(){
    $('.kmt').show();
    $('.dpp').hide();
    $('.pfp').hide();
    $('.nsu').hide();
    $('.tsu').hide();
    $('.null').hide();
    $('.all_party_button').removeClass('current');
    $('.kmt_party_button').addClass('current');
    $('.dpp_party_button').removeClass('current');
    $('.pfp_party_button').removeClass('current');
    $('.nsu_party_button').removeClass('current');
    $('.tsu_party_button').removeClass('current');
    $('.null_party_button').removeClass('current');
  });
  $('.dpp_party_button').click(function(){
    $('.kmt').hide();
    $('.dpp').show();
    $('.pfp').hide();
    $('.nsu').hide();
    $('.tsu').hide();
    $('.null').hide();
    $('.all_party_button').removeClass('current');
    $('.kmt_party_button').removeClass('current');
    $('.dpp_party_button').addClass('current');
    $('.pfp_party_button').removeClass('current');
    $('.nsu_party_button').removeClass('current');
    $('.tsu_party_button').removeClass('current');
    $('.null_party_button').removeClass('current');
  });
  $('.pfp_party_button').click(function(){
    $('.kmt').hide();
    $('.dpp').hide();
    $('.pfp').show();
    $('.nsu').hide();
    $('.tsu').hide();
    $('.null').hide();
    $('.all_party_button').removeClass('current');
    $('.kmt_party_button').removeClass('current');
    $('.dpp_party_button').removeClass('current');
    $('.pfp_party_button').addClass('current');
    $('.nsu_party_button').removeClass('current');
    $('.tsu_party_button').removeClass('current');
    $('.null_party_button').removeClass('current');
  });
  $('.nsu_party_button').click(function(){
    $('.kmt').hide();
    $('.dpp').hide();
    $('.pfp').hide();
    $('.nsu').show();
    $('.tsu').hide();
    $('.null').hide();
    $('.all_party_button').removeClass('current');
    $('.kmt_party_button').removeClass('current');
    $('.dpp_party_button').removeClass('current');
    $('.pfp_party_button').removeClass('current');
    $('.nsu_party_button').addClass('current');
    $('.tsu_party_button').removeClass('current');
    $('.null_party_button').removeClass('current');
  });
  $('.tsu_party_button').click(function(){
    $('.kmt').hide();
    $('.dpp').hide();
    $('.pfp').hide();
    $('.nsu').hide();
    $('.tsu').show();
    $('.null').hide();
    $('.all_party_button').removeClass('current');
    $('.kmt_party_button').removeClass('current');
    $('.dpp_party_button').removeClass('current');
    $('.pfp_party_button').removeClass('current');
    $('.nsu_party_button').removeClass('current');
    $('.tsu_party_button').addClass('current');
    $('.null_party_button').removeClass('current');
  });
  $('.null_party_button').click(function(){
    $('.kmt').hide();
    $('.dpp').hide();
    $('.pfp').hide();
    $('.nsu').hide();
    $('.tsu').hide();
    $('.null').show();
    $('.all_party_button').removeClass('current');
    $('.kmt_party_button').removeClass('current');
    $('.dpp_party_button').removeClass('current');
    $('.pfp_party_button').removeClass('current');
    $('.nsu_party_button').removeClass('current');
    $('.tsu_party_button').removeClass('current');
    $('.null_party_button').addClass('current');
  });

};

$(document).ready(ready);
$(document).on('page:load', ready);