module Tengine::Job::DslEvaluator
  private
  def __stack_instance_variable__(ivar_name, value)
    backup = instance_variable_get(ivar_name)
    instance_variable_set(ivar_name, value)
    begin
      return yield if block_given?
    ensure
      instance_variable_set(ivar_name, backup)
    end
  end

end
