import React, { Component } from "react";
import { DrizzleProvider } from "@drizzle/react-plugin";
import { LoadingContainer } from "@drizzle/react-components";

import "./app.css"; // Styling root

import drizzleOptions from "./drizzleOptions";
import MainPage from "./contMainPage";

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