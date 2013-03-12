require 'tengine/job/structure'

module Tengine::Job::Structure::Tree
  def root?
    parent.nil?
  end

  def root
    root? ? self : parent.root
  end

  def ancestors
    if parent = self.parent
      parent.ancestors + [parent]
    else
      []
    end
  end

end
