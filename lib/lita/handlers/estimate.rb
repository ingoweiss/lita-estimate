module Lita
  module Handlers
    class Estimate < Handler

      route /estimate ([A-Za-z0-9_.-]+) as (\d+)/, :estimate,       command: true, help: {"estimate STORY_ID as FIBONACCI_NUMBER" => "Records your estimate for the story"}
      route /([A-Za-z0-9_.-]+) estimates/,         :show_estimates, command: true, help: {"STORY_ID estimates" => "Lists all estimates for the story and their average"}
      route /([A-Za-z0-9_.-]+) estimators/,        :show_estimators, command: true, help: {"STORY_ID estimators" => "Lists all estimators for the story"}

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

      def show_estimators(response)
        story = response.matches.flatten.first
        redis.hgetall(key(story)).each do |estimator, estimate|
          response.reply(estimator)
        end
      end

      def key(story)
        ['estimate', story].join(':')
      end

      Lita.register_handler(self)
    end
  end
end
