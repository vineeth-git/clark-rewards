class User
  attr_accessor(:name, :score, :referrer, :accepted)
  def initialize(name, score, referrer, accepted)
    self.name = name
    self.score = score
    self.referrer = referrer
    self.accepted = accepted
  end
end
