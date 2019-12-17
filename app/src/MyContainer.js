import MyComponent from "./MyComponent";
import { drizzleConnect } from "@drizzle/react-plugin";

const mapStateToProps = state => {
  return {
    Game: state.contracts.Game,
  };
};

const MyContainer = drizzleConnect(MyComponent, mapStateToProps);

export default MyContainer;



