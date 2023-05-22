require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { rand(65..90) }.map(&:chr)
  end

  def score
    grid = params[:grid]
    guess = params[:guess]
    endpoint = get_endpoint(guess)
    grid_check = check_letters(guess, grid)
    @score = compute_score(guess, endpoint, grid_check)
  end

  def get_endpoint(guess)
    url = "https://wagon-dictionary.herokuapp.com/#{guess}"
    endpoint_string = URI.open(url).read
    JSON.parse(endpoint_string)
  end

  def check_letters(guess, grid)
    guess.upcase.chars.all? { |letter| grid.include?(letter) && guess.upcase.count(letter) <= grid.count(letter) }
  end

  def compute_score(guess, endpoint, grid_check)
    if endpoint["found"] == true && grid_check == true
      score = guess.size
    else
      score = 0
    end
    return score
  end
end
