class Object
  def require_with_component_fu(file)
    __component_fu_get_file(file) do |file|
      require_without_component_fu file
    end
  end
  alias_method :require_without_component_fu, :require
  alias_method :require, :require_with_component_fu

  def load_with_component_fu(file)
    __component_fu_get_file(file) do |file|
      load_without_component_fu file
    end
  end
  alias_method :load_without_component_fu, :load
  alias_method :load, :load_with_component_fu

  private
  def __component_fu_get_file(file)
    component_fu_file_exists = false
    ComponentFu::ComponentManager.load_paths.each do |path|
      full_path = File.join(path, File.basename(file))
      full_path_rb = "#{full_path}.rb"
      if File.exists?(full_path_rb)
        component_fu_file_exists = true
        yield(full_path_rb)
      end
    end
    begin
      yield(file)
    rescue Exception => e
      raise(e) unless component_fu_file_exists
    end
  end
end