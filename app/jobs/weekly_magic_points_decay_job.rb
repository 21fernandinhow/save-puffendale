class WeeklyMagicPointsDecayJob < ApplicationJob
    queue_as :default
  
    def perform
      User.find_each(&:apply_weekly_decay!)
    end
end