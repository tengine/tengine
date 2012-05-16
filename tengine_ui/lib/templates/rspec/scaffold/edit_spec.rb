require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= class_name.underscore.pluralize %>/edit.html.<%= options[:template_engine] %>" do
  before(:each) do
    @<%= ns_file_name %> = assign(:<%= ns_file_name %>, stub_model(<%= class_name %><%= output_attributes.empty? ? '))' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= attribute.default.inspect %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    ))\n" -%>
  end

  it "renders the edit <%= ns_file_name %> form" do
    render

<% if webrat? -%>
    rendered.should have_selector("form", :action => <%= ns_file_name %>_path(@<%= ns_file_name %>), :method => "post") do |form|
<% for attribute in output_attributes -%>
<%   if attribute.reference? -%>
      form.should have_selector("<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>_id", :name => "<%= file_name %>[<%= attribute.name %>_id]")
<%   else -%>
<%   suffix = (attribute.type == :array) ? "_text" : (attribute.type == :hash) ? "_yaml" : "" -%>
      form.should have_selector("<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %><%= suffix %>", :name => "<%= file_name %>[<%= attribute.name %><%= suffix %>]")
<%   end -%>
<% end -%>
    end
<% else -%>
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => <%= index_helper %>_path(@<%= ns_file_name %>), :method => "post" do
<% for attribute in output_attributes -%>
<%   if attribute.reference? -%>
      assert_select "<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>_id", :name => "<%= file_name %>[<%= attribute.name %>_id]"
<%   else -%>
<%   suffix = (attribute.type == :array) ? "_text" : (attribute.type == :hash) ? "_yaml" : "" -%>
      assert_select "<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %><%= suffix %>", :name => "<%= file_name %>[<%= attribute.name %><%= suffix %>]"
<%   end -%>
<% end -%>
    end
<% end -%>
  end
end
