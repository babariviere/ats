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
x-request-id: Fhli4_VNDOH5d1oAAAFK
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
x-request-id: Fhli4_Zv5O_yb58AAAeB
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
x-request-id: Fhli4_eWVCpHz4wAAAhB
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
x-request-id: Fhli4_e_07wWacoAAANG
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
x-request-id: Fhli4-0lwCWa0mAAAAAI
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
x-request-id: Fhli4-1oL-EVjAEAAAJJ
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
x-request-id: Fhli4_e_o6OWAXMAAAkB
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
x-request-id: Fhli4_aKdEPo--QAAAIG
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
x-request-id: Fhli4_m0JtzXuEkAAAsB
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
x-request-id: Fhli4_rQa4BaSXIAAABI
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

### Create a new job
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
mutation {
  createJob(name: "Test Job", contractType: FULL_TIME) {
    name
    contractType
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhli4_r-m7TbZb0AAAvB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "createJob": {
      "contractType": "FULL_TIME",
      "name": "Test Job"
    }
  }
}
```

### Create a new job without name
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
mutation {
  createJob(contractType: FULL_TIME) {
    name
    contractType
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhli4_tNPUVHxBgAAAQG
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "errors": [
    {
      "locations": [
        {
          "column": 3,
          "line": 2
        }
      ],
      "message": "In argument \"name\": Expected type \"String!\", found null."
    }
  ]
}
```

### Create a new job without contractType
#### Request
* __Method:__ POST
* __Path:__ /api
* __Request headers:__

```
content-type: multipart/mixed; boundary=plug_conn_test
```
* __Request query:__

```
mutation {
  createJob(name: "Test Job") {
    name
    contractType
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhli4_t82B0mr1IAAAyB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "errors": [
    {
      "locations": [
        {
          "column": 3,
          "line": 2
        }
      ],
      "message": "In argument \"contractType\": Expected type \"ContractType!\", found null."
    }
  ]
}
```

### Get a job's profession
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
  job(id: "4") {
    name
    profession {
      categoryName
    }
  }
}

```

#### Response
* __Status__: 200
* __Response headers:__

```
cache-control: max-age=0, private, must-revalidate
x-request-id: Fhli4_kA3qRu3m0AAAnB
content-type: application/json; charset=utf-8
```
* __Response body:__

```json
{
  "data": {
    "job": {
      "name": "D",
      "profession": {
        "categoryName": "Tech"
      }
    }
  }
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
x-request-id: Fhli4_RBQkB3344AAAaC
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
x-request-id: Fhli4-tKYme7r1UAAACH
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

