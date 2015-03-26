require 'spec_helper'

RSpec.describe User, type: :model do

  describe "corect add roles" do
    before(:each) do
    @user = create(:user)
  end
 
  it "should not approve incorrect roles" do
    @user.add_role "manager"
    @user.has_role?(:admin).should eq false
  end
 
  it "should approve correct roles" do
    @user.add_role "admin"
    @user.has_role?(:admin).should be true
    end
end
 
  subject(:ability){ Ability.new(user) }
  let(:user){ nil }

  context "when is an account user" do
    let(:user){ create(:user) }
    it{ should_not be_able_to(:manage, :all) }
  end
 
  context "when is an account manager" do
    let(:user){ create(:manager) }
    it{ should be_able_to(:manage, :all) }
  end
 
  context "when is an account admin" do
    let(:user){ create(:admin) }
    it{ should be_able_to(:manage, :all) }
  end


end