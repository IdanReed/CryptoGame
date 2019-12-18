import { drizzleConnect } from "@drizzle/react-plugin";
import MainPage from "./compMainPage";

const mapStateToProps = state => {
  return {
    Game: state.contracts.Game,
  };
};

const MainPageCont = drizzleConnect(MainPage, mapStateToProps);

export default MainPageCont;