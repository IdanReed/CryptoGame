import React, { Component } from "react";
import { DrizzleProvider } from "@drizzle/react-plugin";
import { LoadingContainer } from "@drizzle/react-components";

import "./App.css";

import drizzleOptions from "./drizzleOptions";
import MyContainer from "./MyContainer";

class App extends Component {
  render() {
    return (
      <DrizzleProvider options={drizzleOptions}>
        <LoadingContainer>
          <MyContainer />
        </LoadingContainer>
      </DrizzleProvider>
    );
  }
  // render() {
  //   return (
  //     <DrizzleProvider options={drizzleOptions}>
  //       <div>TEST</div>
  //     </DrizzleProvider>
  //   );
  // }
}

export default App;
