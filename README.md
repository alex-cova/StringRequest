# StringRequest
Send http request in a declarative way


Simple and Elegant

## POST

```swift
"/login".POST(LoginDto(user: user, secret: pass)) { response in
        print(response)
    }
```


## GET

```swift
"/login".GET(LoginResponseDto.self) { response in
 print(response)
}
```

```swift
"/user/%@/purchases?kind=%@"
 .formatted(userId, 1)
 .GET { response in
     print(response)
 }
```


```swift
"/user/%@"
 .formatted(userId)
 .GET(User.self) { response in
     print(response)
 }
```


```swift
_ = await "/user/%@/purchases?kind=%@"
 .newRequest(.DELETE)
 .formatted(user, 1)
 .withHeader(.authorization, "Yolo")
            .send()

```
