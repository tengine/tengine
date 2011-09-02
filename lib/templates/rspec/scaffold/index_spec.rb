require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= class_name.underscore.pluralize %>/index.html.<%= options[:template_engine] %>" do
  before(:each) do
    assign(:<%= file_name.pluralize %>, [
<% [1,2].each_with_index do |id, model_index| -%>
      stub_model(<%= class_name %><%= output_attributes.empty? ? (model_index == 1 ? ')' : '),') : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
        :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
      <%= model_index == 1 ? ')' : '),' %>
<% end -%>
<% end -%>
    ])
  end

  it "renders a list of <%= ns_table_name %>" do
    render
<% for attribute in output_attributes -%>
<% if webrat? -%>
    rendered.should have_selector("tr>td", :content => <%= value_for(attribute) %>.to_s, :count => 2)
<% else -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
<%    case attribute.type -%>
<%    when :array then -%>
    assert_select "tr>td", :text => <%= attribute.default.join(",").inspect %>, :count => 2
<%    when :hash then -%>
    assert_select "tr>td>pre", :text => CGI.escapeHTML(YAML.dump(<%=  attribute.default %>)), :count => 2
<%    else -%>
    assert_select "tr>td", :text => <%= value_for(attribute) %>.to_s, :count => 2
<%    end -%>
<% end -%>
<% end -%>
  end
end
