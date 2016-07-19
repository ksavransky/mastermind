class Code

  attr_reader :pegs

  PEGS = {red: "R", green: "G", blue: "B", yellow: "Y", orange: "O", purple: "P"}

  def initialize(pegs)
    @pegs = pegs
  end

  def self.random
    Code.new(PEGS.values.sample(4))
  end

  def self.parse(input)
    peg_ary = input.split("").map(&:capitalize)

    raise "Not all the pegs are the right color!" if !peg_ary.all? {|peg| PEGS.values.include?(peg)}

    Code.new(peg_ary)

  end

  def [](i)
    pegs[i]
  end

  def ==(other_code)
    return false if other_code.class != Code
    self.pegs == other_code.pegs
  end

  def exact_matches(other_code)
    exact_match_number = 0

    pegs.each_with_index do |peg, i|
      exact_match_number += 1 if peg == other_code.pegs[i]
    end

    exact_match_number

  end

  def near_matches(other_code)

    total = 0
    PEGS.values.each do |color|
      near_for_color = [pegs.count(color), other_code.pegs.count(color)].min

      pegs.each_with_index do |peg, i|
        if peg == color && peg == other_code.pegs[i]
          near_for_color -= 1
        end
      end

      total += near_for_color
    end
    total
  end

end


class Game

  def initialize(secret_code = Code.random)
    @turns = 0
    @secret_code = secret_code
  end

  attr_reader :secret_code

  def get_guess
    puts "Please guess a code"
    begin
      Code.parse(gets.chomp)
    rescue
      puts "Try again, you entered a wrong peg combo."
      retry
    end
  end

  def display_matches(code)
    puts "You guessed #{code.exact_matches(secret_code)} exact matches:"
    puts "You guessed #{code.near_matches(secret_code)} near matches:"
  end

  def play
    while
      current_guess = get_guess

      if correct_guess?(current_guess)
        break
      else
        @turns += 1
        break if out_of_turns?
      end

      display_matches(current_guess)
    end

  end

  private

  def correct_guess?(guess)
    if guess.pegs == secret_code.pegs
      puts "You guessed the secret code! You won!"
      return true
    end
    false
  end

  def out_of_turns?
    if @turns == 10
      puts "You lost because you are out of turns!"
      puts "The secret code was #{secret_code.pegs}."
      return true
    end
    false
  end

end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
