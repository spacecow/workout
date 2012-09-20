module ApplicationHelper
  def present(array, klass=nil)
    if array.instance_of? Array
      object = array.shift
      parent = array.shift
    else
      object = array
      parent = nil
    end
    klass ||= "#{object.instance_of?(Class) ? object : object.class}Presenter".constantize
    presenter = klass.new(object, parent, self)
    yield presenter if block_given?
    presenter
  end
end
