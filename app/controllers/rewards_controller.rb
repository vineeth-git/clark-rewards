class RewardsController < ApplicationController

  before_action :prepare_input_rows, only: [:calculate_rewards]

  # this method calculates the rewards for all users based on the recommendation acceptance
  # and render the scores of each users as a json object
  def calculate_rewards
    @all_users = {}
    @input_rows.each do |row|
      handle_recommends(row) if 'recommends'.eql?(row.operation)
      handle_accepts(row) if 'accepts'.eql?(row.operation)
    end
    render status: 200, json: result
  end

  private

  def result
    user_scores = {}
    @all_users.values.each do |user|
      user_scores[user.name] = user.score if user.score.positive?
    end
    user_scores
  end

  # when a user recommends another user, thos method creates the new user and links as recommender to the other user
  def handle_recommends(row)
    @all_users[row.user] ||= User.new(row.user, 0, nil, @all_users.empty?)
    @all_users[row.recommends] ||= User.new(row.recommends, 0, @all_users[row.user], false)
  end

  # when the user accepts the invite, all of his referral ancestors to get the reward points will be done here
  def handle_accepts(row)
    accepted_user = @all_users[row.user]
    accepted_user.accepted = true
    score = 1
    while(accepted_user.referrer) do
      accepted_user.referrer.score += score if accepted_user.referrer.accepted
      accepted_user = accepted_user.referrer
      score /= 2.to_f
    end
  end

  # reads the file input from the request & buils a list of object to for computing the score
  def prepare_input_rows
    input_row = []
    File.open(params[:file].tempfile) do |file|
      file.each { |line| input_row << line.chomp }
    end
    @input_rows = input_row.map { |row| InputRow.new(row) }
    @input_row = @input_rows.sort_by { |row| [row.date, row.time] }
  rescue Exception
    render status: 422, json: { error: 'error parsing file' }
  end
end
