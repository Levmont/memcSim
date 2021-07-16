require 'socket'
require 'tempfile'
require './filer.rb'

class Server

	def initialize(port)
		@port = Integer(port)
	end

	def self.start(port)
		serv = Server.new(port)
	end

	def serverOpen(serv)
		server = TCPServer.open(@port)
		puts "Server running with no issues on port #{@port}"
		keyDir = Dir.mktmpdir('keyfiles', "./")
		casToken = 0
		#Handle deletion on server close 
		begin
			loop do
				client = server.accept
				#Handle multiple users at once
				Thread.new(client) do

					#Handle disconnection from user
					begin 
						loop do
							#comArr[0]:command 		comArr[1]:key		comArr[2..5]:other arguments
							comArr = client.readline.split
							case comArr[0]

							when 'add', 'set', 'replace', 'append', 'prepend', 'cas'
								if comArr.length() == 5 or comArr.length() == 6 and comArr[1] != nil and comArr[1].length <= 250

									#Handle wrong argument data type
									begin
										Integer(comArr[2])
										Integer(comArr[3])
										kSize = Integer(comArr[4])
										value = client.gets.chomp
										if value.length() == kSize
											newFile = Filer.kFileCreate(keyDir, comArr[1], comArr[2], comArr[3], comArr[4], value, casToken+1)
											case comArr[0]

											when 'add'
												client.puts newFile.keyAdd(newFile)

											when 'set'
												client.puts newFile.keySet(newFile)

											when 'replace'
												client.puts newFile.keyReplace(newFile)

											when 'append'
												client.puts newFile.keyAppend(newFile)

											when 'prepend'
												client.puts newFile.keyPrepend(newFile)

											when 'cas'
												if comArr.length() == 5
													client.puts "ERROR"
												else 
													Integer(comArr[5])
													client.puts newFile.keyCas(newFile, comArr[5])
												end
											end

										else
											while value.length() < kSize do
												value << " " + client.gets.chomp
											end
											client.puts "CLIENT_ERROR bad data chunk\nERROR" #Incorrect value size
										end
									rescue
										client.puts "CLIENT_ERROR bad commnad line format"
									end
								else
									client.puts "ERROR" #Wrong amount of arguments for the command
								end
								

							when 'get', 'gets'
								if comArr.length() >= 2

									#Handle nonexistent keys
									begin
										comArr[1..-1].each do |key|
											resArr = Filer.keyGet(keyDir, key).split
											case comArr[0]

											when 'get'
												client.puts "VALUE #{key} #{resArr[0]} #{resArr[1]}\n#{resArr[3]}"
											
											when 'gets'
												client.puts "VALUE #{key} #{resArr[0]} #{resArr[1]} #{resArr[2]}\n#{resArr[3]}"

											end
										end
									rescue
										#No additional print when key doesn't exist
									end
									client.puts "END"
								end

							when 'quit'
								client.close

							else
								client.puts "ERROR"
							end

						end
					rescue
						client.close
					end
				end
			end
		ensure
			FileUtils.remove_entry keyDir
		end
	end

end