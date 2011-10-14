# -*- coding: utf-8 -*-

module Tengine::Job::RootJobnetTemplatesHelper
  def sort_order(req, sym)
    if sort = req.query_parameters[:sort]
      order = (sort[sym.to_s].to_s == "asc") ? "desc" : "asc"
      return {sym => order}
    end
    return {sym => "asc"}
  end
end
