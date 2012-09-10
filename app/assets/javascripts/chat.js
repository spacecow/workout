$(function(){
  if ($("div#chat").length > 0){
    setTimeout(updateChat, 10000);
  }
});

function updateChat(){
  var after = $("div#chat div.comment:last-child").data("time");
  $.getScript("/messages.js?after=" + after);
  setTimeout(updateChat, 10000);
}
