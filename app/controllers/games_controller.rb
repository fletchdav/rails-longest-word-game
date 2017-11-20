require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    alphabet = ("A".."Z").to_a
    @letters = Array.new(10) { alphabet.sample(1).join }
  end

  def score
    letters = params[:grid]
    attempt = params[:attempt]
    response = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    if response["found"]
      hash(attempt)
      if hash(attempt).all? { |key, value| letters.include?(key) && value <= letters.count(key) }
        @answer = "Congratulations ! #{attempt.upcase} is an english word"
      else
        @answer = "#{attempt.upcase} is not built out of #{letters.gsub(" ",", ")}"
      end
    else
      @answer = "#{attempt.upcase} is not a valid English word"
    end
  end

  private

  def hash(string)
    string_hash = {}
    string.split("").each { |letter| string_hash[letter.upcase] = string.split("").count(letter) }
    string_hash
  end

end
