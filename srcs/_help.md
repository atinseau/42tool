
# COMMAND

42tool
	- list of commands and wait for input

42tool --help
	- show the helper

42tool --namespace
	- list of all namespace

42tool ${namespace}
	- list of commands in namespace and wait for input

42tool ${namespace} --help
	- show the namespace helper

42tool ${namespace} ${command}
	- directly execute the right command

- Some commands of an help function so you can do

	42tool ?${namespace} ${command} --help

	*? is option parameter

