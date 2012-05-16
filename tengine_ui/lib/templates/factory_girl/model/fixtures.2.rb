# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :<%= class_name.underscore.inspect %> do
<% for attribute in attributes -%>
<% case attribute.type
   when :hash then -%>
    <%= attribute.name %>(<%= attribute.default.inspect %>)
<% else -%>
    <%= attribute.name %>(<%= attribute.default.inspect %>)
<% end -%>
<% end -%>
  end
end
