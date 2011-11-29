Given /^the following credentials:$/ do |credentials|
  credentials.hashes.each do |hash|
    Credential.create!(hash)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) credential$/ do |pos|
  visit credentials_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following credentials:$/ do |expected_credentials_table|
  expected_credentials_table.diff!(tableish('table tr', 'td,th'))
end
