# ATS Examples

## AtsWeb.Schema.Continents
### List all continents
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
x-request-id: FhjIQ2pTXLp3344AAADD
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

### List all continents with pagination
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
x-request-id: FhjIQ2EJYonXQOIAAAJC
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
### List all jobs
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
x-request-id: FhjIQ28kPU1Hz4wAAARE
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

### List all jobs with pagination
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
x-request-id: FhjIQ23K6d3o--QAAANK
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

### List all jobs near another job
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
x-request-id: FhjIQ3CJwlaWAXMAAAMD
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

### Get a single job
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
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: FhjIQ2vrUuTyb58AAAJD
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "job": {
      "name": "A"
    }
  }
}
```

### Get an inexistant job
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
x-request-id: FhjIQ2p_mUxfEDcAAAGD
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
### List all professions
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
x-request-id: FhjIQ2keSPv5d1oAAARB
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

### List all professions with pagination
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
x-request-id: FhjIQ1_tqISJ4lwAAAIC
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

