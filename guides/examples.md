# ATS Examples

## AtsWeb.Schema
### jobs query: jobs names
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
{
  jobs {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhg1MjVZgRpgKm4AAARB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "jobs": [
      {
        "name": "A"
      },
      {
        "name": "B"
      },
      {
        "name": "C"
      }
    ]
  }
}
```

### jobs query: jobs pagination
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
{
  jobs(first: 2, offset: 1) {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhg1MizX3hg52IcAAADK
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "jobs": [
      {
        "name": "B"
      },
      {
        "name": "C"
      }
    ]
  }
}
```

### jobs query: jobs near A (1 km)
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
{
  job(id: "1") {
    place {
      near(radius: 1) {
        name
      }
    }
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhg1Mjhp7e79eEQAAAbB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "job": {
      "place": {
        "near": [
          {
            "name": "B"
          }
        ]
      }
    }
  }
}
```

### jobs query: jobs near A (2 km)
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
{
  job(id: "1") {
    place {
      near(radius: 2) {
        name
      }
    }
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhg1Mja1lidA0UMAAAUB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "job": {
      "place": {
        "near": [
          {
            "name": "B"
          },
          {
            "name": "C"
          }
        ]
      }
    }
  }
}
```

