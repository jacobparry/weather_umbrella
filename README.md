# WeatherUmbrella

**TODO: Add description**

Getting things running

I assume you already have the following installed:
 * [git](https://git-scm.com/) installed and have cloned this repository.
 * [Homebrew](http://brew.sh/) (MacOS only)

1. Clone this repo

2. Install both the Homebrew and asdf package managers:
   - Install [asdf-vm](https://asdf-vm.com/#/core-manage-asdf)

     ```sh
     # on MacOS just run
     brew install asdf
     ```

3. Install [Elixir](https://elixir-lang.org/) and [erlang](https://www.erlang.org/).
    * I chose to install elixir and erlang using asdf. I find it a relatively painless way to ensure a team is developing with the same erlang and elixir versions.
    * You can run this with elixir and erlang installed using brew, which you likely use, or you can install it via asdf.
   
   - Install Elixir and Erlang using brew. 
        - brew install elixir
   - Using asdf-vm:

     - Install:


       - **Please** take a moment to
         [read and learn more about the tool](https://github.com/asdf-vm/asdf)

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

4. 


Weather.Clients.MetaWeather.get_weather 

Install asdf
* Using:
*