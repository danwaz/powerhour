//APP JS
$(function() {
  return console.log('app loaded');
});

$('.dropdown-toggle').on('click', function() {
  var parent;
  parent = $(this).parent();
  $(parent).toggleClass('dropToggle');
  if ($(parent).hasClass('dropToggle')) {
    return $(parent).find('ul').slideDown('fast');
  } else {
    return $(parent).find('ul').slideUp('fast');
  }
});

$('.dropdown-toggle').parent().find('a').on('click', function() {
  $(this).parents('ul').slideUp('fast');
  return $('.btn-group').removeClass('dropToggle');
});
