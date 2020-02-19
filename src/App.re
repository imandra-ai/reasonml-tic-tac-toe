[@bs.module "emotion"] external css: string => string = "css";

[@react.component]
let make = (~useBrokenLogic) => {
  <div
    className={css(
      "display: flex; flex-direction: column; align-items: center;",
    )}>
    <h1> {React.string("Tic Tac Toe")} </h1>
    <TicTacToe useBrokenLogic />
  </div>;
};
