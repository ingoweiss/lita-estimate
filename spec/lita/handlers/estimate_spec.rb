require "spec_helper"

describe Lita::Handlers::Estimate, lita_handler: true do

  describe "routing" do

    it { is_expected.to route_command("estimate US123 as 1").to(:estimate) }

  end

  describe "estimating" do

    it "should persist estimates" do
      carl = Lita::User.create(123, name: "Carl")
      send_command('estimate US123 as 5', :as => carl)
      expect(subject.redis.get('US123:Carl')).to eq("5")
    end

  end

end
