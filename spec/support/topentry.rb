def create_entry(params = {})
  #h = {day:Day.find_or_create_by_date('2012-7-14'), training_type_tokens:TrainingType.find_or_create_by_name('Swimming').id.to_s}

  h = {}
  h[:day] = Day.find_or_create_by_date(params[:date]) if params[:date]
  h[:user] = params[:user] if params[:user]
  h[:duration] = params[:duration] if params[:duration]
  FactoryGirl.create(:topentry,h)
end
