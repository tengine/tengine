module NetSshMock

  def mock_channel_fof_script_executable(ssh, base_name = "channel")
    channel_base = mock(:"#{base_name}_base", {wait: true})
    ssh.stub(:open_channel).and_yield(channel_base).and_return(channel_base)
    channel = mock(base_name.to_sym)
    channel_base.stub(:request_pty).and_yield(channel, true)
    channel
  end
end
