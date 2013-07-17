{print} = require 'sys'
{spawn} = require 'child_process'

task 'build', 'Compile Vimtastic.safariextension/coffee/ into Vimtastic.safariextension/js/', ->
	handle = spawn 'coffee', ['-c', '-o', 'Vimtastic.safariextension/js', 'Vimtastic.safariextension/coffee']
	handle.stderr.on 'data', (data) ->
		handle.stderr.write data.toString()
	handle.stdout.on 'data', (data) ->
		print data.toString()
	handle.on 'exit', (code) ->
		print "coffee exited with code #{code}\n"

