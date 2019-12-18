import React, { Component } from "react";
import { DrizzleProvider } from "@drizzle/react-plugin";
import { LoadingContainer } from "@drizzle/react-components";

import "./app.css"; // Styling root

import drizzleOptions from "./drizzleOptions";
import MainPage from "./mainPageCont";

// const mainPageStyle = {
//   height: '100%',
//   width: '100%',
//   position: 'relative',
//   top: 0,
//   left: 0,
//   margin: 0,

//   backgroundColor: 'black',
// };

class App extends Component {
  render() {
    return (
        <DrizzleProvider options={drizzleOptions}>
          <LoadingContainer >
            <MainPage />
          </LoadingContainer>
        </DrizzleProvider>
    );
  }
}

export default App;