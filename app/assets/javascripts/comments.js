$(function(){
  $("form.new_comment").hide();
  $("a.comment").show();

  $("a.comment").click(function(){
    var link = ($(this).data('link'));
    $("form#"+link).show();
    $(this).next().show();
    $(this).hide();
    return false;
  });
  $("a.hide_comment").click(function(){
    var link = ($(this).data('link'));
    $("form#"+link).hide();
    $(this).prev().show();
    $(this).hide();
    return false;
  });
});
