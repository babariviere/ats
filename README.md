# ATS: Welcome To The Jungle technical test

To start your Phoenix server:

- Setup the project with `mix setup`
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Datasets

### Continents

Source: https://gist.github.com/cmunns/76fb72646a68202e6bde
Simplified with: https://mapshaper.org

There is 3 datasets for continents in `priv/data`:

- continents_full.geojson: continents in full resolution (high computation)
- continents.geojson: continents_full simplified to 2%
- continents_low.geojson: continents_full simplified to 1%

Simplified versions give us boundaries that are precise enough.
Only issue is that it may give false positive for certains cases (coordinates near
the boundary of the continent).

With given datasets, with a total of `5069` locations. We have:

- `4943` valid locations (with a profession_id too)
- `4898` detected on the medium map.
- `4910` detected on the low map.

This gives us 33 false negatives with the low map and 45 with medium map.

#### Way to improve

Instead of directly checking if point is in the continent, we could sort continents
to get the nearest point first and then

Another solution would be to use a low poly geojson. One example of it could be this one:

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
