# Howto-Howto or Kite

This repository contains many resources and mini-tutorials that could help you finding useful information during your daily work.

Anytime, anywhere and easily.


# Installation (on your system)

Here, you will install Kite on your system and use it with the script.
Just clone the repo then add the _Script_ directory to your ***PATH*** (see below).

```
$ cd

$ cd Documents

$ git clone git@github.com:joved-git/howto-howto.git
```

Add ...

```
PATH=$PATH:'~/Documents/howto-howto/Script'
```

... at the end of your ~/.cshrc or ~/.zshrc.

That's all !


# Installation (with Dockerfile)

Here, you will create a container with Kite.
Just clone the repo then follow instructions of the ./howto-howto/Resources/Docker/README.txt file.

```
$ cd

$ cd Documents

$ git clone git@github.com:joved-git/howto-howto.git
```

See Documents/howto-howto/Resources/Docker/README.txt file.

After the instalaltion, you can delete the cloned directory.


# How to use it (howto mode)

If all is OK with your PATH, you can try to the 'list' command:

```
 $ kite list
```

You should see a list of the content of ***Kite***.


If you want to find a specific subject, just ask to ***Kite***:

```
$ kite nmap
```

After that, just ask to ***Kite*** to see the appropriate file:

 
```
$ kite 0020
```

or

```
$ kite ufw
```

You should see very interesting information, links and examples.


# How to use it (command mode)

Kite allows to run some very useful commands. 

```
 $ kite cmd
```

You should see a list of available commands. Here is an example:

```
ipfor : Used to get/set ip forwarding
$ kite ipfor [on | off | status]
```

You have a small manual. It's simple.


# How to use it (whatis mode)

Kite allows to give you a brief summary of each keyword (same as for 'kite <keyword> above). 

```
 $ kite whatis <keyword | id>
```

You should see a summary of the given entry.


Try howtos and commands, create you own, all is possible.

Have fun !
