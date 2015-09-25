module Lita
  module Handlers
    class Estimate < Handler

      route /estimate (US\d+) as (\d+)/, :estimate

      def estimate(response)
        story, points = response.matches.first
        redis.set([story,response.user.name].join(':'), points)
      end

      Lita.register_handler(self)
    end
  end
end
