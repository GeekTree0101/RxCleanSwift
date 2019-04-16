# Clean Swift Example 

## Intro

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Clean%20Swift.png" />

- Find and fix bugs faster and easier.
- Change existing behaviors with confidence.
- Add new features easily.
- Write shorter methods with single responsibility.
- Decouple class dependencies with established boundaries.
- Extract business logic from view controllers into interactors.
- Build reusable components with workers and service objects.
- Write factored code from the start.
- Write fast and maintainable unit tests.
- Have confidence in your tests to catch regression.
- Apply what you learn to new and existing projects of any size.

## VIP Cycle

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/VIP%20Cycle.png" />

> ### Interactor
Interactor contains all the business logic. It receives user actions from View Controller with various parameters defined in the Input protocol.

> ### Presenter
Presenter prepares the data to be displayed to the user.

> ### ViewController
View Controller is responsible for configuring all of the View’s properties. (same with VIPER arch)

## Worker

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Worker.png" />

> ### What's Worker?
To avoid unnecessarily complicating Interactor and duplicating business logic details.

## Router

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Routing.png" />

> ### What's Router?
Router is responsible for transferring data to various application screens and switching between them.

## TODO-List
- Remove ReactorKit Dependency, Replace to RepositoryListCellNode VIP or other methods
- Write a test code
- Make a templates or copy clean swift basic templates


## Referrence

<img src="https://cdn-images-1.medium.com/max/2600/1*E39B_vTuUab80MOlWwGjJQ.png" />

### Introducing Clean Swift Architecture (VIP) by Dejan Atanasov
https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf

### Clean Swift by Exyte
https://blog.exyte.com/clean-swift-4891a5e3ace9
