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

- 구성요소 (Components)
  - DisplayLogic: Presenter로 부터 받은 ViewModel을 처리합니다. 스펙에 따라 뷰를 그리거나 라우팅에게 명령을 전달합니다. (Processes ViewModel received from Presenter. Draw the UI according to the specification or pass the command to the routing.)

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
라우터는 다양한 화면으로 데이터를 전송하고 그 사이를 전환합니다. 

- 구성요소(Components)
  - RouterLogic: 다른 화면으로 전달하기 위한 명시적인 스펙입니다. (An explicit specification for passing to another screen.)
  - DataPassing: 다른 화면으로 전달될 데이터를 가지고 있습니다. (It has data to be passed to the other screen.)
  
> #### DataPassing Example  
```swift
protocol ApplicationDataSotre: class {

    var id: Int { get set }
}

protocol ApplicationDataPassing: class {
    
    var dataStore: ApplicationDataSotre? { get set }
}
```

## DataStore & DataPassing

### DataStore
<img src="https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Data%20Store.png" />
앞서 말했듯이 Interactor에는 다양한 Worker와 그리고 Interactor logic, DataStore를 가집니다. 
위의 그림과 같이 유저가 어떠한 행위를 하면 Logic에 따라 Worker에서 비즈니스로직을 수행하고 반환된 값을 필요에 따라 DataStore에 저장을 합니다. 
<br/>
As mentioned before, Interactor contains various worker, Interactor logic, DataStore.
As shown in the figure above, if the user performs any action, the worker executes the business logic according to Interactor Logic and next stores the returned value in the DataStore as needed.

### DataPassing
우선 Router및 Interactor가 아래의 코드와 같이 구성되어 있습니다.

##### Router
```swift
protocol RepositoryListDataPassing: class {
    
    var dataStore: RepositoryListDataSotre? { get set }
}

class RepositoryListRouter: RepositoryListRouterLogic & RepositoryListDataPassing {
    
    var dataStore: RepositoryListDataSotre?
    
    // ...
```

##### Interactor
```swift

protocol RepositoryListDataSotre: class {
    
    var repositoryStores: [ReactiveDataStore<Repository>] { get set }
    var presentRepositoryShowIdentifier: Int? { get set }
}

class RepositoryListInteractor: RepositoryListInteractorLogic & RepositoryListDataSotre {
    
    // ...
    
    // DataSotre: It is cached data and pass to other controller by router
    public var repositoryStores: [ReactiveDataStore<Repository>] = []
    public var presentRepositoryShowIdentifier: Int?
    
```

##### VIP Cycle configuration
```swift
func configureVIPCycle() {
        let viewController = self
        let presenter = RepositoryListPresenter()
        let interactor = RepositoryListInteractor()
        let router = RepositoryListRouter.init()
        
        // ... Cycle binding
        
        router.dataStore = interactor // HERE!
        viewController.router = router
        viewController.interactor = interactor
    }
```

Router의  dataStore property는 interactor의 dataStore를 참조합니다.


<img src="https://github.com/GeekTree0101/CleanSwift-Example/blob/master/res/Data%20Passing.png" />

위의 그림과 같은 동작에 대해서 설명하고자 합니다. 

- 1: 유저의 행동을 Interactor로 송신합니다. (Send a Request)
- 2: 비즈니스 로직에 따라 가공된 데이터를 DataStore에 저장후 Presenter로 응답합니다. (DataStore & Returning Response)
- 3: 뷰컨트롤러에 최종 행위 동작에 대해서 명령합니다. (Presenter -> DisplayLogic of ViewController)
- 4: DisplayLogic의 명령에 따라 라우터를 동작시킵니다. (DisplayLogic -> Router)
- 5: 라우터는 참조하고 있는 DataStore를 이용해 다음 화면으로 데이터를 전달합니다. (The router uses the referenced DataStore to pass data to the next screen.)


## TODO-List
- Write a test code (RepositoryList VIP)
- Make a templates or copy clean swift basic templates


## Referrence

<img src="https://cdn-images-1.medium.com/max/2600/1*E39B_vTuUab80MOlWwGjJQ.png" />

### Introducing Clean Swift Architecture (VIP) by Dejan Atanasov
https://hackernoon.com/introducing-clean-swift-architecture-vip-770a639ad7bf

### Clean Swift by Exyte
https://blog.exyte.com/clean-swift-4891a5e3ace9
