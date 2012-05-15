if RUBY_VERSION < "1.9.3"
  class Module
    private
    # Suppresses no-method error for earlier rubies
    def private_constant name
      # do nothing
    end
  end
end
