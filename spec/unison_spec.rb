require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UnisonCommand do
  it "should return unison command" do
    uc = UnisonCommand.new("pref", "root1", "root2")
    uc.execute(true).should == ["unison", "pref", "root1", "root2"]
  end

  it "should execute unison command" do
    Kernel.should_receive(:system).with("unison", "pref", "root1", "root2")
    uc = UnisonCommand.new("pref", "root1", "root2")
    # Because exit code is invalid, an error occurs.
    lambda do
      uc.execute
    end.should raise_error
  end

  it "should return unison command with a boolean option" do
    uc = UnisonCommand.new("pref", "root1", "root2", :auto => true)
    uc.execute(true).should == ["unison", "pref", "root1", "root2", "-auto"]
  end

  it "should return unison command with a boolean option false" do
    uc = UnisonCommand.new("pref", "root1", "root2", :auto => false)
    uc.execute(true).should == ["unison", "pref", "root1", "root2", "-auto=false"]
  end

  it "should return unison command with two arguments and a boolean option" do
    uc = UnisonCommand.new("root1", "root2", :auto => true)
    uc.execute(true).should == ["unison", "root1", "root2", "-auto"]
  end

  it "should return unison command with one argument with a boolean option" do
    uc = UnisonCommand.new("pref", :auto => true)
    uc.execute(true).should == ["unison", "pref", "-auto"]
  end

  it "should return unison command with a string option" do
    uc = UnisonCommand.new("root1", "root2", :force => "root2")
    uc.execute(true).should == ["unison", "root1", "root2", "-force", "root2"]
  end

  it "should return unison command with an array option" do
    uc = UnisonCommand.new("root1", "root2", :path => ["Document", "Desktop"])
    uc.execute(true).should == ["unison", "root1", "root2", "-path", "Document", "-path", "Desktop"]
  end

  it "should return unison command with a string option for an array type" do
    uc = UnisonCommand.new("root1", "root2", :path => "Document")
    uc.execute(true).should == ["unison", "root1", "root2", "-path", "Document"]
  end

  it "should return unison command with multiple options" do
    uc = UnisonCommand.new("root1", "root2", :force => "root2", :path => ["Document", "Desktop"], :auto => true)
    uc.execute(true).should == ["unison", "root1", "root2", "-force", "root2",
                                "-path", "Document", "-path", "Desktop", "-auto"]
  end

  it "should raise UnisonCommand::InvalidOption" do
    uc = UnisonCommand.new("root1", "root2", :backuplocation => "invalid")
    lambda do
      uc.execute
    end.should raise_error(UnisonCommand::InvalidOption)
  end

  it "should raise UnisonCommand::InvalidOption" do
    uc = UnisonCommand.new("root1", "root2", :auto => 'true')
    lambda do
      uc.execute
    end.should raise_error(UnisonCommand::InvalidOption)
  end

  it "should raise UnisonCommand::NonExistentOption" do
    uc = UnisonCommand.new("root1", "root2", :autoo => true)
    lambda do
      uc.execute
    end.should raise_error(UnisonCommand::NonExistentOption)
  end

  it "should change unison path" do
    uc = UnisonCommand.new("root1", "root2")
    uc.command = "/usr/local/bin/unison"
    uc.execute(true).should == ["/usr/local/bin/unison", "root1", "root2"]
  end

  it "should return :success for run with exit code of 0" do
    Kernel.should_receive(:system).with("unison", "root1", "root2")
    uc = UnisonCommand.new("root1", "root2")
    uc.stub(:get_exit_status).and_return(0)
    uc.execute.should == :success
  end

  it "should return :skipped for a run with exit code of 1" do
    Kernel.should_receive(:system).with("unison", "root1", "root2")
    uc = UnisonCommand.new("root1", "root2")
    uc.stub(:get_exit_status).and_return(1)
    uc.execute.should == :skipped
  end

  it "should return :non_fatal_error for a run with exit code of 2" do
    Kernel.should_receive(:system).with("unison", "root1", "root2")
    uc = UnisonCommand.new("root1", "root2")
    uc.stub(:get_exit_status).and_return(2)
    uc.execute.should == :non_fatal_error
  end

  it "should return :fatal_error for a run with exit code of 3" do
    Kernel.should_receive(:system).with("unison", "root1", "root2")
    uc = UnisonCommand.new("root1", "root2")
    uc.stub(:get_exit_status).and_return(3)
    uc.execute.should == :fatal_error
  end

  it "should return raise exception when an unknown exit code is returned" do
    Kernel.should_receive(:system).with("unison", "root1", "root2")
    uc = UnisonCommand.new("root1", "root2")
    uc.stub(:get_exit_status).and_return(4)
    lambda do
      uc.execute
    end.should raise_error
  end

  it "should handle Process::Status for $?" do
    Kernel.should_receive(:system).with("unison", "root1", "root2")
    uc = UnisonCommand.new("root1", "root2")
    mock = Object.new
    mock.stub(:exitstatus).and_return(0)
    uc.stub(:get_execute_result).and_return(mock)
    uc.execute.should == :success
  end
end
