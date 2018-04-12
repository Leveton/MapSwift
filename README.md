

<!-- [<img style="width: 200px;" src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/36/Harvard_Wreath_Logo_1.png/246px-Harvard_Wreath_Logo_1.png" alt="Harvard University" />](http://www.harvard.edu/) -->
[<img style="width: 200px;" src="http://i.imgur.com/7Rjxn1J.png" alt="The Idea Center" />](http://theideacenter.co/)
[<img style="width: 200px;" src="http://i.imgur.com/wzb1fU6.png" alt="Miami Dade College" />](http://www.mdc.edu/)

This is the iOS track curriculum for graduates of Harvard University's CS50xMiami course at The Idea Center, Miami Dade College's entrepreneurship hub.

The course consists of thirteen lessons with slides centering around MapSwift - a location services iOS app.

Each lesson has its own git branch. Teachers and students will switch branches to see the app progress - from the main function call in lesson 0 to the completed app in lesson 13.

<hr />

<img src="https://raw.githubusercontent.com/Leveton/MapSwift/lesson0/images/BranchFlow.png" alt="TSNavigationStripView examples" />

## Themes

 - The course is opinionated. There is less convention in the iOS community than in other communities (e.g. Rails or Java). Apple's closed nature, intermittent enthusiasm for the platform, and other factors account for this.

- The app is architected inconsistently on purpose. The goal is to demo the common patterns that iOS developers encounter from day one.

- The essential concepts most often confusing to students are given the most weight.

- Table views are used extensively, being the standard way to navigate on mobile.

- Because UIKit is a library of objects, OOP style programming is taught from day one but, don't worry, functional concepts are introduced as the course progresses.

## Table of branches and their Contents

**Lesson 0 - Hello World**
 - creating a project
 - the run loop
 - iOS app lifecycle
 - object oriented programming
 - methods and properties
 - var vs let

**Lesson 1 - OOP and memory**
 - OOP essentials
 - inheritance
 - polymorphism
 - introspection
 - delegation
 - reference vs value semantics
 - primitives vs objects
 - memory management and ARC
 - storage and instance variables
 
 **Lesson 2 - Prereqs and the Swift difference**
 - Xcode crash course
 - strong vs weak again
 - playgrounds
 - ARC again
 - getters and setters
 - optional chaining conditionals
 - access levels

 **Lesson 3 - Prereqs and Foundation**
 - plists, asset managers, and config files
 - initializers
 - core geometry
 - pixels and points
 - setting up the map
 - lazy initiation

**Lesson 4 - Getting data around**
 - View controllers, their subclasses, and their owners
 - Notification and Notification Center
 - UserDefaults
 - Protocols and delegates
 - Introduction to table views (programmatic version)

**Lesson 5 - Table views in depth**
 - labeled statements
 - table view delegates in depth
 - NSIndexPath
 - Objects as models
 - The view controller lifecycle
 - parsing JSON

**Lesson 6 - Table views in depth continued**
 - parsing JSON cont.
 - annotating MKMapView
 - modeling our locations
 - table view dequeueing
 - reuse identifier
 - modal presentation
 - inout parameters and mutating functions

**Lesson 7 - Swift and iOS features grab bag**
 - closures
 - gesture recognizers
 - animations
 - extensions
 - equatable

**Lesson 8 - Swift and iOS features grab bag continued**
 - animations cont.
 - singletons
 - sorting collections
 - extensions cont.
 - The cascading pattern
 - closures cont.
 - map, filter, reduce
 - the advantages of UIImageView
 - PNG vs JPEG, clipstobounds, contentmode, etc.
 - storyboard prototypes

**Lesson 9 - Navigation and data**
 - UINavigationController and the navigation stack
 - subclassing
 - custom delegates and protocols
 - weak delegates and preventing retain cycles
 - functional programming (map, filter, reduce cont.)
 - interface builder and basic constraints

**Lesson 10 - Networking and GCD**
 - URL Session
 - AFNetworking
 - GCD
 - table view datasource cont.
 - optional protocol methods
 - error handling

**Lesson 11 - More advanced table views**
 - inserting and deleting rows
 - grouped table views
 - MVC file system 
 - defer and dump
 - weak delegates cont.
 - variadic parameters

**Lesson 12 - The Settings Controller**
 - collection manipulation and table views
 - NSCopying
 - table view stdlib controls
 - mutating functions
 - auto layout constraints
 
 **Lesson 13 - Profiling, XCTest, and some advanced Swift**
 - basic localization
 - profiling hotspots with Instruments
 - XCTest basics
 - generics 
 - HIG

As a versioned document, both the app and the lessons will be periodically updated to keep up with the latest devices, operating systems, and Swift versions.

You can send me a pull request to fix any issues or add any features.

## Switching Lessons

![](https://raw.githubusercontent.com/Leveton/HelloWorld/master/images/switchBranch.gif)
![](https://raw.githubusercontent.com/Leveton/HelloWorld/master/images/switchGithubBranch.gif)

<hr />

## Course Rationale

I noticed a lack of material depth when reviewing iOS and Objective-C introductory books while developing the course curriculum. Essential concepts like reference counting, delegation, and the object lifecycle were glossed over or excluded altogether. This course tries to balance depth and breadth. MapSwift's features are shared across the majority of iOS apps and we implement these features in various ways to stress the less-than-standardized nature of iOS development.

This isn’t a course for beginning coders. The CS50 graduates coming into this class have done difficult problem sets in C and often find that course more difficult than the specialized tracks like this one.

## Prerequisites

All students are graduates of Miami Dade College's CS50x course sponsored by Harvard. They should know C-style control flow, basic data types, stack vs heap, dequeuing, FIFO and LIFO and procedural programming.

## License

MapSwift is available under the MIT license.

Copyright © 2018 Mike Leveton

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.