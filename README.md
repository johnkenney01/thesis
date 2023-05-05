# README
## Thesis II: John Kenney
### Description:
  For my thesis I am developing my own game engine to allow game devs using love2D to have an easier and much more efficient option when developing.

## Overview
The purpose of this thesis is to gain as much exposure to the game dev realm as I can. When I had decided on doing a game I then had to narrow my decision as to how I would go about doing this. I also have a great passion for designing data manipulation, designing large programs etc. The options as to what I could use to build this game were many however, I chose to use the Love 2D game engine. Love 2D is an open source 2D game engine that uses LUA - programming language to provide basic functionality at its most basic implementation. 
### Why ? 
I have goals and aspirations that surround the game dev space, although I could have chosen a more flashy game engine like Unity or Unreal Engine 5 what I would have gained in complexity I would have lost in full control of the design. I thought being in the current situation I am that it would be adventagious to simulate as much of the proccess as possible, that means from the begininng designs, game engine design + implementation, to the actual development of the game would help me achieve this. 
### My own game engine...
Love 2D as mentioned is a basic game engine that is open source and allows the user(s) to vastly build upon the basics Love 2D already provides. I want to take a more Object Oriented Apporach here as I build out large blueprints for my games main objects. This will include a player class, enemy class, button class, and even a large container like class that will allow for level development to be rapid so that the user can focus more on the scaling of their game rather than the tedious redundant coding they would spend doing otherwise. This is essential to the process to game dev as many games use their own engine to make a game and each engine has their pros and cons and this is a great test to see what I truly enjoy in the process, some things I want to learn more about, some things I am not so interested in. These are the answers I am looking for throughout the development of this project.

### Love 2OOD - Love 2D with Objected Oriented Programming
My game engine will be called Love 2OOD - pronounced Love "Tude-e", this is more of an extension of the already existing love 2d framework, but reformatting and redesigning the implementation and structure as well as abstracting a lot away. Once complete I will then implement my own engine to create a somewhat large scale game.


### Features - Love 2OOD:
- Player class
  - Movement 
  - Physics Integration 
  - Spritesheet Integration 
  - Attack integration
  - hitbox
  - Dynamic Graphics
- Buttons class
  - Dynamic resizing
  - Dynamic Function integration
- Enemies Class
  - Physics Integration 
  - Spritesheet Integration 
  - Attack integration
  - hitbox
  - Dynamic Graphics
  - Movement 
- Levels Class - Container for all other classes
  - Takes all game objects passed into a specific level and interlinks the objects which allows for interactions and passing of data between objects in a specific level
- Game Map class
  - TILED software integration. 
  - Tiled is a 3rd part software that is used in development for 2D tile game maps. My engine included an easy way to seamleessely integrate one's game map into their game by simply passing the file path of the map and the engine will configure the map, give it dynamic resizing as well as implement physics objects into the game.

