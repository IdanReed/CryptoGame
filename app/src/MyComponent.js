import React from "react";

import {
  AccountData,
  ContractData,
  ContractForm,
} from "@drizzle/react-components";

export default () => (
  <div className="App">
    <p>
      <strong>TEST FROM COMP</strong>
      <ContractData
        contract="Game"
        method="testFunction"
        methodArgs={[]}
      />
    </p>

  </div>
);
