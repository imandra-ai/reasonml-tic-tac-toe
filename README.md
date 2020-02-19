# ReasonML Tic Tac Toe with Imandra

![Imandra](img/imandra_raas_logo.svg "Imandra")

This repo contains a ReasonReact app containing a game of Tic Tac Toe.

See https://docs.imandra.ai/imandra-docs/notebooks/reasonml-tic-tac-toe/ for a walk through of the model, and explanation of the `verify` and `instance` comments throughout the file `src/TicTacToeLogic.re`.

See https://docs.imandra.ai/reasonml-tic-tac-toe/ for the built example.

## Run Project

You'll need a docker image with `imandra-extract` in it pre-pulled to convert the Imandra source file `src/TicTacToeLogic.ire` to regular OCaml so it can be compiled with bucklescript (the conversion is done using bucklescript generators, see `bsconfig.json`):

```sh
docker pull imandra/imandra-client-switch
```

```sh
npm install
npm start
# in another tab
npm run parcel
```

Then visit http://localhost:1234/index.html or http://localhost:1234/index-initial.html for the version of the model that contains the deliberate bug.

## Build for Production

```sh
npm run build
npm run parcel:production
```

This will replace the development artifact with an optimized version.

To deploy:

```sh
npm run deploy
```
