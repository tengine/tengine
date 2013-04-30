require 'tengine/job'

module Tengine::Job::Structure
  autoload :Category               , "tengine/job/structure/category"
  autoload :NamePath               , "tengine/job/structure/name_path"
  autoload :Tree                   , "tengine/job/structure/tree"

  autoload :Visitor                , "tengine/job/structure/visitor"

  autoload :EdgeBuilder            , "tengine/job/structure/edge_builder"

  autoload :JobnetBuilder          , "tengine/job/structure/jobnet_builder"
  autoload :JobnetFinder           , "tengine/job/structure/jobnet_finder"

  autoload :ElementSelectorNotation, "tengine/job/structure/element_selector_notation"

  class Error < StandardError
  end

end
