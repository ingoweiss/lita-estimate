module Lita
  module Handlers
    class Estimate < Handler

      route /estimate (US\d+) as (\d+)/, :estimate
      route /(US\d+) estimates/,         :show_estimates

      def estimate(response)
        story, points = response.matches.first
        redis.set([story,response.user.name].join(':'), points)
      end

      def show_estimates(response)
        story = response.matches.flatten.first
        estimates = []
        redis.keys("#{story}:*").each do |key|
          estimator = key.split(':').last
          estimates << (estimate = redis.get(key).to_i)
          response.reply("#{estimator}: #{estimate}")
        end
        average = estimates.inject{ |sum, e| sum + e }.to_f / estimates.size
        response.reply("Average: #{average}")
      end

      Lita.register_handler(self)
    end
  end
end
