import React from 'react';

import {
  AccountData,
  ContractData,
  ContractForm,
} from '@drizzle/react-components';

import Theme from './theme';

const sideBarContainerStyle = {
  ...{
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'flexStart',
    alignItems: 'stretch',
    width: '100%',
    height: '100%',
    backgroundColor: Theme.Colors.lightBg,
  },
  ...Theme.Border,
}

class SideBar extends React.Component{
  render() {
    return (
      <div className="Sidebar" style={sideBarContainerStyle}>
        <SidebarBox>
          <SectorInfo />
        </SidebarBox>
        <SidebarBox>
          <MyInfo />
        </SidebarBox>
      </div>
    )
  }
}

const sidebarBoxStyle = {
  ...{
    marginBottom: "10px",
    height: '100px',
    margin: '20px 20px 0 20px',
    backgroundColor: Theme.Colors.topBg,
  },
  ...Theme.Border
};

function SidebarBox(props){
  return (
      <div className='SidebarBox' style={sidebarBoxStyle}>
        {props.children}
      </div>
  )
}

function SectorInfo() {
  return (
    <div className='SectorInfo'>
        <p>Demo function:
          <ContractData
            contract='Game'
            method='testFunction'
          />
        </p>
    </div>
  )
}

function MyInfo() {
  return (
    <div className='MyInfo'>
      <div className='Account' style={{overflow:'hidden'}}>
        <AccountData accountIndex={0} units="ether" precision={3} />
      </div>
    </div>
  )
}

export default SideBar;