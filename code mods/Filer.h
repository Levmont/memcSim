
# Key 		string	 	representative.
# Flags 	Integer.
# Dir 					directory path from ./server.rb
# Duration 	Integer 	life span 
# Size 		Integer		amount of characters in Value
# Value 	string		
# Cas 		Integer
Class Filer


#Creates an instance of Filer with user input and predetermined options
def self.kFileCreate(dir, key, flags, duration, size, cas, value)


#Receives a Filer and checks if its key is used
def inUse(kFile)


#Receives a Filer and creates an apropiate file with its info.
#Also handles each file timed life (0 = until server close)
def fileHandler(kFile)


#Receives a Filer and adds a new file named as the key of the Filer
#Precondition: kFile.key is not already an existant file
def keyAdd(kFile)


#Receives a Filer and adds a new file named as the key of the Filer
#If kFile.key is already an existant file it replaces its content
def keySet(kFile)


#Receives a predetermined directory, and a key, content of "key" file
#Precondition: key is an existant file on dir
def self.keyGet(dir, key)


#Receives a Filer and replaces key file content with Filer one.
#Precondition: kFile.key is an existant file
def keyReplace(kFile)


#Receives a Filer and appends kFile.Value into the key file's value
#Precondition: kFile.key is an existant file
def keyAppend(kFile)


#Receives a Filer and prepends kFile.Value into the key file's value
#Precondition: kFile.key is an existant file
def keyPrepend(kFile)


#Receives a Filer and a user typed-in CasToken, if kFile.cas == CasToken
#it replaces key file info with the Filer info
def keyCas(kFile, userCas)