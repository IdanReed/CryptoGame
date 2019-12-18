import { drizzleConnect } from "@drizzle/react-plugin";
import SidebarComp from "./compSideBar";
import TopbarComp from "./compTopBar";

const mapStateToProps = state => {
  return {
    Game: state.contracts.Game,
  };
};

const MainPageCont = drizzleConnect(SidebarComp,TopbarComp, mapStateToProps);

export default MainPageCont;

