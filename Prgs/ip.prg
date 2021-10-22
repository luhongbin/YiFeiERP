owsh=createobject("wscript.shell")
owsh.run("command.com /c ping -n 1 -r 9 www.163.com >IP.txt",0,.t.)