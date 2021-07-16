class Filer

	def initialize(dir, key, flags, duration, size, cas, value)
		@key = key
		@flags = Integer(flags)
		@dir = dir
		@duration = Integer(duration)
		@size = Integer(size)
		@value = value
		@cas = Integer(cas)
	end

	def self.kFileCreate(dir, key, flags, duration, size, cas, value)
		newFile = Filer.new(dir, key, flags, duration, size, value, cas)
	end

	def inUse(kFile)
		File.file?("./#{@dir}/#{@key}")
	end

	def fileHandler(kFile)
		Thread.new(kFile) do
			File.open("./#{@dir}/#{@key}", 'w+')
			File.write("./#{@dir}/#{@key}", "#{@flags} #{@size} #{@cas} #{@value}")
			wait = Float(@duration)
			if wait != 0 
				sleep(wait)
				if Time.now - File.mtime("./#{@dir}/#{@key}") > wait
					File.delete("./#{@dir}/#{@key}")
				end
			end
		end
	end


	def keyAdd(kFile)
		if !inUse(@key)
			fileHandler(kFile)
			res = "STORED"
		else
			res = "NOT_STORED"
		end
	end


	def keySet(kFile)
		if inUse("./#{@dir}/#{@key}")
			File.delete("./#{@dir}/#{@key}")
		end
		fileHandler(kFile)
		res = "STORED"
	end


	def self.keyGet(dir, key)
		res = File.open("./#{dir}/#{key}")
		res = res.read
	end


	def keyReplace(kFile)
		if inUse(kFile)
			kFile.keySet(kFile)
			res = "STORED"
		else
			res = "NOT_STORED"
		end
	end


	def keyAppend(kFile)
		if inUse(kFile)
			dataArr = Filer.keyGet(@dir, @key).split
			dataArr[1] = Integer(dataArr[1]) + @size
			dataArr[3] = "#{dataArr[3]}#{@value}"
		end
		newFile = Filer.kFileCreate(@dir, @key, Integer(dataArr[0]), @duration, dataArr[1], dataArr[3])
		res = keyReplace(apFile)
	end


	def keyPrepend(kFile)
		if inUse(kFile)
			dataArr = Filer.keyGet(@dir, @key).split
			dataArr[1] = Integer(dataArr[1]) + @size
			dataArr[3] = "#{value}#{dataArr[3]}"
		end
		newFile = Filer.kFileCreate(@dir, @key, Integer(dataArr[0]), @duration, dataArr[1], dataArr[3])
		res = keyReplace(newFile)
	end

	def keyCas(kFile, userCas)
		if inUse(kFile)
			dataArr = Filer.keyGet(@dir, @key).split
			if dataArr[2] == userCas
				res = keyReplace(kFile)
			else
				res = "EXISTS"
			end
		else
			res = "NOT_FOUND"
		end
	end

end