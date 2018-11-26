# rainmeter-gol
![tiled gliders](https://i.imgur.com/e66jDmH.gif)

# What the heck am I looking at?
[Rainmeter]() has a [shape meter](), which lets you draw various vector graphic shapes.

It also lets you define a [linear gradient]() for your shapes.

Rainmeter (as of the current version, 4.3.0) doesn't let you draw pixels directly from Lua scripts.
However, you can manipulate shapes without having to refresh the skin.

We can abuse the linear gradient functionality to draw pixels by taking a regular gradient:

![normal gradient](https://i.imgur.com/SN38VR2.png)

Adding more handles (two per pixel):

![more handles](https://i.imgur.com/9ESqnhU.png)

And moving those handles to the same spot:

![gradient pixels](https://i.imgur.com/oC1Im0D.png)

(these screenshots are from Blender, and are used for illustrative purposes only)

This is pretty simple to do in rainmeter:

![rm gradient hack](https://i.imgur.com/vj3AjSR.png)

# Nice, but how performant is it?
Currently, not at all, it runs at a really low framerate and hogs a lot of CPU:
![bad perf](https://i.imgur.com/utY3YCx.jpg)

Maybe it's less bad when running a smaller size, with a lower refresh rate.
I'd love to see some animated/procedural pixel art made with this technique!
