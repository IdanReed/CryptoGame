import SidebarComp from "./sidebarComp";
import { drizzleConnect } from "@drizzle/react-plugin";

const mapStateToProps = state => {
  return {
    Game: state.contracts.Game,
  };
};

const MainPageCont = drizzleConnect(SidebarComp, mapStateToProps);

export default MainPageCont;

