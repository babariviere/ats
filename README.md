**Table of Contents**

- [ATS: Welcome To The Jungle technical test](#ats-welcome-to-the-jungle-technical-test)
  - [Usage](#usage)
    - [Categorize datasets](#categorize-datasets)
  - [Datasets](#datasets)
    - [Continents](#continents)
      - [Performances](#performances)
      - [Way to improve](#way-to-improve)

# ATS: Welcome To The Jungle technical test

To start your Phoenix server:

- Start database with `docker-compose up -d`
- Setup the project with `mix setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Usage

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

## Datasets

### Continents

Source: https://gist.github.com/cmunns/76fb72646a68202e6bde
Simplified with: https://mapshaper.org

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

#### Way to improve

Instead of directly checking if point is in the continent, we could sort continents
to get the nearest point first and then calculate the value inside the polygon.

Use an external service, like Google Map, where we give the coordinates and it returns the country/continent.
