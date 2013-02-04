
module ExampleFixtures1
  module_function

  def build
    Time.zone = ActiveSupport::TimeZone.new("Tokyo")
    Tengine::Resource::Provider.delete_all
    Tengine::Resource::Server.delete_all
    Tengine::Resource::Provider.create!({
        name: "ManualControl",
        type_key: :manual_control,
      }).tap do |provider|
      provider.physical_servers.create!({
          name: "physical_server_1",
          addresses: {private_ip_address: "192.168.1.11", private_dns_name: "physical#1"},
          created_at: Time.zone.parse("2013/01/21 10:00:00"),
          updated_at: Time.zone.parse("2013/02/03 12:00:00"),
        }).tap do |server|
        server.guest_servers.create!({
            name: "virtual_server_1",
            provider_id: provider.id,
            provided_id: "virtual_server_1",
            addresses: {private_ip_address: "192.168.5.101", private_dns_name: "virtual#1"},
            created_at: Time.zone.parse("2013/02/01 10:00:00"),
            updated_at: Time.zone.parse("2013/02/01 12:00:00"),
          })
        server.guest_servers.create!({
            name: "virtual_server_2",
            provider_id: provider.id,
            provided_id: "virtual_server_2",
            addresses: {private_ip_address: "192.168.5.102", private_dns_name: "virtual#2"},
            created_at: Time.zone.parse("2013/02/01 18:00:00"),
            updated_at: Time.zone.parse("2013/02/01 18:00:00"),
          })
      end
      provider.physical_servers.create!({
          name: "physical_server_2",
          addresses: {private_ip_address: "192.168.1.12", private_dns_name: "physical#2"},
          created_at: Time.zone.parse("2013/01/31 10:00:00"),
          updated_at: Time.zone.parse("2013/02/01 12:00:00"),
        }).tap do |server|
      end
    end

    Tengine::Resource::Provider.create!({
        name: "goku_at_ec2_ap-northeast-1",
        type_key: :normal
      }).tap do |provider|
      provider.physical_servers.create!({
          name: "ap-northeast-1a",
          provided_id: "ap-northeast-1a",
          status: "available",
          created_at: Time.zone.parse("2012/12/31 10:00:00"),
          updated_at: Time.zone.parse("2013/02/04 10:00:00"),
        }).tap do |server|
        server.guest_servers.create!({
            name: "AWS_Instance_1",
            provider_id: provider.id,
            provided_id: "i-12345678",
            addresses: {
              private_ip_address: "10.162.153.11",
              private_dns_name: "ip-10.162.153.11-ap-northeast-1.compute.internal",
              dns_name: "ec2-184-72-20-11.ap-northeast-1.compute.amazonaws.com",
              ip_address: "184.72.20.11",
            },
            created_at: Time.zone.parse("2013/02/01 10:00:00"),
            updated_at: Time.zone.parse("2013/02/04 10:00:00"),
          })
      end
    end
  end
end
