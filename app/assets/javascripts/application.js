// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
// require_tree .
//= require bootstrap-sprockets
//= require moment
//= require bootstrap-datetimepicker

$('body').on("click", '.search-entry a', function() {
  var entry = $(this).closest('.search-entry');
  var list = $('#sponsor-list');
  var idList = list.data('id-list');
  var id = entry.data('wishlist-id');

  if (idList.length == 0) {
    idList = [];
  }

  if (idList.indexOf(id) >= 0) {
    return false;
  }

  idList[idList.length] = id;
  updateCheckoutUrl(idList);
  list.data('id-list', idList);

  entry.find('a').addClass('disabled');
  var li = $('<li class="list-group-item">' + entry.find('h3').html() + '<button class="close btn-sm"><span class="glyphicon glyphicon-sm glyphicon-remove"></span></button></li>');
  li.data('wishlist-id', id);
  list.find('ul').append(li);

  return false;
});

$('body').on("click", '.list-group-item button', function() {
  var entry = $(this).closest('li');
  var list = $('#sponsor-list');
  var id = entry.data('wishlist-id');
  var idList = list.data('id-list');

  idList.splice(idList.indexOf(id), 1);
  updateCheckoutUrl(idList);
  list.data('id-list', idList);

  entry.remove();

  $(".search-entry[data-wishlist-id=" + id + "] a").removeClass('disabled');

  return false;
});

function updateCheckoutUrl(idList) {
  var checkoutBtn = $('#checkout-btn');
  if (idList.length == 0) {
    $('#empty-list-message').show();
    checkoutBtn.addClass('disabled');
  } else {
    $('#empty-list-message').hide();
    checkoutBtn.removeClass('disabled');
  }

  var href = checkoutBtn.attr('href');
  href = href.replace(/\?.+/, "") + "?id_list=" + idList;
  checkoutBtn.attr('href', href);
}
