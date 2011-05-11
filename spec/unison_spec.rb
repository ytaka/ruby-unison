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

end
