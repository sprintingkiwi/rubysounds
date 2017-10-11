require 'rubysounds'

speak 'Hello, I am Ruby'
speak 'What is your name?'

name = gets.chomp

speak 'Nice to meet you, ' + name
speak 'Do you want to play a game?'

if gets.chomp == 'yes'

	# Guess the number game
	speak 'guess the number between 0 and 99'
	number = rand 0..99
	answer = gets.chomp.to_i

	while answer != number
		speak 'wrong'

		if answer > number
			speak 'too high'
		else
			speak 'too low'
		end
		
		answer = gets.chomp.to_i
	end

	speak 'Great! It was' + answer.to_s

end

speak 'Goodbye'
