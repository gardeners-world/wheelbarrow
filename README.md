# Wheelbarrow

Simple little Ruby app that:

* Fetches data from our houseplant catalogue Google spreadsheet
* Knocks it into some reasonable JSON-ish structure
* Stores it in MongoDB

## Running it

It's kinda extremely tied to the layout of our spreadsheet, but:

### Do the auth voodoo

From [this](https://developers.google.com/sheets/api/quickstart/ruby), enable the API, run that `quickstart` script and store the `credentials.json` and `token.yaml` under `secrets/` here. I'm not going to pretend to understand how this works

### Build the container

`make build` will do the Docker dance (you should change the name at the top of the `Makefile` though)

### Run it

I have a `docker-compose.yaml` in the parent directory of this, which currently looks like this:

```
version: '3'
services:
  mongo:
    image: 'mongo'

  wheelbarrow:
    image: 'pikesley/wheelbarrow'
    volumes:
      - ./wheelbarrow/wheelbarrow:/opt/wheelbarrow
    command: tail -F /dev/null
```

`docker-compose up` should bring everything up, then from here you should be able to get a shell with `make run` and from there

* run the tests with `rake`
* attempt to gather and store some data with `rake fetch`