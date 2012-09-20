$(function(){
  $("input#post_day_attributes_date").datepicker({
    dateFormat: 'yy-mm-dd'
  });
  var spinner_url = $('input#post_time_of_day').data('spinner-url');
  $("input#post_time_of_day").datetimeEntry({
    datetimeFormat: 'H:M',
    spinnerImage: spinner_url
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
}
