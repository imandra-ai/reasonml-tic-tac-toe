[@bs.module "emotion"] external css: string => string = "css";

type state = {
  game: TicTacToeLogic.game_state,
  status: TicTacToeLogic.game_status,
};

type action =
  | Move(TicTacToeLogic.move)
  | Restart;

let initialState = {
  game: TicTacToeLogic.initial_game,
  status: TicTacToeLogic.status(TicTacToeLogic.initial_game),
};

let reducer = (~useBrokenLogic, action, state) =>
  switch (action) {
  | Restart => ReactUpdate.Update(initialState)
  | Move(move) =>
    let play =
      TicTacToeLogic.play(
        if (useBrokenLogic) {TicTacToeLogic.is_valid_move_broken} else {
          TicTacToeLogic.is_valid_move
        },
      );

    let (next, status) = play(state.game, move);
    let newState = {status, game: next};
    switch (status) {
    | Won(_)
    | Tied => ReactUpdate.Update(newState)
    | InProgress
    | InvalidMove(_) => ReactUpdate.Update(newState)
    };
  };

[@react.component]
let make = (~useBrokenLogic) => {
  let (state, send) =
    ReactUpdate.useReducer(initialState, reducer(~useBrokenLogic));

  let label = s =>
    switch (s) {
    | None => ""
    | Some(TicTacToeLogic.X) => "X"
    | Some(TicTacToeLogic.O) => "O"
    };

  let disabled =
    switch (state.status) {
    | InProgress => false
    | InvalidMove(_) => false
    | _ => true
    };
  let buttonCss = b => {
    let base = css("display: block; width: 78px; height: 78px; margin: 3px;");
    switch (state.status) {
    | InvalidMove(m) when b == m =>
      base ++ " " ++ css("border: solid 1px red !important")
    | _ => base
    };
  };
  let overlay =
    switch (state.status) {
    | Tied => Some("=")
    | Won(X) => Some("X")
    | Won(O) => Some("O")
    | _ => None
    };
  let rowCss = css("display: flex; flex-direction: row");
  let elems =
    <div>
      <div className=rowCss>
        <button
          className={buttonCss(A)}
          onClick={_event => send(Move(A))}
          disabled>
          {React.string(label(state.game.grid.a))}
        </button>
        <button
          className={buttonCss(B)}
          onClick={_event => send(Move(B))}
          disabled>
          {React.string(label(state.game.grid.b))}
        </button>
        <button
          className={buttonCss(C)}
          onClick={_event => send(Move(C))}
          disabled>
          {React.string(label(state.game.grid.c))}
        </button>
      </div>
      <div className=rowCss>
        <button
          className={buttonCss(D)}
          onClick={_event => send(Move(D))}
          disabled>
          {React.string(label(state.game.grid.d))}
        </button>
        <button
          className={buttonCss(E)}
          onClick={_event => send(Move(E))}
          disabled>
          {React.string(label(state.game.grid.e))}
        </button>
        <button
          className={buttonCss(F)}
          onClick={_event => send(Move(F))}
          disabled>
          {React.string(label(state.game.grid.f))}
        </button>
      </div>
      <div className=rowCss>
        <button
          className={buttonCss(G)}
          onClick={_event => send(Move(G))}
          disabled>
          {React.string(label(state.game.grid.g))}
        </button>
        <button
          className={buttonCss(H)}
          onClick={_event => send(Move(H))}
          disabled>
          {React.string(label(state.game.grid.h))}
        </button>
        <button
          className={buttonCss(I)}
          onClick={_event => send(Move(I))}
          disabled>
          {React.string(label(state.game.grid.i))}
        </button>
      </div>
    </div>;
  let sub =
    switch (overlay) {
    | None => [|elems|]
    | Some(overlayText) => [|
        elems,
        <div
          className={css(
            "position: absolute; top: 0; left: 0; width: 100%; height: 100%; text-align: center; font-size: 150px; display: flex; flex-direction: row; justify-content: space-around; background: #FBFBFB; color: #3276B5; user-select: none; cursor: pointer;",
          )}
          onClick={_event => send(Restart)}>
          <div
            className={css(
              "display: flex; flex-direction: column; justify-content: space-around;",
            )}>
            {React.string(overlayText)}
          </div>
        </div>,
      |]
    };

  <div className={css("position: relative; display: flex;")}>
    {React.array(sub)}
  </div>;
};
