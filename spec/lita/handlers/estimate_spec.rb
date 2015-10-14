require "spec_helper"

describe Lita::Handlers::Estimate, lita_handler: true do

  describe "routing" do

    ['US123', 'us123', 'SEARCH-01', 'SEARCH_02', 'SEARCH.2.1'].each do |story_format|
      it { is_expected.to route_command("estimate #{story_format} as 1").to(:estimate) }
      it { is_expected.to route_command("#{story_format} estimates").to(:show_estimates) }
      it { is_expected.to route_command("#{story_format} estimators").to(:show_estimators) }
      it { is_expected.to route_command("#{story_format} estimates reset").to(:reset_estimates) }
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

    it "should list estimates" do
      subject.redis.hset('estimate:US123', 'Peter', '5')
      subject.redis.hset('estimate:US123', 'Paula', '3')
      send_command('US123 estimates')
      expect(lines(replies.last)).to eq([
        "3 (Paula)",
        "5 (Peter)",
        "4.0 (Average)"
      ])
    end

    it "should show a message if no estimates are found" do
      send_command('US456 estimates')
      expect(replies.last).to eq('No estimates yet for US456')
    end

  end

  describe "show estimators" do

    it "should list estimates" do
      subject.redis.hset('estimate:US123', 'Paula', '3')
      subject.redis.hset('estimate:US123', 'Peter', '5')
      send_command('US123 estimators')
      expect(lines(replies.last)).to eq([
        "Paula",
        "Peter"
      ])
    end

    it "should show a message if no estimates are found" do
      send_command('US456 estimators')
      expect(replies.last).to eq('No estimators yet for US456')
    end

  end

  describe "reset estimates" do

    it "should reset estimates" do
      subject.redis.hset('estimate:US123', 'Peter', '5')
      subject.redis.hset('estimate:US123', 'Paula', '3')
      send_command('US123 estimates reset')
      expect(subject.redis.hgetall('estimate:US123')).to eq({})
    end

    it "should confirm the reset" do
      send_command('US123 estimates reset')
      expect(replies.size).to eq(1)
      expect(replies.last).to eq("Estimates reset for US123")
    end

  end

end
