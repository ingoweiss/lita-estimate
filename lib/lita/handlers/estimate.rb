module Lita
  module Handlers
    class Estimate < Handler

      route /estimate (US\d+) as (\d+)/, :estimate
      route /(US\d+) estimates/,         :show_estimates

      def estimate(response)
        story, points = response.matches.first
        if ['1','2','3','5','8','13'].include?(points)
          redis.hset(key(story), response.user.name, points)
          response.reply('Thanks!')
        else
          response.reply('Please use a Fibonacci number not larger than 13')
        end
      end

      def show_estimates(response)
        story = response.matches.flatten.first
        estimates = []
        redis.hgetall(key(story)).each do |estimator, estimate|
          response.reply("#{estimator}: #{estimate}")
          estimates << estimate.to_i
        end
        average = estimates.inject{ |sum, e| sum + e }.to_f / estimates.size
        response.reply("Average: #{average}")
      end

      def key(story)
        ['estimate', story].join(':')
      end

      Lita.register_handler(self)
    end
  end
end
