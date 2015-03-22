require 'spec_helper'
require 'cancan'
require 'cancan/matchers'

describe Roles do
  
  describe "corect add roles" do
     before(:each) do
      @user = User.new
    end

  it "should not approve incorrect roles" do
    @user.add_role "user"
    @user.has_role?(:admin).should be_false
  end

  it "should approve correct roles" do
    @user.add_role "admin"
    @user.has_role?(:admin).should be_true
  end
 end

    subject(:ability){ Ability.new(@user) }
    let(:user){ nil }

   context "when is an account user" do
      let(:user){ FactoryGirl.create(:user) }

      it{ should_not be_able_to(:manage, :all) }
    end

    context "when is an account admin" do
      let(:admin){ FactoryGirl.create(:admin) }

      it{ should be_able_to(:manage, :all) }
    end
	
end