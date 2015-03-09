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
//= require_tree .

//$(document).ready(function(){
//$('.selectpicker').selectpicker({
//      style: 'btn-info',
//      size: 1
//  });
//});
$(document).on("page:change",function(){
 if( /((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)/.test( location.href)){
 	var name = document.getElementById("switch_name").innerHTML
 	var ip = document.getElementById("switch_ip").innerHTML
 	var model = document.getElementById("switch_model").innerHTML
 	var firmware = document.getElementById("switch_firmware").innerHTML
 	var mac = document.getElementById("switch_mac").innerHTML
 console.log(name, ip, model, firmware, mac)
 }
})
