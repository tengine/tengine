require 'tengine/job/structure'

module Tengine::Job::Structure::Tree
  def root
    (parent = self.parent) ? parent.root : self
  end

  def ancestors
    if parent = self.parent
      parent.ancestors + [parent]
    else
      []
    end
  end

end
