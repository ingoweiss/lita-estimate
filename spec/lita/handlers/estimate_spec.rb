require "spec_helper"

describe Lita::Handlers::Estimate, lita_handler: true do

  describe "routing" do

    it { is_expected.to route_command("estimate US123 as 1").to(:estimate) }
    it { is_expected.to route_command("US123 estimates").to(:show_estimates) }

  end

  describe "estimate" do

    it "should persist estimates" do
      carl = Lita::User.create(123, name: "Carl")
      send_command('estimate US123 as 5', :as => carl)
      expect(subject.redis.hget('estimate:US123', 'Carl')).to eq("5")
    end

  end

  describe "show estimates" do

    before(:each) do
      peter = Lita::User.create(123, name: "Peter")
      paula = Lita::User.create(234, name: "Paula")
      send_command('estimate US123 as 5', :as => peter)
      send_command('estimate US123 as 3', :as => paula)
    end

    it "should list estimates" do
      send_command('US123 estimates')
      expect(replies.to_set).to eq(Set[
        "Paula: 3",
        "Peter: 5",
        "Average: 4.0"
      ])
    end

  end

end
