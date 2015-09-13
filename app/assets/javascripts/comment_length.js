$(document).ready(function(){
  $('#new-submission-comment').on('keydown', function(){
    var text = $('textarea.comment').val();
    $('span#char-count').replaceWith("<span id='char-count'>" + (text.length+1) + "</span>");

    if(text.length >=  "240") {
      $('#characters').css('background-color', 'red').css('width', '200').addClass('text-center');
    } else {
      $('#characters').css('background-color', '').css('width', '200').addClass('text-center');
    }
  });

});