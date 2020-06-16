**Table of Contents**

- [ATS: Welcome To The Jungle technical test](#ats-welcome-to-the-jungle-technical-test)
  - [Requirements](#requirements)
  - [Usage](#usage)
    - [API](#api)
    - [Categorize datasets](#categorize-datasets)
    - [Tests](#tests)
  - [Datasets](#datasets)
    - [Continents](#continents)
      - [Performances](#performances)
      - [Way to improve](#way-to-improve)

# ATS: Welcome To The Jungle technical test

## Requirements

- Elixir 1.10 (tested with OTP 22) [Install instructions](https://elixir-lang.org/install.html)
- Rust 1.41 [Install instructions](https://www.rust-lang.org/tools/install)
- Docker [Install instructions](https://docs.docker.com/get-docker/)
- Docker Compose [Install instructions](https://docs.docker.com/compose/install/)

## Usage

### API

To start API:

- Start database with `docker-compose up -d`
- Setup the project with `mix setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/api/graphiql`](http://localhost:4000/api/graphiql) from your browser.
Or if you want to use the API, you can make GraphQL queries to [localhost:4000/api](http://localhost:4000/api).

You can find examples [here](guides/examples.md).
They are generated from tests. More info [here](#tests).

**Note**: If you want data persistence, uncomment the lines in `docker-compose.yaml`.

### Categorize datasets

A command to categorize a set of jobs category per continents. To execute it
run:

```sh
mix ats.categorize
```

By default, it will run with the following settings:

- jobs datasets: `priv/data/technical-test-jobs.csv`
- professions datasets: `priv/data/technical-test-professions.csv`
- continents datasets: `priv/data/continents/low.geojson`

You can override these by following help instructions:

```sh
$ mix help ats.categorize

Categorize offers per continent.

It expects the path of two CSV files. The first one is the jobs dataset and the
second one is the professions dataset.

    mix ats.categorize JOBS_PATH PROFESSIONS_PATH [--continents-quality [low,medium,high]]

```

### Tests

To run test, execute this command:

```sh
mix test
```

With the usage of the library `bureaucrat`, it's also possible to generate documentation from tests results.
You can generate those with this commands:

```sh
DOC=1 mix test
mix docs
```

After that, open `doc/index.html` and go to `Pages/ATS Examples`

For test coverage, `coveralls` is used. To use it:

```sh
mix coveralls
```

It will output a report in the CLI. If you want a nice interface, you can generate an html webpage:

```sh
mix coveralls.html
# For firefox
firefox cover/excoveralls.html
# For chrome
google-chrome cover/excoveralls.html
```

If you need to exclude a file from test coverage, you can add it in `coveralls.json`.

## Datasets

### Continents

- _Source_ : https://gist.github.com/cmunns/76fb72646a68202e6bde
- _Simplified with_ : https://mapshaper.org

There is 3 datasets for continents in `priv/data`:

- continents/high.geojson: continents in full resolution (high computation)
- continents/medium.geojson: continents/high simplified to 2%
- continents/low.geojson: continents/high simplified to 1%

Simplified versions give us boundaries that are precise enough.
Only issue is that it may give false positive for certains cases (coordinates near
the boundary of the continent).

With given datasets, with a total of `5069` locations. We have:

- `4943` valid locations (with a profession_id too)
- `4898` detected on the medium map.
- `4910` detected on the low map.

This gives us 33 false negatives with the low map and 45 with medium map.

#### Performances

To get maximum performance on calculation with continents multi polygon,
we are using a combination of Rust + NIF (for native performance) and Flow (for concurrency).

This allows us to have a major performance improvement.
Here are some numbers (not accurate, they are calculated with command `time`).

For continents/low.geojson dataset:

- Elixir + Rust: `0.57s`
- Elixir only: `1.61s` (2.8x slower)

For continents/high.geojson dataset:

- Elixir + Rust: `1.89s`
- Elixir only: `241.47s` (127.7x slower)

NIF implementation can be found in `native` folder with Elixir bindings in `ats/native.ex`.

#### Local vs API

An other implementation that was possible is by using an API.
However, my idea was to have a mix task that can be run locally without internet.
Of course you will have to download dataset to get access to continents data.
However it's a one time download and it's already included in the git repository.

So here is my list of pro and cons for each implementation.

**Local**

Pros:

- No internet connection required
- Predictive data, so it can be used for test and be deterministic

Cons:

- Can be slow on local machine (depends on the hardware and the dataset chosen)
- Data needs to be updated manually

**API** (like Google Maps for example)

Pros:

- Always accurate, big services are used by millions of peoples and are trusted sources
- No calculation required

Cons:

- Requires internet (that's not a big con)
- Needs a service to be written for (or an external library)
- Rates limiting
- Can be slow for a lot of requests

So, I think the cost of running it locally by using PostGIS (which is fast on small shape)
or by doing computations with a system programming languages (Rust for example)
is lower than using an API.

It's faster to makes the calculation locally than making the request to an external
service. There is no need to think about batching the request or handling errors
(even if Elixir does it well).

## Choice of technologies

### Why Elixir

To build an API that is scalable, fault-tolerant and simple to test, I think Elixir is a perfect fit.
As it is a new language that uses a strong technology (Erlang VM), it is safe to use and in bonus, you
have a more modern syntax.

Otherwise, I could have chosen Go, but, the language as a few issues:

- interface feels really hacky when it is used incorrectly
- the use of pointer is good and bad at the same time (too much error-prone)
- it's GraphQL ecosystem is not mature enough, existing libraries have to use runtime
  features from Go which are known to be unsafe

### Why Rust

I needed raw performances to make geographical calculations, which Elixir can't do because of the
VM implementation.
For this, a system programming languages that can be plugged to NIF was required.
So, I had two choices; C or Rust.

C is great but it is too much unsafe. So, Rust was a great fit with Elixir.
The community has made some great tooling to make Elixir + Rust development easier.
The setup of [rustler](https://github.com/rusterlium/rustler) was a simple command
and "everything" was ready (apart from the code which has to be written).

There is a lot of great articles on why "Elixir + Rust" is great. Here you can find
one from Discord: https://blog.discord.com/using-rust-to-scale-elixir-for-11-million-concurrent-users-c6f19fc029d3

### Why PostgreSQL

I needed a database that was able to do geospatial queries. I had two choices; MongoDB or PostgreSQL.
MongoDB has direct support for GeoJSON, which is pretty good for importing data. Plus, it can handle
GeoSpatial queries pretty well.

However, I choose PostgreSQL because:

- his data is structured
- his integration with Elixir / Ecto is the best (as it is the default)
- PostgreSQL has better performance than MongoDB

Otherwise, for scalability, MongoDB is better as it handles horizontal scaling compared to PostgreSQL.

Links on performances comparison between MongoDB and PostgreSQL:

- https://www.arangodb.com/2018/02/nosql-performance-benchmark-2018-mongodb-postgresql-orientdb-neo4j-arangodb/
- https://www.enterprisedb.com/blog/comparison-joins-mongodb-vs-postgresql
- https://speakerdeck.com/ongres/mongodb-vs-postgresql-performance
