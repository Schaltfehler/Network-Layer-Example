# Network Layer Example

An example implementation of how to manage your networking in Swift. 

### How to use

``` swift
let dispatcher = NetworkDispatcher()
let client = Client(dispatcher: dispatcher)
client.users(page: 1, perPage: 10) { result in
         switch result {
         case .success(let users):
            print(users)
         case .failure(let error):
            print(error.localizedDescription)
         }
     }
```

### Testing

Mock your repsonses. Just create a new dispatcher that conforms to the DispatchProtocol.

```swift
let response = MockData.users
let dispatcher = MockDispatcher(path: "/users/", response: response)
let client = Client(dispatcher: dispatcher)
client.users(page: 1, perPage: 10) { result in
         switch result {
         case .success(let users):
            print(users)
         case .failure(let error):
            print(error.localizedDescription)
         }
     }
```

### Depending Requests

Encapsulate your requests into Operations. Set dependencies between them to ensure execution order. Use BlockOperations to pass values between Operations

``` swift
let login = LoginOperation(apiClient: client, user: "Freddy", password: "secret")
let getUser = GetUserOperation(apiClient: client)

let adapter = BlockOperation() {
    if let result = login.result,
        case .success(let auth) = result {
        getUser.token = auth.key
    }
}

adapter.addDependency(login)
getUser.addDependency(adapter)
getUser.completionBlock = {
    print("Finished!!")
}

queue.addOperations([login, getUser, adapter], waitUntilFinished: false)
```
