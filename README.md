# WeatherUmbrella

Getting things running

I assume you already have the following installed:

- [git](https://git-scm.com/) installed and have cloned this repository.
- [Homebrew](http://brew.sh/) (MacOS only)

- Clone this repo

- Install both the Homebrew and asdf package managers:

  - Install [asdf-vm](https://asdf-vm.com/#/core-manage-asdf)

    ```sh
    # on MacOS just run
    brew install asdf
    ```

- Install [Elixir](https://elixir-lang.org/) and [erlang](https://www.erlang.org/).

  - I chose to install elixir and erlang using asdf. I find it a relatively painless way to ensure a team is developing with the same erlang and elixir versions.
  - You can run this with elixir and erlang installed using brew, which you likely use, or you can install it via asdf.

  - Install Elixir and Erlang using brew.

    - brew install elixir

  - Using asdf-vm:

    - Install:

````
- take a moment to
    - [read and learn more about the tool](https://github.com/asdf-vm/asdf)

     ```sh
     asdf plugin-add erlang
     asdf plugin-add elixir
     ```

    - in the terminal, navigate to the repo directory.

    - Install via asdf. This will install the versions in found in the `.tool-versions` file.
    ```sh
    asdf install
    ```

    - Set the versions of erlang and elixir to the current directory. Can set these globally if you want, but may conflict with a brew installed elixir
    ```sh
    asdf local erlang 24.2
    asdf local elixir 1.13.2-otp-24
    ```
    - Run `asdf current` to confirm that the correct versions are set for the repo.
````

- Once everything is set up and running:

  - Run `mix test`. The tests are all passing for me, as of right now. They'll probably fail for you because I noticed the values change, and I'm testing against the live API here. I know I know, shame on me. I should write the tests to use the mocks, but which I did do. It is split between live and mocked.
  - Inspect the logic, and tests that wrote

    - Main logic found. There are other files, but these contain most of the meat.

      - `forecast.ex`
      - `location.ex`
      - `date_utils.ex`
      - `city_resolver.ex`
      - `weather_saver.ex`

    - Tests are in the corresponding test files.

      - `city_resolver_text.exs` contains a test showing the proof of the technical assement, the average max temp for each of the 3 cities.

  - If you want, you can boot up the graphQL interface and play around with it. The functionality is limited because my schema is simple.

    - `iex -S mix phx.server`
    - <http://localhost:4000/playground/graphiql>
    - run the query to see the data of the proof.
    - I'd spend time here doing this."""

      ```
      {
        triCityDataSequencially {
          name
          averageMaxTemp
        }       
      }
      ```

      """

- Summary of work done:

  - Code structure
  - I created an umbrella with 4 different apps.

    - api

      - Set up an Absinthe Schema, defined a type, and created a resolver to return the data that was asked for in the proof.
      - This is where I think you should spend some time. The `city_resolver.ex` implements the async work.

    - db

      - I didn't do anything here. I originally had plans to do things with with the database, ecto, changesets, but I decided to stop before I ran way with it.

    - ui

      - Set up a graphQL interface for to run a simple query to return the data that was asked for in the proof.

    - weather

      - I spent most of my time here.
      - Set up a http client for MetaWeather.
      - Mocked it two different ways, one with Mox, another with Mimic because I wanted to try mimic. I've heard about it.
      - Created the logic for getting the average max temperature for a city based on a unique identifier and date, if desired

  - Future work:

    - Set up the DB with an ecto schema for the weather predictions.

      - The plan is to save the historical predictions, so that when asked for, I only need to hit MetaWeather if I don't have the historical data saved.
      - Set up a GenServer to poll MetaWeather about once a minute or so. I noticed in their docs that they said please don't hit them more than once a minute. I figured I'd be nice and rate limit myself.
      - Differentiate in the logic for when I need to query the db vs MetaWeather.
      - Flesh out Absinthe and GraphQL to allow more robust querying.

      - There is a bug in one of the genserver resolvers. For some reason, it is loading double data.
