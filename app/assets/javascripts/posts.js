$(function(){
  $("input#post_day_attributes_date").datepicker({
    dateFormat: 'yy-mm-dd'
  });
  $("input#post_time_of_day").datetimeEntry({
    datetimeFormat: 'H:M',
    spinnerImage: '/assets/spinnerDefault.png'
  });

  var training_type_id = "input#post_training_type_tokens";
  $(training_type_id).tokenInput($(training_type_id).data('url'), {
    preventDuplicates: true,
    prePopulate: $(training_type_id).data('load')
  });
});

function set_color_picker(element_name,color){
  $('div.coloritem').removeClass('cpselected');
  $('div#'+element_name).addClass('cpselected');
  $('input#hidden_color_picker').val(color);
  //items = document.getElementsByClassName('coloritem');
  //for(x=0;x<items.length;x++){
  //  //Element.removeClassName(items[x],'cpselected');
  //  //items[x].removeClass('cpselected');
  //  alert(items[x]);
  //}
  //Element.addClassName(element_name,'cpselected')
  //document.getElementById('hidden_color_picker').value = color
}
