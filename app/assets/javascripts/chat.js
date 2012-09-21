$(function(){
  if ($("div#chat").length > 0){
    setTimeout(updateChat, 100000);
  }
});

function updateChat(){
  var after = $("div#chat div.comment:last-child").data("time");
  var url = $("div#chat").data("url")
  $.getScript(url + "?after=" + after);
  setTimeout(updateChat, 100000);
}
