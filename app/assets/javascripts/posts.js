$(function(){
  $("input#post_day_attributes_date").datepicker({
    dateFormat: 'yy-mm-dd'
  });
  $("input#post_time_of_day").datetimeEntry({
    datetimeFormat: 'H:M'
  });

  var training_type_id = "input#post_training_type_tokens";
  $(training_type_id).tokenInput($(training_type_id).data('url'), {
    preventDuplicates: true,
    prePopulate: $(training_type_id).data('load')
  });
});
