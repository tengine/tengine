# -*- coding: utf-8 -*-

class CucumberSession

  @@SESSION

  class << self
    def session
      @@SESSION ||= {}
    end
  end

end
