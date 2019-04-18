# Clean Swift Example 

## Clean Swift Advantages

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Clean%20Swift.png" />

- 버그를 찾아 빠르고 쉽게 수정할 수 있습니다. (Find and fix bugs faster and easier.)
- 확신을 가지고 기존 동작을 변경할 수 있습니다. (Change existing behaviors with confidence.)
- 새로운 기능을 쉽게 추가 할 수 있습니다. (Add new features easily.)
- 단일 책임으로 더 짧은 방법을 작성할 수 있습니다. (Write shorter methods with single responsibility.)
- 클래스 종속성을 기존 경계와 분리합니다. (Decouple class dependencies with established boundaries.)
- 비즈니스 로직을 뷰 컨트롤러에서 인터랙터로 분리함으로써 컨트롤러가 Massive해지는 걸 방지할 수 있습니다. (Extract business logic from view controllers into interactors.)
- Wokrer 및 Service Object의 형태로 재사용 가능한 구성 요소를 구축합니다. (Build reusable components with workers and service objects.)
- 처음부터 factored code로 작성합니다. (Write factored code from the start.)
- 신속하고 유지 보수가 가능한 단위 테스트를 작성할 수 있습니다. (Write fast and maintainable unit tests.)
- 회귀 분석에 대해서 자신감을 가지고 테스트 가능합니다. 
(Have confidence in your tests to catch regression.)

## VIP Cycle

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/VIP%20Cycle.png" />

> ### Interactor
Interactor contains all the business logic. It receives user actions from View Controller with various parameters defined in the Input protocol.
<br/>
Interactor는 모든 비즈니스 로직을 포함합니다. View Controller에서 입력 프로토콜에 정의 된 다양한 매개 변수를 사용하여 사용자 동작 또는 행위에 대한 이벤트를 수신 받습니다.

- 구성요소 (Components)
  - Interactor Logic: 사용자 동작 또는 행위에 대한 이벤트 수신 스펙입니다. (The event reception specification for a user action or action.)
  - Worker/s: 하단 Worker참고 https://github.com/GeekTree0101/CleanSwift-Example#worker
  - DataStore: Router를 통해서 데이터를 전달하기 위해 저장하는 역할을 합니다. (It serves to store data for transmission through a router.)

> ### Presenter
Presenter prepares the data to be displayed to the user.
<br/>
Presenter는 사용자에게 보여주기 위한 데이터를 가공합니다. (특히, ViewModel)

- 구성요소 (Components)
  - Presenter Logic: Interactor로 부터 온 Response를 사용자에게 보여주기 위한 데이터(ViewModel)로 가공하는 스펙입니다. (It is a specification that processes data from the Interactor into ViewModel to show the response to the user.)

> ### ViewController
View Controller is responsible for configuring all of the View’s properties. (same with VIPER arch)
<br/>
View Controller는 모든 View 속성을 구성합니다. (VIPER 아키텍쳐와 동일)

## Worker

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Worker.png" />

> ### What's Worker?
To avoid unnecessarily complicating Interactor and duplicating business logic details. In other words, they can be made reusable and used in combination
<br/>
Interactor를 불필요하게 복잡하게 만들고 비즈니스 로직 세부 사항을 복제하는 것을 방지합니다. 즉, 재사용가능하게 만들어 조합해서 사용할 수 있습니다.

## Router

<img src= "https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Routing.png" />

> ### What's Router?
Router is responsible for transferring data to various application screens and switching between them.
<br/>
라우터는 다양한 응용 프로그램 화면으로 데이터를 전송하고 그 사이를 전환합니다. 

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
