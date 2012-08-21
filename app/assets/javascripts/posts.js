$(function(){
  $("input#post_date").datepicker({
    dateFormat: 'yy-mm-dd'
  });
  $("input#post_time_of_day").datetimeEntry({
    datetimeFormat: 'H:M'
  });
});
