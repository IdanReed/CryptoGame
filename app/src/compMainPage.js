import React from 'react';

import {
  AccountData,
  ContractData,
  ContractForm,
} from '@drizzle/react-components';

import Theme from './theme';

import SideBar from "./compSideBar";
import TopBar from "./compTopBar";
import WorldView from "./compWorldView";


const mainPageGridStyle = {
  display: 'grid',
  gridTemplateColumns: 'auto 300px',
  gridTemplateRows: '50px auto',
  height: '100%',
  width: '100%',
}

const sideBarGridStyle = {
  ...{
    gridColumnStart: 2,
    gridRowStart: 1,
    gridRowEnd: 'span 2',
  },
  ...Theme.Border,
}

const topBarGridStyle = {
  ...{
    gridColumnStart: 1,
    gridRowStart: 1,
  },
  ...Theme.Border,
}

const worldViewGridStyle = {
  ...{
    gridColumnStart: 1,
    gridRowStart: 2,
  },
  ...Theme.Border,
}

class MainPage extends React.Component{
    render() {
      return (
        <div className="grid" style={mainPageGridStyle}>
            <div className="gridItem" style={sideBarGridStyle}>
              <SideBar />
            </div>
            <div className="gridItem" style={topBarGridStyle}>
              <TopBar />
            </div>
            <div className="gridItem" style={worldViewGridStyle}>
              <WorldView />
            </div>
        </div>
      )
    }
}

export default MainPage;