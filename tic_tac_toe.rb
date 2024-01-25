class Game

	def initialize

	end

	def introduction
		 "Welcome in the game of"
	end
end

class Player
	attr_accessor :name
	def initialize(name)
		@name = name
		@points = 0
	end


	def add_point
		self.point += 1
	end

end


class TicTacToe < Game
	attr_accessor :board_positions, :players, :player_on_move, :draw
	def initialize(players)
		@players = players
		@board_positions = define_board_positions
		@player_on_move = 0;
		@winner = nil
		@draw = nil
		puts "You play by wrting the row: A,B,C and the column number:1,2,3. For example A1 -> puts X or O in first row first column "
	end

	def introduction
		puts "#{super} TicTacToe!"
	end


	def render_board
		row = "------------ \n"
		row += " |1||2||3| \n"
		self.board_positions.each do |key,values|
			row += "#{key}"
			values.each{ |key,value|  row+="|#{value}|"}
			row += "\n"
		end
		row += "------------"
		puts row
	end

	def input_position
		puts "Player on move: #{self.players[self.player_on_move].name}"
		positions = gets.chomp.split("")
		positions[1] = positions[1].to_i
		occupied = validate_position_write(positions)
		if(!occupied)
			write_position(positions)
		else
			input_position
		end
	end

	def is_finished?
		 positions = self.board_positions
		 is_finished = false
		 vertical_win = check_vertical_for_win(positions)
		 diagonal_win = check_diagonals_for_win(positions)
		 horizontal_win = check_horizontal_for_win(positions)
		 draw = check_for_draw(positions)
		 puts "VERTICAL #{vertical_win}"
		 puts "DIAGONAL #{diagonal_win}"
		 puts "HORIZONTAL #{horizontal_win}"

		 if(horizontal_win or vertical_win or diagonal_win)
		 	is_finished = true
		 	self.draw = false
		 elsif draw
		 	is_finished = true
		 end
		 return is_finished
	end

	def who_won?
		if(self.draw)
			"No one won, its a DRAW!"
			else
			self.players[self.player_on_move].name
		end
	end

	def switch_player
		case self.player_on_move
		when 1
			self.player_on_move = 0
		else
			self.player_on_move = 1
		end
	end

	private
	def define_board_positions
		rows = ["A","B","C"]
		columns = [1,2,3]
		positions = Hash.new
		rows.each do |row|
			positions[row] = Hash.new
			columns.each { |column| positions[row][column]="_"  }
		end
		return positions
	end

	def validate_position_write(positions)
		value = self.board_positions[positions[0]][positions[1]]
		if value == "X" or value == "O"
			return true
		end
	end

	def write_position(position)
		self.board_positions[position[0]][position[1]] = player_on_move == 0 ? "X" : "O"
	end

	def check_horizontal_for_win(positions)
		horizontal_win = false
		positions.each do |key,value|
			horizontal_win = positions[key].all?{ |key, value| value == "X"} or positions[key].all?{ |key, value| value == "O"}
		end
		return horizontal_win
	end

	def check_diagonals_for_win(positions)
		is_win = false
		diagonals = {
			#left to right
			l_to_r:{
				items: Array.new(3),
				index: 0 #first iteration always +1
			},
			#right to left
			r_to_l:{
				items: Array.new(3),
				index:4 #first iteration always -1
			}
		}
		positions.each do |key,value|
			#left to right l_to_r diagonal from A1 to C3
			#right to left r_to_l from C1 to A3
			l_to_r_index = diagonals[:l_to_r][:index]+=1
			r_to_l_index = diagonals[:r_to_l][:index]-=1
			diagonals[:l_to_r][:items][l_to_r_index-1] = value[l_to_r_index]
			diagonals[:r_to_l][:items][r_to_l_index-1] = value[r_to_l_index]
		end

		l_to_r = diagonals[:l_to_r][:items].all? { |item| item == "X" } or diagonals[:l_to_r][:items].all? { |item| item == "O" }

		r_to_l = diagonals[:r_to_l][:items].all?{ |item| item == "X"} or diagonals[:r_to_l][:items].all?{ |item| item == "O"}

		if(r_to_l or l_to_r)
			is_win = true
		end
		return is_win
	end

	def check_vertical_for_win(positions)
		vertical_win = false;
		verticals = []
		(0).upto(2) do |time|
			verticals[time] = positions.map{ |key,value| value[time+1] }
		end
		vertical_win = verticals.any?{ |column| column.all?{|item| item == "O"} or verticals.any?{|column| column.all?{|item| item == "X"}} }
		return vertical_win
	end

	def check_for_draw(positions)
		is_draw = false
		is_draw = positions.all?{ |key,value| value.all? { |key1,val|  val != "_" }}
		self.draw = is_draw
		return is_draw
	end

end

player_1 = Player.new("Ajka")
player_2 = Player.new("Kuki")
game = TicTacToe.new([player_1,player_2])

while !game.is_finished?
		game.render_board
		game.input_position
		if(!game.is_finished?)
			game.switch_player
		end
		system("clear")
end
game.render_board

puts "End of the game, #{game.who_won?}!"
