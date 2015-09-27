require "spec_helper"

describe Lita::Handlers::Estimate, lita_handler: true do

  describe "routing" do

    ['US123', 'us123', 'SEARCH-01', 'SEARCH_02', 'SEARCH.2.1'].each do |story_format|
      it { is_expected.to route_command("estimate #{story_format} as 1").to(:estimate) }
      it { is_expected.to route_command("#{story_format} estimates").to(:show_estimates) }
    end

  end

  describe "estimate" do

    it "should persist estimates" do
      carl = Lita::User.create(123, name: "Carl")
      send_command('estimate US123 as 5', :as => carl)
      expect(subject.redis.hget('estimate:US123', 'Carl')).to eq("5")
    end

    it "should confirm the estimate" do
      carl = Lita::User.create(123, name: "Carl")
      send_command('estimate US123 as 5', :as => carl)
      expect(replies.last).to eq('Thanks!')
    end

    it "should reject the estimate if it is not a fibonacci number" do
      carl = Lita::User.create(123, name: "Carl")
      send_command('estimate US123 as 4', :as => carl)
      expect(subject.redis.hget('estimate:US123', 'Carl')).to be_nil
      expect(replies.last).to eq('Please use a Fibonacci number not larger than 13')
    end

  end

  describe "show estimates" do

    before(:each) do
      subject.redis.hset('estimate:US123', 'Peter', '5')
      subject.redis.hset('estimate:US123', 'Paula', '3')
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
