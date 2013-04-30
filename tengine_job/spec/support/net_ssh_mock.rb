# -*- coding: utf-8 -*-
module NetSshMock

  def mock_channel_fof_script_executable(ssh, base_name = "channel")
    channel_base = mock(:"#{base_name}_base", {wait: true})
    ssh.stub(:open_channel).and_yield(channel_base).and_return(channel_base)
    channel = mock(base_name.to_sym)
    channel_base.stub(:request_pty).and_yield(channel, true)
    channel
  end

  module HashAccess
    def [](key)
      @hash ||= {}
      @hash[key]
    end

    def []=(key, value)
      @hash ||= {}
      @hash[key] = value
    end

    def success
      lambda do |ch|
        client = self[:client]
        client.dispatch("#{client.one_time_token}\n")
      end
    end
  end

  def mock_shell_for_script_executable(ssh, base_name = "channel")
    channel_base = mock(:"#{base_name}_base", {wait: true})
    ssh.stub(:open_channel).and_yield(channel_base).and_return(channel_base)

    channel_pty = mock(:"#{base_name}_pty")
    channel_base.stub(:request_pty).and_yield(channel_pty, true)

    shell_ch = mock(:"#{base_name}_shell")
    shell_ch.extend(HashAccess)
    channel_pty.stub(:exec).with("#{ENV['SHELL']} -l").and_yield(shell_ch, true)

    shell_ch.stub(:on_extended_data)
    # shell_ch.stub(:on_data)

    Tengine::Job::Runtime::SshJob::ShellClient.any_instance.stub(:setup)
    shell_ch.should_receive(:send_data).with("export PS1=;\n").and_return{
      client = shell_ch[:client]
      client.dispatch("") # export PS1=; の結果
    }
    yield(shell_ch) if block_given?
    shell_ch.should_receive(:send_data).with("exit\n")
    shell_ch
  end


end
