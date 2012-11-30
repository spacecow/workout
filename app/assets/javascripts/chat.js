$(function(){
  if ($("div#chat").length > 0){
    //setTimeout(updateChat, 1000000);
  }
});

function updateChat(){
  var after = $("div#chat li.noticement:last-child").data("time");
  var url = $("div#chat").data("url")
  $.getScript(url + "?after=" + after);
  setTimeout(updateChat, 1000000);
}
