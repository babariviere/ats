# ATS Examples

## AtsWeb.Schema.Continents
### query: continents names
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
  continents {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhi2M5gfj_wGb5MAAAbL
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "continents": [
      {
        "name": "Europe"
      },
      {
        "name": "Africa"
      },
      {
        "name": "South America"
      }
    ]
  }
}
```

### query: continents pagination
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
  continents(first: 2, offset: 1) {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhi2M5EpisIPDiIAAAZB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "continents": [
      {
        "name": "Africa"
      },
      {
        "name": "South America"
      }
    ]
  }
}
```

## AtsWeb.Schema.Jobs
### query: jobs names
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
x-request-id: Fhi2M5wFupQxBVkAAAhB
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

### query: jobs pagination
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
x-request-id: Fhi2M5raLXSMYnUAAAjL
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

### query: jobs near A (1 km)
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
x-request-id: Fhi2M5mZesI6h-QAAAeL
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

### query: jobs near A (2 km)
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
x-request-id: Fhi2M5gfVKmWAXMAAACJ
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

### query: job not found
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
  job(id: "0") {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhi2M5GOzQ0tnpMAAAaB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "job": null
  },
  "errors": [
    {
      "locations": [
        {
          "column": 3,
          "line": 2
        }
      ],
      "message": "Job with id 0 is not found",
      "path": [
        "job"
      ]
    }
  ]
}
```

## AtsWeb.Schema.Professions
### query: professions names
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
  professions {
    name
    categoryName
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhi2M5ckuWcWacoAAAHC
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "professions": [
      {
        "categoryName": "Tech",
        "name": "A"
      },
      {
        "categoryName": "Tech",
        "name": "B"
      },
      {
        "categoryName": "Business",
        "name": "C"
      }
    ]
  }
}
```

### query: professions pagination
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
  professions(first: 2, offset: 1) {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhi2M5AIb8IVjAEAAABJ
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "professions": [
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

