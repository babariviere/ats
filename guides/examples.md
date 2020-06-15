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
x-request-id: FhjNk12hx0ro--QAAAHC
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
x-request-id: FhjNk18BgyAWacoAAAQC
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

### Get a single continent
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
  continent(id: "1") {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: FhjNk1vMJEhfEDcAAAHE
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "continent": {
      "name": "Europe"
    }
  }
}
```

### Get an inexistant continent
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
  continent(id: "0") {
    name
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: FhjNk17UAJZHz4wAAALC
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "continent": null
  },
  "errors": [
    {
      "locations": [
        {
          "column": 3,
          "line": 2
        }
      ],
      "message": "Continent with id 0 does not exists",
      "path": [
        "continent"
      ]
    }
  ]
}
```

### List jobs in continent
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
  continent(id: "1") {
    jobs {
      name
    }
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: FhjNk1P9GKR-fa8AAADE
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "continent": {
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
x-request-id: FhjNk1vE1_X5d1oAAAtB
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
x-request-id: FhjNk17gJf2WAXMAAANC
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
x-request-id: FhjNk2A2c886h-QAAATC
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
x-request-id: FhjNk2AKULtu3m0AAAJD
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
x-request-id: FhjNk1QvJGP7k4IAAAFD
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
      "message": "Job with id 0 does not exists",
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
x-request-id: FhjNk1q5a-V3344AAAGD
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
x-request-id: FhjNk1Ie5Y1MK_gAAACE
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

