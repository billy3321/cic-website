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
//= require jquery-ui/accordion
//= require jquery-ui/datepicker
//= require chosen-jquery
//= require magnific-popup
//= require jquery.timepicker.js
//= require ckeditor/init


var ready = function(){
  // datepicker
  $( ".datepicker" ).datepicker({dateFormat: 'yy-mm-dd'});
  // timepicker
  $( ".timepicker" ).timepicker({timeFormat: "H:i:s", scrollDefault: '00:00:00', step: 0.25});
  $( ".monthpicker" ).datepicker( {
    changeMonth: true,
    changeYear: true,
    showButtonPanel: true,
    dateFormat: 'yy-mm-dd',
    minDate: new Date(2014, 10, 1),
    maxDate: new Date,
    onClose: function(dateText, inst) {
        var month = $("#ui-datepicker-div .ui-datepicker-month :selected").val();
        var year = $("#ui-datepicker-div .ui-datepicker-year :selected").val();
        $(this).datepicker('setDate', new Date(year, month, 1));
    }
  });
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

  $(".video_type").change(function(){
    if (this.value == 'ivod'){
      $('.ivod_field').show();
      $('.news_field').hide();
    }else if (this.value == 'news'){
      $('.ivod_field').hide();
      $('.news_field').show();
    }
  });
  $(".video_type").change();

  $("#accordion").accordion();
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

  $('.check_all_box').change(function(){
    $.each($('.published_box'), function(){
      this.checked = $('.check_all_box')[0].checked;
    });
  });
  if ($('.alert').length > 0) {
    $.magnificPopup.open({
      items: {
        src: $('.alert'), // can be a HTML string, jQuery object, or CSS selector
        type: 'inline',
        removalDelay: 500
      }
    });
  }

  $("div.text").hide();
  $(".box h3").click(function(){
    $(this).next(".text").slideToggle("slow");
  })
};

$(document).ready(ready);
$(document).on('page:load', ready);