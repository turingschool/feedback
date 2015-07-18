class InviteSet < ActiveRecord::Base
  def deliver!
    self.delivered = true
    self.save!
  end
end
