# ReasonML Tic Tac Toe with Imandra

![Imandra](img/imandra_raas_logo.svg "Imandra")

This repo contains a ReasonReact app containing a game of Tic Tac Toe.

See https://docs.imandra.ai/imandra-docs/notebooks/reasonml-tic-tac-toe/ for a walk through of the model, and explanation of the `verify` and `instance` comments throughout the file `src/TicTacToeLogic.re`.

See https://docs.imandra.ai/reasonml-tic-tac-toe/ for the built example.

## Run Project

```sh
npm install
npm start
# in another tab
npm run parcel
```

## Build for Production

```sh
npm run build
npm run parcel:production
```

This will replace the development artifact with an optimized version.

To deploy

```sh
npx gh-pages -d dist
```
