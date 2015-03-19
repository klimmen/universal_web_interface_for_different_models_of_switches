// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-select
//= require jquery_ujs
//= require turbolinks
//= require spin
//= require_tree .

//$(document).ready(function(){
//$('.selectpicker').selectpicker({
//      style: 'btn-info',
//      size: 1
//  });
//});
$(document).on("page:change",function(){
  $('.go_spiner').click(function(){
    displayDate()
  })   

  $("input[name='all_ports']").click(function(){
    GetSelectedItem()
  })
  $("input[name='all_pvids']").keyup(function(){
     GetSelectedItemPVIDS(this.value)
    }) 
  })

function displayDate(){    
  var opts = {
    lines: 13, // The number of lines to draw
    length: 12, // The length of each line
    width: 3, // The line thickness
    radius: 6, // The radius of the inner circle
    corners: 1, // Corner roundness (0..1)
    rotate: 0, // The rotation offset
    color: '#FFF', // #rgb or #rrggbb
    speed: 1, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false, // Whether to use hardware acceleration
    className: 'spinner', // The CSS class to assign to the spinner
    zIndex: 2e9, // The z-index (defaults to 2000000000)
    top: 'auto', // Top position relative to parent in px
    left: 'auto' // Left position relative to parent in px      
  };
  target = document.getElementById('spinnerContainer');
  spinner = new Spinner(opts).spin(target);    
} 


function GetSelectedItem() {
  chosen = ""
  for (i = 0; i <document.getElementsByName("all_ports").length; i++) {
    if (document.getElementsByName("all_ports")[i].checked) {
      chosen = document.getElementsByName("all_ports")[i].value
    }
  }

  for (i = 0; i <document.getElementsByClassName("radio_button").length; i++) {
    if (document.getElementsByClassName("radio_button")[i].value == chosen){
      document.getElementsByClassName("radio_button")[i].checked = true
    }
  }
}

function GetSelectedItemPVIDS(input_string){
  for (i = 0; i <document.getElementsByClassName("input_fild").length; i++){
    document.getElementsByClassName("input_fild")[i].value = input_string
  }
}