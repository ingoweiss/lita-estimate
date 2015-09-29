module Lita
  module Handlers
    class Estimate < Handler

      route /\Aestimate ([A-Za-z0-9_.-]+) as (\d+)\Z/, :estimate,        command: true, help: {"estimate STORY_ID as FIBONACCI_NUMBER" => "Records your estimate for the story"}
      route /\A([A-Za-z0-9_.-]+) estimates\Z/,         :show_estimates,  command: true, help: {"STORY_ID estimates" => "Lists all estimates for the story and their average"}
      route /\A([A-Za-z0-9_.-]+) estimators\Z/,        :show_estimators, command: true, help: {"STORY_ID estimators" => "Lists all estimators for the story"}
      route /\A([A-Za-z0-9_.-]+) estimates reset\Z/,   :reset_estimates, command: true, help: {"STORY_ID estimates reset" => "Reset all estimates for the story"}

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
        estimates = redis.hgetall(key(story))
        if estimates.empty?
          response.reply("No estimates yet for #{story}")
        else
          lines = []
          estimates.keys.sort.each do |estimator|
            lines << "#{estimator}: #{estimates[estimator]}"
          end
          average = estimates.values.inject(0){ |sum, e| sum + e.to_i }.to_f / estimates.size
          lines << "Average: #{average}"
          response.reply(lines.join("\n"))
        end
      end

      def show_estimators(response)
        story = response.matches.flatten.first
        estimates = redis.hgetall(key(story))
        if estimates.empty?
          response.reply("No estimators yet for #{story}")
        else
          response.reply(estimates.keys.sort.join("\n"))
        end
      end

      def reset_estimates(response)
        story = response.matches.flatten.first
        redis.del(key(story))
        response.reply("Estimates reset for #{story}")
      end

      def key(story)
        ['estimate', story].join(':')
      end

      Lita.register_handler(self)
    end
  end
end
