# Sample and template bash scripts to use 

## example_bash_with_arguments

This script enables a debug cli option "--debug" or "--help" for script help.  
The `--help`option read from script head everything beginning #/ as help documentation.  

Also has an option to provide arguments via cli /src=path  
or via environment variable `export src=path` befor running the script.  
If not the sample `src` is given, it prompt for input.  

This sript will also produce an error output,  
if something is failing and show's the line numnber,  
as well the error message / cause.    
By default logging is enabled to write a logfile under /tmp/<filename of the script>_<date and timestamp>.log   
```
./example_bash_with_arguments.sh 
Variable ARG1 with Value=commandline_argument_1
start script
Please enter source path incl filename: asdf

now a command which produce an example error


./example_bash_with_arguments.sh: Zeile 136: what_ever_none_existing_command_to_produce_an_error: Kommando nicht gefunden.
[example_bash_with_arguments] [ERROR] 30.09.2021 12:17:34  Error with command at line: 136
what_ever_none_existing_command_to_produce_an_error
[example_bash_with_arguments] [ERROR] 30.09.2021 12:17:34  Script will abort
```
but logging can be disabled see `--help`.  

## example_bash_with_read_default_settings_file

This script reads a config file with variables defined into it that it can be used inside the script.  
This is mainly done with this sample variable:  
`[ -z ${VOLUMES+x} ] && . volumes.conf`



