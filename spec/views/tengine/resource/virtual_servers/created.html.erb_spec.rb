require 'spec_helper'

describe "tengine/resource/virtual_servers/created.html.erb" do
  it "renders attributes in <p>" do
    render(:file => "tengine/resource/virtual_servers/created")

    notice = I18n.t("tengine.resource.virtual_servers.created.notice.created")
    rendered.should match(/#{notice}/)
  end

  context "assigns the requested provided_ids as @provided_ids" do
    before do
      assign(:provided_ids, ["1234", "0987"])
    end

    it "renders attributes in <p>" do
      render(:file => "tengine/resource/virtual_servers/created")

      notice = I18n.t("tengine.resource.virtual_servers.created.notice.created_with_provided_ids")
      rendered.should match(/#{notice}/)
      rendered.should match(/1234/)
      rendered.should match(/0987/)
    end
  end
end
