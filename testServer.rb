require './memcSim'

tester = Server.start(3210)
tester.serverOpen(tester)