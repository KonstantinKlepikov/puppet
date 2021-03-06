require 'spec_helper'

describe Puppet::Type.type(:package).provider(:hpux) do
  before(:each) do
    # Create a mock resource
    @resource = stub 'resource'

    # A catch all; no parameters set
    @resource.stubs(:[]).returns(nil)

    # But set name and source
    @resource.stubs(:[]).with(:name).returns "mypackage"
    @resource.stubs(:[]).with(:source).returns "mysource"
    @resource.stubs(:[]).with(:ensure).returns :installed

    @provider = subject()
    @provider.stubs(:resource).returns @resource
  end

  it "should have an install method" do
    @provider = subject()
    expect(@provider).to respond_to(:install)
  end

  it "should have an uninstall method" do
    @provider = subject()
    expect(@provider).to respond_to(:uninstall)
  end

  it "should have a swlist method" do
    @provider = subject()
    expect(@provider).to respond_to(:swlist)
  end

  context "when installing" do
    it "should use a command-line like 'swinstall -x mount_all_filesystems=false -s SOURCE PACKAGE-NAME'" do
      @provider.expects(:swinstall).with('-x', 'mount_all_filesystems=false', '-s', 'mysource', 'mypackage')
      @provider.install
    end
  end

  context "when uninstalling" do
    it "should use a command-line like 'swremove -x mount_all_filesystems=false PACKAGE-NAME'" do
      @provider.expects(:swremove).with('-x', 'mount_all_filesystems=false', 'mypackage')
      @provider.uninstall
    end
  end
end
