import React, { Component } from 'react';
import { DrizzleProvider } from "@drizzle/react-plugin";
// import { LoadingContainer } from "@drizzle/react-components";

import drizzleOptions from './drizzleOptions'

class App extends Component {
  render() {
    return (
      <DrizzleProvider options={drizzleOptions}>
        <div>TEST TEST TEST TEST</div>
      </DrizzleProvider>
    );
  }
}

export default App;