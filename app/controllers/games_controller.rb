require "json"
require "open-uri"

class GamesController < ApplicationController

  def new
    @letters = generate_array
  end

  def score
    @word = params['word']
    @letters = params['letters']
    @good = word_is_included?(@word, @letters)
    @found = api_request(@word)
  end

  def generate_array
    array = []
    10.times do
      array << ('a'..'z').to_a.sample
    end
    array
  end

  private

  def word_is_included?(word, letters)
    word = word.split('')
    letters = letters.split('')

    word.each do |letter|
      if letters.include?(letter)
        letters.delete_at(letters.find_index(letter))
      else
        return false
      end
    end
    true
  end

  def api_request(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    user["found"]
  end
end
